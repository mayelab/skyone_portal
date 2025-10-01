library(shiny)

shinyApp(
  ui = htmlTemplate("portal_pru.html"),
  server = function(input, output, session) {}
)