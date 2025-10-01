library(httr)
library(jsonlite)

# URL del API interno de ShinyProxy para contar usuarios de portal-shared
shinyproxy_api <- "http://localhost:8080/api/v1/apps/crm/instances"
max_shared_users <- 5

redirect_to_portal <- function() {
  res <- GET(shinyproxy_api)
  instances <- fromJSON(content(res, "text", encoding = "UTF-8"))
  active_users <- length(instances)
  
  return(paste0("/app/crm_", active_users))
}

redirect_url <- redirect_to_portal()



# Genera HTML con redirección automática
cat(sprintf('<meta http-equiv="refresh" content="0;url=%s">', redirect_url))