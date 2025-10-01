library(shiny)

shinyApp(
  ui = htmlTemplate("portal.html"),
  server = function(input, output, session) {}
)