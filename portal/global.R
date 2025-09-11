#134.209.160.176:3838/portal
#sudo cp -r /home/skyone/portal/ /srv/shiny-server
#cd /var/log/shiny-server


library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(dplyr)
#library(tidyverse)
#library(readr)
library(rvest)
library(leaflet)
library(stringr)
#library(DT)
#library(data.table)
#library(rgdal)
#library(raster)
#library(leaflet.extras)
#library(geosphere) 
#library(sp)
library(sf)
#library(editData)
#library(shinyalert)
#library(shinyWidgets)
#library(remotes)
#library(openrouteservice)
#library(hereR)
#library(osrm)
library(shinybusy)
library(RMySQL)
#library(lwgeom)
library(DBI)
library(shinyjs)
#library(digest)
#library(lubridate)
#library(stringi)
library(blastula)
#library(tcltk)
library(httr)
#library(jsonlite)
#library(rlist)

#library(vembedr)
#library(rgeos)

library(aws.s3)
library(base64enc)

#library(magick)
library(colorspace)

#library(callr)

#library(fontawesome)
#library(toastui)

#library(tinytex)
#install_tinytex()
#library(glue)
#library(sortable) #arrastrar para ordenar

#library(slickR) #carousel de fotos

#library(metathis) #metadatos para el reporte html

#library(qrcode)
#library(rclipboard)

#remotes::install_github("RinteRface/waypointer")
library(waypointer)


#options(shiny.trace = TRUE)
options(encoding = "UTF-8")
options(rmarkdown.html_vignette.check_title = FALSE)
options(shiny.sanitize.errors = FALSE)


inmo_per_page <- 9
inmo_max_pages <- 8
proy_per_page <- 14
proy_max_pages <- 8

empresa <- "SkyOne"
co <- str_to_lower(empresa)

main_color <- "#37688a"

ini_view <- c(-25.287773045354367, -57.600541080756344)
place <- data.frame(lat = ini_view[1], lng = ini_view[2])

Sys.setenv(MAIL_PASS='wswsdqectfzdtqmk')

options(mysql = list(
  "host" = "placeanalyzerdb-do-user-9117395-0.b.db.ondigitalocean.com",
  "port" = 25060,
  "user" = "doadmin",
  "password" = "k03msju7c86b4pmy",
  "databaseName" = "defaultdb"
))

options(digOcean = list(
  "spaces_region" = "nyc3.digitaloceanspaces.com",
  "spaces_key" = "42KYULBUAY4XLCOU3JY5",
  "spaces_secret" = "MTPwfFqaaxghPEy4oV/6eX4yOKGuL302UIq46/LNMEY",
  "spaces_base" = "place-storage",
  "bucket" = "place-storage"
))

dollarExchange <- function(){
  result <- GET("https://www.xe.com/es/currencyconverter/convert/?Amount=1&From=USD&To=PYG")
  text <- read_html(result) %>% html_text2()
  camb1 <- str_split(text, "PYG1 USD")[[1]][2]
  cambio <- str_split(camb1, " PYG5 USD")[[1]][1] %>% str_replace_all(",", ".") %>% as.numeric() %>% round()
  return(data.frame(compra=cambio, venta=cambio))
}

create_folder_do <- function(folder){
  aws.s3::s3HTTP(verb = "PUT",
                 path = paste0(folder),
                 request_body = raw(0),
                 region = options()$digOcean$spaces_base,
                 key = options()$digOcean$spaces_key,
                 secret = options()$digOcean$spaces_secret,
                 base_url = options()$digOcean$spaces_region,
                 headers = list(`x-amz-acl` = "public-read"))
}

delete_object_do <- function(object){
  aws.s3::s3HTTP(verb = "DELETE",
                 path = object,
                 region = options()$digOcean$spaces_base,
                 key = options()$digOcean$spaces_key,
                 secret = options()$digOcean$spaces_secret,
                 base_url = options()$digOcean$spaces_region,
                 headers = list(`x-amz-acl` = "public-read"))
}

put_object_do <- function(destiny, object){
  aws.s3::s3HTTP(verb = "PUT",
                 path = destiny,
                 request_body = object,
                 region = options()$digOcean$spaces_base,
                 key = options()$digOcean$spaces_key,
                 secret = options()$digOcean$spaces_secret,
                 base_url = options()$digOcean$spaces_region,
                 headers = list(`x-amz-acl` = "public-read"))
}

get_object_do <- function(object){
  r <- aws.s3::s3HTTP(verb = "GET",
                 path = paste0("/", object),
                 region = options()$digOcean$spaces_base,
                 key = options()$digOcean$spaces_key,
                 secret = options()$digOcean$spaces_secret,
                 base_url = options()$digOcean$spaces_region,
                 headers = list(`x-amz-acl` = "public-read"))
  cont <- httr::content(r, as = "raw")
  return(cont)
}

list_spaces_do <- function(prefix = NULL, delimiter = NULL, max = 1000){
  query <- list(prefix = prefix, delimiter = delimiter, "max-keys" = NULL, marker = NULL)
  r <- aws.s3::s3HTTP(verb = "GET",
                      query = query,
                      region = options()$digOcean$spaces_base,
                      key = options()$digOcean$spaces_key,
                      secret = options()$digOcean$spaces_secret,
                      base_url = options()$digOcean$spaces_region,
                      headers = list(`x-amz-acl` = "public-read"))

  query_2 <- list(prefix = prefix, delimiter = delimiter, "max-keys" = max, marker = tail(r, 1)[["Contents"]][["Key"]])
  extra <- aws.s3::s3HTTP(verb = "GET",
                          query = query_2,
                          parse_response = TRUE,
                          region = options()$digOcean$spaces_base,
                          key = options()$digOcean$spaces_key,
                          secret = options()$digOcean$spaces_secret,
                          base_url = options()$digOcean$spaces_region,
                          headers = list(`x-amz-acl` = "public-read"))
  
  new_r <- c(r, tail(extra, -5))
  new_r[["MaxKeys"]] <- as.character(extra[["MaxKeys"]])
  new_r[["IsTruncated"]] <- extra[["IsTruncated"]]
  attr(new_r, "x-amz-id-2") <- attr(r, "x-amz-id-2")
  attr(new_r, "x-amz-request-id") <- attr(r, "x-amz-request-id")
  attr(new_r, "date") <- attr(r, "date")
  attr(new_r, "x-amz-bucket-region") <- attr(r, "x-amz-bucket-region")
  attr(new_r, "content-type") <- attr(r, "content-type")
  attr(new_r, "transfer-encoding") <- attr(r, "transfer-encoding")
  attr(new_r, "server") <- attr(r, "server")
  r <- new_r
  
  for (i in which(names(r) == "Contents")) {
    r[[i]][["Size"]] <- as.numeric(r[[i]][["Size"]])
    attr(r[[i]], "class") <- "s3_object"
  }
  att <- r[names(r) != "Contents"]
  r[names(r) != "Contents"] <- NULL
  
  # collapse CommonPrefixes elements
  cp <- att[names(att) == "CommonPrefixes"]
  att[names(att) == "CommonPrefixes"] <- NULL
  att[["CommonPrefixes"]] <- as.character(cp)

  out <- structure(r, class = "s3_bucket")
  attributes(out) <- c(attributes(out), att)
  if(length(out) > 0){
    out$Contents$Bucket <- NA
    dat <- as.data.frame(out)
    dat <- dat %>% select(Key, LastModified, Size) %>% 
      mutate(Type = ifelse(str_ends(Key, "/"), "dir", "file"),
             Order = str_count(Key, "/"))
    dat <- dat[!duplicated(dat$Key),]
  }else{
    dat <- structure(list(Key = character(0),
                          LastModified = character(0),
                          Size = character(0),
                          Type = character(0),
                          Order = character(0)),
                     class = "data.frame",
                     row.names = character(0))
  }
  return(dat)
}


killDbConnections <- function () {
  all_cons <- dbListConnections(MySQL())
  print(all_cons)
  for(con in all_cons)
    +  dbDisconnect(con)
  print(paste(length(all_cons), " connections killed."))
}

new_id_table_mysql <- function(id, table, prefix, digits){
  conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                    port = options()$mysql$port, user = options()$mysql$user, 
                    password = options()$mysql$password)
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, paste0("SELECT MAX (", id, ") FROM ", table, ";"))
  dbDisconnect(conn)
  if(is.na(data)){
    serie <- 1
  }else{
    serie <- as.numeric(str_extract(data, "\\d+")) + 1
  }
  new_id <- paste0(prefix, str_pad(serie, digits, pad = "0"))
  return(new_id)
}

save_mysql <- function(data, table, overwrite, ext_conn = FALSE, conn = NA) {
  names <- colnames(data)
  classes <- lapply(data, FUN = function(x) ifelse(length(class(x)) > 1, class(x)[1], class(x))) %>%
    unlist()
  if(sum(str_detect(classes, "sfc_")) == 1){
    ind <- which(str_detect(classes, "sfc_"))
    geom <- data[, ind]
    names[ind] <- "geometry"
    colnames(data) <- names
    data$geometry <- NULL
    data$geometry <- st_astext(geom)
  }
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  if(overwrite == TRUE){
    dbGetQuery(conn, "SET NAMES 'utf8mb4'")
    dbGetQuery(conn, paste0("TRUNCATE ", table, ";"))
  }
  query <- df_to_sql(data, table)
  dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  dbGetQuery(conn, query)
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
}

load_mysql <- function(table, ext_conn = FALSE, conn = NA){
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  
  query <- sprintf("SELECT * FROM %s", table)
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, query)
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
  if(nrow(data) != 0){
    if(nrow(data) == 1){
      data <- rbind(data, data)
      one_row <- TRUE
    }else{
      one_row <- FALSE
    }
    for(i in 1:ncol(data)){
      if(class(data[,i]) == "character"){
        data[,i] <- str_replace_all(data[,i], "U\\+0027", "'") %>% data.frame()
      }
    }
    data <- data %>% mutate_all(~replace(., . == "NA", NA))
    if(one_row == TRUE){data <- data[1,]}
    if("geometry" %in% colnames(data)){
      data <- st_as_sf(data, wkt = "geometry", crs = crs)
    }
  }
  data
}

df_to_sql <- function(data, table){
  if(nrow(data) == 1){
    data <- rbind(data, data)
    one_row <- TRUE
  }else{
    one_row <- FALSE
  }
  values <- apply(data, 2, str_replace_all, "'", "U+0027") %>% data.frame
  if(one_row == TRUE){values <- values[1,]}
  values <- paste0(apply(values, 1, function(x) paste0("('", paste0(x, collapse = "', '"), "')")), collapse = ", ")
  colname <- paste0(" (", paste0(colnames(data), collapse = ", "), ")")
  paste0("INSERT INTO ", table, colname," VALUES ", values, ";")
}

filter_box_table_mysql <- function(lat_min, lat_max, lon_min, lon_max, table){
  conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                    port = options()$mysql$port, user = options()$mysql$user, 
                    password = options()$mysql$password)
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  col <- dbGetQuery(conn, paste0("SHOW COLUMNS FROM ", table))
  
  if("lon" %in% col$Field){
    longitud <- "lon"
  }else{
    longitud <- "lng"
  }
  data <- dbGetQuery(conn, paste0("SELECT * FROM ", table, " WHERE ", table, ".lat  BETWEEN ", lat_min, 
                                  " AND ", lat_max, " AND ", table, ".", longitud, " BETWEEN ", lon_min, 
                                  " AND ", lon_max, ";"))
  dbDisconnect(conn)
  
  if(nrow(data) != 0){
    data <- data %>% mutate_all(~replace(., . == "NA", NA))
    for(i in 1:ncol(data)){
      if(class(data[,i]) == "character"){
        data[,i] <- str_replace_all(data[,i], "U\\+0027", "'") %>% data.frame()
      }
    }
    if("geometry" %in% colnames(data)){
      data <- st_as_sf(data, wkt = "geometry", crs = crs)
    }
  }
  return(data)
}

update_var_user_table_mysql <- function(new_info, var, user, table, ext_conn = FALSE, conn = NA){
  user <- paste("(", paste(paste0("'", user,"'"),collapse = ","), ")")
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  dbGetQuery(conn, paste0("UPDATE ", table, " SET ", table, ".", var, " = '", new_info, 
                          "' WHERE ", table, ".user in ", user, ";"))
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
}

update_var_id_table_mysql <- function(new_info, var, id, table, ext_conn = FALSE, conn = NA){
  id <- paste("(", paste(paste0("'", id,"'"),collapse = ","), ")")
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  dbGetQuery(conn, paste0("UPDATE ", table, " SET ", table, ".", var, " = '", new_info, 
                          "' WHERE ", table, ".id in ", id, ";"))
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
}

list_table_var1_var2_var3_mysql <- function(table, var1, info1, var2, info2, var3, cond3, info3, ext_conn = FALSE, conn = NA){
  info1 <- paste("(", paste(paste0("'", info1,"'"),collapse = ","), ")")
  info2 <- paste("(", paste(paste0("'", info2,"'"),collapse = ","), ")")
  info3 <- paste("(", paste(paste0("'", info3,"'"),collapse = ","), ")")
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, paste0("SELECT * FROM ", table, " WHERE ", var1, " in ", info1,
                                  " AND ", var2, " IN ", info2, " AND ", var3, " ", cond3, " ", info3, ";"))
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
  if(nrow(data) != 0){
    data <- data %>% mutate_all(~replace(., . == "NA", NA))
    for(i in 1:ncol(data)){
      if(class(data[,i]) == "character"){
        data[,i] <- str_replace_all(data[,i], "U\\+0027", "'") %>% data.frame()
      }
    }
    if("geometry" %in% colnames(data)){
      data <- st_as_sf(data, wkt = "geometry", crs = crs)
    }
  }
  return(data)
}

list_table_var1_var2_mysql <- function(table, var1, info1, var2, info2, ext_conn = FALSE, conn = NA){
  info1 <- paste("(", paste(paste0("'", info1,"'"),collapse = ","), ")")
  info2 <- paste("(", paste(paste0("'", info2,"'"),collapse = ","), ")")
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, paste0("SELECT * FROM ", table, " WHERE ", var1, " in ", info1,
                                  " AND ", var2, " in ", info2, ";"))
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
  if(nrow(data) != 0){
    data <- data %>% mutate_all(~replace(., . == "NA", NA))
    for(i in 1:ncol(data)){
      if(class(data[,i]) == "character"){
        data[,i] <- str_replace_all(data[,i], "U\\+0027", "'") %>% data.frame()
      }
    }
    if("geometry" %in% colnames(data)){
      data <- st_as_sf(data, wkt = "geometry", crs = crs)
    }
  }
  return(data)
}

list_table_var_mysql <- function(table, var, info, ext_conn = FALSE, conn = NA){
  info <- paste("(", paste(paste0("'", info,"'"),collapse = ","), ")")
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, paste0("SELECT * FROM ", table, " WHERE ", var, " in ", info, ";"))
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
  if(nrow(data) != 0){
    data <- data %>% mutate_all(~replace(., . == "NA", NA))
    for(i in 1:ncol(data)){
      if(class(data[,i]) == "character"){
        data[,i] <- str_replace_all(data[,i], "U\\+0027", "'") %>% data.frame()
      }
    }
    if("geometry" %in% colnames(data)){
      data <- st_as_sf(data, wkt = "geometry", crs = crs)
    }
  }
  return(data)
}

list_table_var1_var2_cond_mysql <- function(table, var1, info1, var2, cond, info2, ext_conn = FALSE, conn = NA){
  info1 <- paste("(", paste(paste0("'", info1,"'"),collapse = ","), ")")
  info2 <- paste("(", paste(paste0("'", info2,"'"),collapse = ","), ")")
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, paste0("SELECT * FROM ", table, " WHERE ", var1, " in ", info1, " AND ", var2, " ", cond, " ", info2, ";"))
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
  if(nrow(data) != 0){
    data <- data %>% mutate_all(~replace(., . == "NA", NA))
    for(i in 1:ncol(data)){
      if(class(data[,i]) == "character"){
        data[,i] <- str_replace_all(data[,i], "U\\+0027", "'") %>% data.frame()
      }
    }
    if("geometry" %in% colnames(data)){
      data <- st_as_sf(data, wkt = "geometry", crs = crs)
    }
  }
  return(data)
}

query_mysql <- function(query){
  conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                    port = options()$mysql$port, user = options()$mysql$user, 
                    password = options()$mysql$password)
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  if(nrow(data) != 0){
    data <- data %>% mutate_all(~replace(., . == "NA", NA))
    for(i in 1:ncol(data)){
      if(class(data[,i]) == "character"){
        data[,i] <- str_replace_all(data[,i], "U\\+0027", "'") %>% data.frame()
      }
    }
    if("geometry" %in% colnames(data)){
      data <- st_as_sf(data, wkt = "geometry", crs = crs)
    }
  }
  return(data)
}

last_id_table_mysql <- function(table, ext_conn = FALSE, conn = NA){
  if(ext_conn == FALSE){
    conn <- dbConnect(MySQL(), dbname = options()$mysql$databaseName, host = options()$mysql$host, 
                      port = options()$mysql$port, user = options()$mysql$user, 
                      password = options()$mysql$password)
  }
  data <- dbGetQuery(conn, "SET NAMES 'utf8mb4'")
  data <- dbGetQuery(conn, paste0("SELECT MAX(id) FROM ", table, ";"))
  if(ext_conn == FALSE){
    dbDisconnect(conn)
  }
  return(data)
}

options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=2)

crs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

pin_circle <- makeIcon(
  iconUrl = "circle_marker.png",
  iconWidth = 80, iconHeight = 80,
  iconAnchorX = 40, iconAnchorY = 40
)

icon_inmo <- function(tipo){
  name = case_when(tipo %in% c("Terreno", "Propiedad rural") ~ "terreno_marker_azul.png",
                   tipo == "Duplex" ~ "duplex_marker_azul.png",
                   tipo %in% c("Casa", "Casa quinta") ~ "inmo_marker_azul.png",
                   tipo %in% c("Departamento", "Proyecto", "Edificio") ~ "depa_marker_azul.png",
                   tipo %in% c("Deposito", "Tinglado") ~ "deposito_marker_azul.png",
                   tipo %in% c("Oficina", "Salón comercial") ~ "oficina_marker_azul.png")
  icon <- makeIcon(
    iconUrl = paste0("./www/", name),
    iconWidth = 50, iconHeight = 50,
    iconAnchorX = 25, iconAnchorY = 50
  )
  return(icon)
}

generate_pages <- function(data, per_page, max_pages, page_selected){
  total <- nrow(data)
  print(per_page)
  print(max_pages)
  print(page_selected)
  print(total)
  if(total != 0){
    last_page <- total %% per_page
    n_pages <- (total - last_page)/per_page
    ifelse(last_page != 0, n_pages <- n_pages + 1, last_page <- per_page)
    min <- page_selected - round(max_pages/2)
    dif_min <- ifelse(min < 1, abs(min) + 1, 0)
    max <- page_selected + round(max_pages/2)
    dif_max <- ifelse(max - n_pages > 0, max - n_pages, 0)
    min <- min - dif_max
    max <- max + dif_min
    if(min < 1) min <- 1
    if(max > n_pages) max <- n_pages
    if(n_pages == 1){
      data_per_page <- data[1:last_page,]
    }else{
      if(page_selected == n_pages){
        data_per_page <- data[1:last_page,]
      }else{
        data_per_page <- data[1:per_page,]
      }
    }
    print("page selected")
    print(page_selected)
    print("n_pages")
    print(n_pages)
    print("last page")
    print(last_page)
    print("data_per_page")
    print(data_per_page)
    return(list(data = data_per_page, n_pages = n_pages, last_page = last_page, min = min, max = max))
  }else{
    return(list(data = data, n_pages = 0, last_page = 0, min = 0, max = 0))
  }
}
 
agencia_name <- function(user, agencias, franquicias){
  if(user$agencia == "Global Master Office"){
    agencia_name <- "Global Master Office"
  }else{
    if(user$agencia %in% agencias$id){
      agencia_name <- agencias$name[agencias$id == user$agencia]
    }else{
      if(user$agencia %in% franquicias$id){
        agencia_name <- franquicias$name[franquicias$id == user$agencia]
      }
    }
  }
  return(agencia_name)
}

num_fotos_inmo <- function(img, small){
  id <- str_split(str_split(img, "fotos-inmo/")[[1]][2], "-")[[1]][1]
  serie <- str_extract(img, "_[0-9][0-9][0-9]-small") %>% str_remove("_") %>% str_remove("-small")
  
  list <- list_spaces_do(prefix = paste0("fotos-inmo/", id, "-"))
  if(small){
    list <- list[str_detect(list$Key, paste0(serie, "-small.jpg")),]
  }else{
    list <- list[str_detect(list$Key, paste0(serie, ".jpg")),]
  }
  print("num_fotos list")
  print(isolate(list))
  if(nrow(list) == 0){
    return(c())
  }else{
    return(paste0("https://place-storage.nyc3.digitaloceanspaces.com/", list$Key))
  }
} 
