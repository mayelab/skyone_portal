library(shiny)
library(httr)
library(jsonlite)

shinyApp(
  ui = fluidPage(
    tags$h3("Redirigiendo al portal..."),
    # Script de redirección que se ejecuta en el navegador
    uiOutput("redirect_script")
  ),
  server = function(input, output, session) {
    
    shinyproxy_api <- "http://localhost:8080/api/v1/apps/crm/instances"
    max_shared_users <- as.numeric(Sys.getenv("MAX_SHARED_USERS", 5))
    
    # Función para decidir a qué app redirigir
    redirect_to_portal <- function() {
      res <- GET(shinyproxy_api)
      instances <- fromJSON(content(res, "text", encoding = "UTF-8"))
      active_users <- length(instances)
      
      return(paste0("/app/crm_", active_users))
    }
    
    redirect_url <- redirect_to_portal()
    
    # UI Output con JS que hace la redirección
    output$redirect_script <- renderUI({
      tags$script(HTML(sprintf("window.location.replace('%s');", redirect_url)))
    })
  }
)