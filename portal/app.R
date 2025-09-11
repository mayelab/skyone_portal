source("global.R", local=TRUE)

ui <- div(style = "background-color: #DEEBF7",
          
          tags$head(includeHTML(("google_analytics.html"))),
          
          tags$script('
              $(document).ready(function () {
                function getLocation(callback){
                var options = {
                  enableHighAccuracy: false,
                  timeout: 5000,
                  maximumAge: 0
                };
                navigator.geolocation.getCurrentPosition(onSuccess, onError);
                function onError (err) {
                  Shiny.onInputChange("geolocation", false);
                }
                function onSuccess (position) {
                  setTimeout(function () {
                    var coords = position.coords;
                    var timestamp = new Date();
                    console.log(coords.latitude + ", " + coords.longitude, "," + coords.accuracy);
                    Shiny.onInputChange("geolocation", true);
                    Shiny.onInputChange("lat", coords.latitude);
                    Shiny.onInputChange("lng", coords.longitude);
                    Shiny.onInputChange("accuracy", coords.accuracy);
                    Shiny.onInputChange("time", timestamp)
                    console.log(timestamp);
                    if (callback) {
                      callback();
                    }
                  }, 1100)
                }
              }
              var TIMEOUT = 2000; //SPECIFY
              var started = false;
              function getLocationRepeat(){
                //first time only - no delay needed
                if (!started) {
                  started = true;
                  getLocation(getLocationRepeat);
                  return;
                }
                setTimeout(function () {
                  getLocation(getLocationRepeat);
                }, TIMEOUT);
              };
              getLocationRepeat();
            });
            '),
          
          tags$head(tags$script('
                                var dimension = [0, 0];
                                $(document).on("shiny:connected", function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                                $(window).resize(function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                            ')),
          
          tags$head(tags$style(HTML("
  
  .marker-custom-small {
  background-color: rgba(157, 160, 168, 1) !important;
    }
.marker-custom-small div {
    background-color: rgba(116, 119, 125, 1) !important;
    }
.marker-custom-small div {
    color: white;
    }

.marker-custom-medium {
    background-color: rgba(134, 149, 188, 1) !important;
    }
.marker-custom-medium div {
    background-color: rgba(68, 88, 139, 1) !important;
    }
.marker-custom-medium div {
    color: white;
    }

.marker-custom-large {
    background-color: rgba(172, 192, 241, 1) !important;
    }
.marker-custom-large div {
    background-color: rgba(105, 144, 240, 1) !important;
    }
.marker-custom-large div {
    color: white;
}
    
                                 #inline input{border-radius: 10px; background-color: white}
                                 #inline .selectize-input{border-radius: 10px; background-color: white}
                                 #inline textarea{border-radius: 10px; background-color: white}
                                 #inline label{font-weight: normal: background-color: white}
                                 #inline button{border-radius: 10px; background-color: white;}
    
    #filtro_portal .selectize-input{border-radius: 0px; background-color: transparent; border-color: transparent}
    #filtro_portal .selectize-dropdown {z-index: 10000}   
                                   
                                .modal-content {max-width: 727px;}   
                                   
                                .modal-content  {-webkit-border-radius: 10px !important;
                                                 box-shadow: rgba(0, 0, 0, 0.6) 10px 20px 30px 0px;
                                                 font-weight: 400 !important;
                                                 weight: light !important}
                                .modal-header  {background-color: ", main_color," !important; 
                                                border: 0px !important;
                                                border-top-left-radius: 10px !important; 
                                                border-top-right-radius: 10px !important;
                                                height: 50px !important;
                                                padding: 0px !important}
                                .modal-body {background-color: #d1d3cf !important;
                                             border: 0px !important;
                                             border-bottom-left-radius: 10px !important; 
                                             border-bottom-right-radius: 10px !important;
                                             font-weight: 400 !important}

                                #modal_inmo_double .modal-content  {max-width: 717px !important!; left: 50% !important; transform: translate(-50%) !important;}
                                #modal_inmo_double .modal-body  {padding: 15px !important;}

                                  #bttn_modal button {background-color: ", main_color, "; color: white;
                                                    font-size: 130%; border-radius: 20px; border: 0px}
                                                    
                                   #icon_info {width: 30px; transition: ease-in-out all .4s;}
                                  .icon_label {opacity: 0; position: absolute; margin-top: -10px;}
                                   #icon_info:hover .icon_label {opacity: 1; width: 120px}
                                               
                                .icon_right {margin-right: 10px}                 
    
"))),
          navbarPage(
            title = a(href = "https://skyone.group/crm", img(src="logo_skyone_report.png", style = "height: 30px; margin-top: -5px")), 
            id = "navBar",
            theme = "paper.css",
            collapsible = TRUE,
            inverse = TRUE,
            windowTitle = "SkyOne Real Estate Latam",
            position = "fixed-top",
            footer = div(style = paste0("background-color:", main_color, "; min-height: 150px; padding: 20px"),
                         fluidRow(
                           column(4, align = "center",
                                  img(src = "skyone_logo_blanco.png", width = 150),
                                  br(),
                                  br()
                           ),
                           column(5, align = "center",
                                  HTML(paste0("<p><span style='font-size: 130%; font-weight: normal; color: white'><i class='fa fa-phone'></i>
                                                     +595 984916849</span></p>")),
                                  HTML(paste0("<p><span style='font-size: 130%; font-weight: normal; color: white'><i class='fa fa-map-marker'></i>
                                                     Avenida España 2045 esq. Luis Morales</span></p>"))
                           ),
                           column(3, align = "center",
                                  HTML(paste0("<p><span style='font-size: 130%; font-weight: normal; color: white'><i class='fa fa-thumbs-o-up'></i>
                                                     Síguenos</span></p>")),  
                                  div(style = "display: inline-block",
                             a(href = "https://www.facebook.com/pySkyOne", target="_blank", 
                               HTML("<p><span style='font-size: 180%; font-weight: normal; color: white'><i class='fa fa-facebook'></i></span></p>"))
                                  ),
                             div(style = "display: inline-block; margin-left: 30px",
                             a(href = "https://www.instagram.com/skyone.py", target="_blank", 
                               HTML("<p><span style='font-size: 180%; font-weight: normal; color: white'><i class='fa fa-instagram'></i></span></p>"))
                             )
                           )
                         )
            ),
            header = tags$style(
              ".navbar-right {
                       float: right !important;
                       }",
              "body {padding-top: 50px !important;}"),
            
            tabPanel("HOME", value = "home",
                     use_waypointer(),
                     shinyjs::useShinyjs(),
                     
                     tags$head(tags$script(HTML('
                                                       var fakeClick = function(tabName) {
                                                       var dropdownList = document.getElementsByTagName("a");
                                                       for (var i = 0; i < dropdownList.length; i++) {
                                                       var link = dropdownList[i];
                                                       if(link.getAttribute("data-value") == tabName) {
                                                       link.click();
                                                       };
                                                       }
                                                       };
                                                       '))),
                     fluidRow(
                       img(src="wallpaper.jpg", style = "width: 100%; height: 92vh;
                                  position: absolute; box-shadow: rgba(0, 0, 0, 0.6) 0px 0px 30px 0px")
                     ),
                     fluidRow(
                       column(6, style = "padding: 20px",
                              div(style = "margin-bottom: 20px;",
                                  div(style = "background-color: #fafaf8; border-radius: 10px; border-width: 1px;
                                         border-color: #aaaaaa; border-style: solid; width: 100%; z-index: 1000;
                                             box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px;",
                                      div(
                                        div(style = "width: 135px; margin: 5px; z-index: 1000", class = "btn-group", id = "filtro_portal",
                                            selectInput("prop_portal_filt_trans", "Transacción", 
                                                        choices = c("Todos", "Venta", "Alquiler", "Alquiler temporal"))),
                                        div(style = "width: 145px; margin: 5px", class = "btn-group", id = "filtro_portal",
                                            selectInput("prop_portal_filt_tipo", "Tipo propiedad",
                                                        choices = c("Todos", "Terreno", "Casa", "Duplex", "Departamento", "Proyecto", "Deposito", "Tinglado", "Oficina", "Salón comercial",
                                                                    "Propiedad rural", "Casa quinta", "Edificio"))),
                                        div(style = "width: 110px; margin: 5px", class = "btn-group", id = "filtro_portal",
                                            selectInput("prop_portal_filt_dormitorios", "Dormitorios",
                                                        choices = c("Todos", "Mono" = "0", 
                                                                    "1", "2", "3", "4", "5+"), 
                                                        selected = "Dormitorios")),
                                        div(class = "btn-group",
                                          uiOutput("mas_filtros_button_ui"))
                                      ),
                                      uiOutput("mas_filtros_ui")
                                  )
                                  
                              ),
                              div(style = "border-radius: 10px; padding: 3px; border-width: 1px;
                                         border-color: #aaaaaa; border-style: solid; background-color: #fafaf8; z-index: 10;
                                         box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px",
                                  leafletOutput("map_prop_portal", height = "70vh")
                              )
                       ),
                       column(6, style = "padding-top: 20px", id = "aqui",
                              div(style = "background-color: rgba(255, 255, 255, 0.5); border-radius: 20px;
                                         padding: 5px",
                                  uiOutput("inmo_pages_ui")
                              )
                       )
                     ),
                     br(),
                     
                     fluidRow(
                              br(), br(), br(), br(), br(), br(),
                              div(HTML("<p><span style='line-height: 0.7; font-size: 400%; font-weight: normal; color: #444444;'>Proyectos</span></p>"), align = "center"),
                              div(HTML("<p><span style='line-height: 0.7; font-size: 200%; font-weight: normal; color: #444444;'>Departamentos en pozo</span></p>"), align = "center"),
                              br(),
                              div(
                                uiOutput("box_proy_list_ui"),
                                uiOutput("proyectos_ui"),
                                uiOutput("proy_page_ui"),
                                uiOutput("cont_proy_page_ui"),
                                align = "center"
                              )
                     ),
                     
                     fluidRow( 
                       
                       style = "height:50px;"),
                     
                     # PAGE BREAK
                     tags$hr(),
                     
                     fluidRow(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                                     background-color: white; border-radius: 20px; margin: 10px;
                                     box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px",
                              column(6, style = "padding: 20px",
                                     h4("The Real Estate Worldwide está cambiando de una manera muy rápida, en SkyOne Real Estate Latam tenemos claro este cambio y las tendencias latinoamericanas sobre el día a día de un Asesor Inmobiliario.", style = "color: #888888"),
                                     h5(HTML(paste0("<span style = 'font-size: 120%; color: ", main_color, ";'><b>Tecnología</b></span><br>Las herramientas más avanzadas del mercado que te permitirán un control 360 de tus actividades elevando tu rendimiento al siguiente nivel."))),
                                     h5(HTML(paste0("<span style = 'font-size: 120%; color: ", main_color, ";'><b>Capacitación</b></span><br>Toda la experiencia de nuestros reconocidos brokers guiándote desde el día uno y el apoyo constante de la marca con capacitaciones tanto internas como externas, porque tu éxito es el nuestro."))), 
                                     tags$div(id="bttn_modal", 
                                              div(actionButton("modal_asesor", "Quiero ser un Asesor SkyOne"), style = "padding: 0px; padding-top: 20px; display: inline-block"),
                                              align = "center")
                              ),
                              column(6, style = "padding: 20px",
                                     img(src="wallpaper_separte.jpg", style = "width: 100%; border-radius: 15px")
                                     
                              )
                     ),
                     
                     fluidRow(
                       
                       style = "height:50px;"),
                     
                     # PAGE BREAK
                     tags$hr(),
                     
                     fluidRow(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                                     background-color: white; border-radius: 20px; margin: 10px;
                                     box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px",
                              column(6, style = "padding: 20px",
                                     img(src="wallpaper_seoficina.jpg", style = "width: 100%; border-radius: 15px")
                              ),

                              column(6, style = "padding: 20px",
                                     
                                     h5(HTML(paste0("<span style = 'font-size: 120%; color: ", main_color, ";'><b>Nuestra estructura</b></span> de oficinas Asociadas nos permite una relación directa y constante con nuestros brokers."))), br(),
                                     h5(HTML(paste0("<span style = 'font-size: 120%; color: ", main_color, ";'><b>Nuestra forma de negocio</b></span> está basada en los resultados en equipo y las compensaciones van de la mano."))), br(),
                                     h5(HTML(paste0("<span style = 'font-size: 120%; color: ", main_color, ";'><b>Nuestro modelo de negocio</b></span> está dirigido a personas que quieran empezar su oficina de bienes raíces o Inmobiliarias y así unirse a nuestra red."))), 
                                     h4("¿Quieres saber más de como tener tu oficina de bienes raíces?", style = "color: #888888"),
                                     tags$div(id="bttn_modal", 
                                              div(actionButton("modal_oficina", "Quiero una Oficina SkyOne"), style = "padding: 0px; padding-top: 20px; display: inline-block"),
                                              align = "center") 
                              )
                     ),
                     
                     fluidRow(
                       
                       style = "height:50px;"),
                     
                     # PAGE BREAK
                     tags$hr(),
                     
                     
                     
            ), 
            
            tabPanel("NOSOTROS", value = "nosotros",
                     fluidRow(
                       img(src="wallpaper_nosotros.jpg", style = "width: 100%; box-shadow: rgba(0, 0, 0, 0.6) 0px 0px 30px 0px")
                     ),
                     fluidRow(
                       div(h2("NOSOTROS", style = "color: white;"), style = "margin-top: -100px; margin-left: 30px")
                     ),
                     br(),
                     fluidRow(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                                     background-color: white; border-radius: 20px; margin: 30px;
                                     box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px",
                              column(6,
                                     h3("¿Quienes somos?", style = "color: #888888"),
                                     h5("SkyOne Paraguay es una marca paraguaya de bienes raíces con proyección LATAM."),
h5("Nacimos en 2020 con la visión de transformar la forma de hacer negocios inmobiliarios en la región, ofreciendo a nuestros clientes un servicio profesional, transparente y cercano."),
h5("Nuestro modelo de oficinas asociadas nos permite crecer en red, garantizando procesos unificados, tecnología de vanguardia y capacitaciones constantes, que fortalecen tanto a nuestros brokers como a cada asesor que forma parte de SkyOne."),
h5("En SkyOne creemos que el crecimiento se construye en equipo, con respaldo, visión y la pasión de quienes trabajan día a día para generar resultados que trascienden.")
                              ),
                              column(6, style = "padding: 20px",
                                     img(src="wallpaper_quienes.png", style = "width: 100%; border-radius: 15px")
                                     
                              )
                     ),
                     br(),
                     fluidRow(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                                     background-color: white; border-radius: 20px; margin: 30px;
                                     box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px",
                              column(6, style = "padding: 20px",
                                     img(src="wallpaper_pasion.jpg", style = "width: 100%; border-radius: 15px")
                                     
                              ),
                              column(6,
                                     h3("Pasión", style = "color: #888888"),
                                     h5("Asesorar desde el corazón y negociar con confianza, para conseguir siempre el mejor resultado."),
                                     h3("Promesa", style = "color: #888888"),
                                     h5("Facilitar los procesos, acompañar y cuidar los intereses de quienes confiaron en nosotros."),  
                                     h3("Propósito", style = "color: #888888"),
                                     h5("Intermediar negocios inteligentes con eficiencia, actitud, transparencia y el compromiso real de construir relaciones de por vida con nuestros clientes."),
                              )
                     ),
                     br(),
                     br()
            ),
            tabPanel("OFICINAS", value = "oficinas",
                     fluidRow(
                       img(src="wallpaper_oficinas.jpg", style = "width: 100%; box-shadow: rgba(0, 0, 0, 0.6) 0px 0px 30px 0px")
                     ),
                     fluidRow(
                       div(h2("OFICINAS", style = "color: white;"), style = "margin-top: -100px; margin-left: 30px")
                     ),
                     br(),
                     fluidPage(align = "center",
                       uiOutput("oficinas_list")
                     ),
                     br(),
                     br()
                     
            ),
            tabPanel("ALIANZAS", value = "alianzas",
                     fluidRow(
                       img(src="wallpaper_alianzas.jpg", style = "width: 100%; box-shadow: rgba(0, 0, 0, 0.6) 0px 0px 30px 0px")
                     ),
                     fluidRow(
                       div(h2("ALIANZAS", style = "color: white;"), style = "margin-top: -100px; margin-left: 30px")
                     ),
                     br(),
                     fluidRow(
                       column(4, 
                              div(align = "center",
                                  img(src="logo_place.png", style = "width: 300px;")
                              )
                       ),
                       column(4, 
                              div(align = "center",
                                  img(src="logo_Banco_Atlas.png", style = "width: 300px;")
                              )
                       ),
                       column(4, 
                              div(align = "center",
                                  img(src="logo_berlitz.png", style = "width: 300px;")
                              )
                       )
                     ),
                     fluidRow(
                       column(6, 
                              div(align = "center",
                                  img(src="logo_sancor.png", style = "width: 300px;")
                              )
                       ),
                       column(6, 
                              div(align = "center",
                                  img(src="logo_laura.png", style = "width: 300px;")
                              )
                       ),
#                       column(4, 
#                              div(align = "center",
#                                  #img(src="logo_berlitz.png", style = "width: 300px;")
#                              )
#                       )
                     ),
                     br(),
                     br()
                     
            ),
          )
)

###################################################################################################################################  
###################################################################################################################################  
###################################################################################################################################  
###################################################################################################################################  


server <- function(input, output, session){
  
  w <- Waypoint$
    new("aqui", offset = "0%")$
    start()
  
  observeEvent(w$going_down(), {
    print("Srooooooooooooooll")
    print(w$going_down())
    if(w$going_down())
      vars$scroll <- TRUE
  })
  
  mas_filtros_on <- reactiveVal(0)
  
  output$proyectos_ui <- renderUI({
    if(is.null(vars$loaded)){
      div(
        br(), br(), br(), br(), br(), br(), 
        div(img(src = "procesing.gif", width = 70), align = "center"),
        br(), br(), br(), br(), br(), br()
      )
    }
  })
  
  
  observe({
    req(input$dimension)
    print(input$dimension)
    if(input$dimension[1] >= 1500){
      vars$n_per_page <- 16
      vars$max_pages <- 8
    }else{
      if(input$dimension[1] < 1500 & input$dimension[1] >= 1150){
        vars$n_per_page <- 9
        vars$max_pages <- 8
      }else{
        if(input$dimension[1] < 1150 & input$dimension[1] >= 786){
          vars$n_per_page <- 6
          vars$max_pages <- 4
        }else{
          if(input$dimension[1] < 786 & input$dimension[1] >= 768){
            vars$n_per_page <- 4
            vars$max_pages <- 4
          }else{
            if(input$dimension[1] < 768 & input$dimension[1] >= 745){
              vars$n_per_page <- 8
              vars$max_pages <- 4
            }else{
              if(input$dimension[1] < 745 & input$dimension[1] >= 580){
                vars$n_per_page <- 6
                vars$max_pages <- 4
              }else{
                vars$n_per_page <- 4
                vars$max_pages <- 4
              }
            }
          }
        }
      }
    }
  })
  
  skyone_marker <- makeIcon(
    iconUrl = "skyone_marker.png",
    iconWidth = 60, iconHeight = 60,
    iconAnchorX = 30, iconAnchorY = 60
  )
  
  pin_360 <- makeIcon(
    iconUrl = "https://place-storage.nyc3.digitaloceanspaces.com/pins/photo.png",
    iconWidth = 30, iconHeight = 30,
    iconAnchorX = 15, iconAnchorY = 30
  )
  
  observeEvent(input$geolocation, {
    req(input$geolocation)
    if(input$geolocation == TRUE){
      vars$view <- data.frame(lat = input$lat, lng = input$lng)
    }
  })
  
  observeEvent(input$modal_asesor, {
    showModal(tags$div(id="modal_inmo_double", modalDialog(
      div(id = "inline",
        h4("Visita nuestro panel de oficinas donde podrás elegir entre una de nuestras Oficinas SkyOne")
      ),
      br(),
      tags$div(id="bttn_modal", 
               actionButton("go_oficinas_ok", "Ver oficinas"),
               actionButton("close_modal", "Cancelar"),
               align = "center"),
      title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Asesor Skyone</span></p>")),
      easyClose = TRUE,
      footer = NULL,
      size = "s",
      fade = TRUE
    )))
  })
  
  observeEvent(input$go_oficinas_ok, {
    removeModal()
    updateTabsetPanel(session, "navBar",
                      selected = "oficinas")
  })
  
  observeEvent(input$new_asesor_ok, {
    req(vars$show_ofi)
    email <- compose_email(
      body = md(c(
        "Estoy interesado en ser un asesor SkyOne<br>",

        "<br><b>Nombre y Apellido: </b>", input$new_asesor_name,
        "<br><b>Teléfono: </b>", input$new_asesor_phone,
        "<br><b>Por que le gustaría: </b>", input$new_asesor_comment,
        "<br><b>Oficina: </b>", vars$show_ofi$name
      ))
    )
    email %>%
      smtp_send(
        from = "skyone.realestatelatam@gmail.com",
        to = vars$show_ofi$mail,
        bcc = "daniel.ortiz@skyone.group",
        subject = "Interesado en ser un asesor SkyOne",
        credentials = creds_envvar(user = "skyone.realestatelatam@gmail.com",
                                   pass_envvar = "MAIL_PASS",
                                   provider = "gmail",
                                   use_ssl = TRUE)
      )
    
    showModal(tags$div(id="modal_inmo_double", modalDialog(
      h4("Nos contactaremos para coordinar una reunión, gracias por contactar a SkyOne Real Estate Latam."),
      br(),
      tags$div(id="bttn_modal", 
               actionButton("close_modal", "OK"),
               align = "center"),
      title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Asesor Skyone</span></p>")),
      easyClose = TRUE,
      footer = NULL,
      size = "s",
      fade = TRUE
    )))
  })
  
  
  observeEvent(input$modal_oficina, {
    showModal(tags$div(id="modal_inmo_double", modalDialog(
      div(id = "inline",
          textInput("new_oficina_name", "Nombre y Apellido"),
          textInput("new_oficina_phone", "Teléfono"),
          textAreaInput("new_oficina_comment", "¿Qué esperas obtener de una marca como SkyOne para tener tu oficina?")
      ),
      br(),
      tags$div(id="bttn_modal", 
               actionButton("new_oficina_ok", "Enviar"),
               actionButton("close_modal", "Cancelar"),
               align = "center"),
      title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Oficina Skyone</span></p>")),
      easyClose = TRUE,
      footer = NULL,
      size = "s",
      fade = TRUE
    )))
  })
  
  observeEvent(input$new_oficina_ok, {
    email <- compose_email(
      body = md(c(
        "Estoy interesado en obtener una oficina SkyOne<br>",
        
        "<br><b>Nombre y Apellido: </b>", input$new_oficina_name,
        "<br><b>Teléfono: </b>", input$new_oficina_phone,
        "<br><b>Lo que espera obtener de Skyone: </b>", input$new_oficina_comment
      ))
    )
    email %>%
      smtp_send(
        from = "skyone.realestatelatam@gmail.com",
        to = "skyone.realestatelatam@gmail.com",
        subject = "Interesado en una oficina SkyOne",
        credentials = creds_envvar(user = "skyone.realestatelatam@gmail.com",
                                   pass_envvar = "MAIL_PASS",
                                   provider = "gmail",
                                   use_ssl = TRUE)
      )
    
    showModal(tags$div(id="modal_inmo_double", modalDialog(
      h4("Nos contactaremos para coordinar una reunión, gracias por contactar a SkyOne Real Estate Latam."),
      br(),
      tags$div(id="bttn_modal", 
               actionButton("close_modal", "OK"),
               align = "center"),
      title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Oficina Skyone</span></p>")),
      easyClose = TRUE,
      footer = NULL,
      size = "s",
      fade = TRUE
    )))
  })
  
  ###################################################################################################################################  
  ###################################################################################################################################  
  #Galeria de fotos
  
  output$galeria_fotos_ui <- renderUI({
    div(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; width: 342px; height: 335px;
                           border-radius: 10px 10px 10px 10px; background-color: white",
        uiOutput("main_foto_gal_ui"),
        div(style = paste0("background-color: #aaaaaa; color: white;
                           height: 22px; border-radius: 0px 5px 0px 0px; 
                    padding: 5px; padding-top: 0px; position: absolute; margin-top: -22px; margin-left: 0px;
          z-index: 5;"), align = "center", 
            HTML(paste0("<p><span style='font-size: 110%; font-weight: bold'>", vars$gal_now, " - ", length(vars$gal), "</span></p>"))
        ),
        div(style = "padding: 5px", align = "left",
            if(vars$index + 1 > 1)
              actionButton("gal_prev", NULL, icon = icon("chevron-left"), style = paste0('font-size: 130%; z-index: 3;
                                                                      background-color: transparent; color: #888888;
                                                                      position: absolute; margin-left: -10px;
                                                                      boder-weight: 0px; border-color: transparent;
                                                                      margin-top: 13px')),
            if(vars$index + 4 < length(vars$gal))
              actionButton("gal_next", NULL, icon = icon("chevron-right"), style = paste0('font-size: 130%; z-index: 3;
                                                                      background-color: transparent; color: #888888;
                                                                      position: absolute; margin-left: 304px;
                                                                      boder-weight: 0px; border-color: transparent;
                                                                      margin-top: 13px')),
            uiOutput("gal1_ui"),
            uiOutput("gal2_ui"),
            uiOutput("gal3_ui"),
            uiOutput("gal4_ui")
        )
    )
  })
  
  output$main_foto_gal_ui <- renderUI({
    a(href = str_remove(vars$main_foto_gal, "-small"),
      actionButton("nada", NULL, style = paste0('background-color: transparent;
                                                             border: 0px; width:340px; height: 255px; margin: 0px;
                                                             background-image: url("', vars$main_foto_gal, '");
                                                             background-size: cover, 340px 255px;
                                                             border-radius: 8px 8px 0px 0px')))
  })
  
  output$gal1_ui <- renderUI({
    if(vars$index + 1 <= length(vars$gal)){
      div(
        div(style = paste0(ifelse(vars$gal_now == (1 + vars$index), "background-color: #666666; color: white;",
                                  "background-color: #dddddd; color: black;"),
                           "width: 22px; height: 22px; border-radius: 11px;
                    padding: 0px; position: absolute; margin-top: 45px; margin-left: 48px;
          z-index: 5;"), align = "center", 
            HTML(paste0("<p><span style='font-size: 80%; font-weight: normal'>", 1 + vars$index, "</span></p>"))
        ),
        actionButton("gal1", NULL, style = paste0('border-radius: 5px; 
                                                  background-image: url("', vars$gal[1 + vars$index], '");
                                                                      background-size: cover, 72px 54px;
                                                                      width: 72px; height: 54px; z-index: 3;',
                                                  'position: absolute; margin-left: 23px; margin-top: 5px'))
      )
    }
  })
  
  output$gal2_ui <- renderUI({
    if(vars$index + 2 <= length(vars$gal)){
      div(
        div(style = paste0(ifelse(vars$gal_now == (2 + vars$index), "background-color: #666666; color: white;",
                                  "background-color: #dddddd; color: black;"),
                           "width: 22px; height: 22px; border-radius: 11px;
                    padding: 0px; position: absolute; margin-top: 45px; margin-left: 120px;
          z-index: 5;"), align = "center", 
            HTML(paste0("<p><span style='font-size: 80%; font-weight: normal'>", 2 + vars$index, "</span></p>"))
        ), #dataURI(file = vars$gal[2 + vars$index])
        actionButton("gal2", NULL, style = paste0('border-radius: 5px; 
                                                  background-image: url("', vars$gal[2 + vars$index], '");
                                                                      background-size: cover, 72px 54px;
                                                                      width: 72px; height: 54px; z-index: 3;
                                                                      position: absolute; margin-left: 95px; margin-top: 5px'))
      )
    }
  })
  
  output$gal3_ui <- renderUI({
    if(vars$index + 3 <= length(vars$gal)){
      div(
        div(style = paste0(ifelse(vars$gal_now == (3 + vars$index), "background-color: #666666; color: white;",
                                  "background-color: #dddddd; color: black;"),
                           "width: 22px; height: 22px; border-radius: 11px;
                    padding: 0px; position: absolute; margin-top: 45px; margin-left: 192px;
          z-index: 5;"), align = "center", 
            HTML(paste0("<p><span style='font-size: 80%; font-weight: normal'>", 3 + vars$index, "</span></p>"))
        ),
        actionButton("gal3", NULL, style = paste0('border-radius: 5px; 
                                                  background-image: url("', vars$gal[3 + vars$index], '");
                                                                      background-size: cover, 72px 54px;
                                                                      width: 72px; height: 54px; z-index: 3;
                                                                      position: absolute; margin-left: 167px; margin-top: 5px'))
      )
    }
  })
  
  output$gal4_ui <- renderUI({
    if(vars$index + 4 <= length(vars$gal)){
      div(
        div(style = paste0(ifelse(vars$gal_now == (4 + vars$index), "background-color: #666666; color: white;",
                                  "background-color: #dddddd; color: black;"),
                           "width: 22px; height: 22px; border-radius: 11px;
                    padding: 0px; position: absolute; margin-top: 45px; margin-left: 264px;
          z-index: 5;"), align = "center", 
            HTML(paste0("<p><span style='font-size: 80%; font-weight: normal'>", 4 + vars$index, "</span></p>"))
        ),
        actionButton("gal4", NULL, style = paste0('border-radius: 5px; 
                                                  background-image: url("', vars$gal[4 + vars$index], '");
                                                                      background-size: cover, 72px 54px;
                                                                      width: 72px; height: 54px; z-index: 3;
                                                                      position: absolute; margin-left: 239px; margin-top: 5px'))
      )
    }
  })
  
  observeEvent(input$gal1, {
    vars$gal_now <- 1 + vars$index
    vars$main_foto_gal <- vars$gal[1 + vars$index]
  })
  
  observeEvent(input$gal2, {
    vars$gal_now <- 2 + vars$index
    vars$main_foto_gal <- vars$gal[2 + vars$index]
  })
  
  observeEvent(input$gal3, {
    vars$gal_now <- 3 + vars$index
    vars$main_foto_gal <- vars$gal[3 + vars$index]
  })
  
  observeEvent(input$gal4, {
    vars$gal_now <- 4 + vars$index
    vars$main_foto_gal <- vars$gal[4 + vars$index]
  })
  
  observeEvent(input$gal_prev, {
    if(vars$index - 4 >= 0){
      vars$index <- vars$index - 4
    }else{
      if(vars$index - 3 >= 0){
        vars$index <- vars$index - 3
      }else{
        if(vars$index - 2 >= 0){
          vars$index <- vars$index - 2
        }else{
          if(vars$index - 1 >= 0){
            vars$index <- vars$index - 1
          }
        }
      }
    }
    print(vars$index)
  })
  
  observeEvent(input$gal_next, {
    tot <- length(vars$gal)
    if(vars$index + 4 < tot){
      vars$index <- vars$index + 4
    }else{
      if(vars$index + 3 < tot){
        vars$index <- vars$index + 3
      }else{
        if(vars$index + 2 < tot){
          vars$index <- vars$index + 2
        }else{
          if(vars$index + 1 < tot){
            vars$index <- vars$index + 1
          }
        }
      }
    }
    print(vars$index)
  })
  
  
  ###################################################################################################################################  
  ###################################################################################################################################  
  #Pages
  
  all_inmo <- query_mysql("SELECT id, user, tipoPropiedad, venta_alquiler, fecha, precio_cierre, moneda_contrato, precio, dormitorios, lat, lon 
                               FROM myplace_inmuebles 
                               WHERE company = 'skyone' AND
                               borrador = 'no' AND externa = 'no' AND precio_cierre = 0 AND
                               precio_cierre = '0' AND activo = 'si' AND publicado = 'si' ORDER BY fecha DESC;")
  all_inmo <- all_inmo[!str_detect(all_inmo$user, "gmayeregger"), ]
  all_proy <- all_inmo[all_inmo$tipoPropiedad == "Proyecto",]
  vars <- reactiveValues(view = ini_view)
  vars$view <- ini_view
  vars$n_per_page <- inmo_per_page
  vars$max_pages <- inmo_max_pages
  vars$page_selected <- 1
  vars$n_per_page_proy <- proy_per_page
  vars$max_pages_proy <- proy_max_pages
  vars$page_selected_proy <- 1
  vars$data_per_page_proy <- generate_pages(all_proy, proy_per_page, proy_max_pages, 1)$data
  
  obs_page <- list()
  
  observe({
      req(vars$data_all_pages)
      if(nrow(vars$data_all_pages) != 0){
        page <- generate_pages(vars$data_all_pages, vars$n_per_page, vars$max_pages, vars$page_selected)
        output$page_ui <- renderUI({
          pages <- as.list(page$min:page$max)
          pages <- lapply(pages, function(i){
            btName <- paste0("inmo_page", i)
            obs_page[[btName]] <<- observeEvent(input[[btName]], ignoreNULL = TRUE, ignoreInit = TRUE, {
              freezeReactiveValue(input, btName)
              isolate({
                vars$page_selected <- i
                if(i == page$n_pages){
                  vars$data_per_page <- vars$data_all_pages[(vars$n_per_page*i-vars$n_per_page + 1):(vars$n_per_page*(i - 1) + page$last_page),]
                }else{
                  vars$data_per_page <- vars$data_all_pages[(vars$n_per_page*i-vars$n_per_page + 1):(vars$n_per_page*i),]
                }
              })
            })
            div(style = "padding: 5px; display:inline-block",
                if(i == page$min & page$min != page$max){
                  tags$div(class = "btn-group",
                           actionButton("go_first_page", NULL, icon = icon("angle-double-left"),
                                        style = paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; margin-right: 10px; width: 30px; font-size: 90%; padding-left: 10px")),
                           actionButton(btName, as.character(i), 
                                        style = ifelse(i == vars$page_selected, 
                                                       paste0("background-color: ", main_color, "; color: white; border: 1px; border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"),
                                                       paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%")))
                  )
                },
                if(i == page$max & page$min != page$max){
                  tags$div(class = "btn-group",
                           actionButton(btName, as.character(i), 
                                        style = ifelse(i == vars$page_selected, 
                                                       paste0("background-color: ", main_color, "; color: white; border: 1px; border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"),
                                                       paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"))),
                           actionButton("go_last_page", NULL, icon = icon("angle-double-right"),
                                        style = paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; margin-left: 10px; width: 30px; font-size: 90%; padding-left: 10px"))
                  )
                },
                if((i != page$min & i != page$max) | page$min == page$max){
                  actionButton(btName, as.character(i), 
                               style = ifelse(i == vars$page_selected, 
                                              paste0("background-color: ", main_color, "; color: white; border: 1px; border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"),
                                              paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%")))
                }
            )
          })
        })
      }else{
        output$page_ui <- renderUI({
          div()
        })
      }
  })
  
  output$cont_page_ui <- renderUI({
    req(vars$data_all_pages)
    if(nrow(vars$data_all_pages) != 0){
      vars$data_per_page <- vars$data_per_page[!is.na(vars$data_per_page$id),]
      div(style = "background-color: white; border-radius: 5px; width: 160px; padding-left: 6px",
        paste0("  Mostrando ", (vars$page_selected - 1)*vars$n_per_page + 1, "-", 
             (vars$page_selected - 1)*vars$n_per_page + nrow(vars$data_per_page), " de ",
             nrow(vars$data_all_pages))
      )
    }
  })
  
  observeEvent(input$go_first_page, {
    req(vars$data_all_pages)
    isolate({
      vars$data_per_page <- generate_pages(vars$data_all_pages, vars$n_per_page, vars$max_pages, 1)$data
      vars$page_selected <- 1
    })
  })
  
  observeEvent(input$go_last_page, {
    req(vars$data_all_pages)
    isolate({
      page <- generate_pages(vars$data_all_pages, vars$n_per_page, vars$max_pages, 1)
      vars$page_selected <- page$n_pages
      vars$data_per_page <- vars$data_all_pages[(vars$n_per_page*page$n_pages-vars$n_per_page + 1):(vars$n_per_page*(page$n_pages - 1) + page$last_page),]
    })
  })
  
  ################################################################################################################################## 
  ##################################################################################################################################
  #map_portal
  
  observeEvent(input$mas_filtros_on_off, {
    if(mas_filtros_on() == 0){
      mas_filtros_on(1)
    }else{
      mas_filtros_on(0)
      updateAutonumericInput(session, "prop_portal_filt_precio_min", value = 0)
      updateAutonumericInput(session, "prop_portal_filt_precio_max", value = 0)
    }
  })
  
  output$mas_filtros_button_ui <- renderUI({
    if(mas_filtros_on() == 0){
      div(
          actionButton("mas_filtros_on_off", " Precios", icon = icon("sort-desc", class = "icon_right"),
                       style = "border-width: 0px"))
    }else{
      div(
          actionButton("mas_filtros_on_off", " Precios", icon = icon("sort-asc", class = "icon_right"),
                       style = "border-width: 0px"))
    }
  })
  
  output$mas_filtros_ui <- renderUI({
    if(mas_filtros_on() == 1){
      div(style = "background-color: #fafaf8; border-radius: 10px; border-width: 1px;
                                         border-color: #aaaaaa; border-style: solid; z-index: 1000;
                                             margin: 10px; padding: 10px",
          div(style = "width: 100px;", id = "filtro_portal", class = "btn-group",
              selectInput("prop_portal_filt_moneda", "Moneda",
                          choices = c("Dólares", "Guaranies"))),
          div(style = "width: 125px; margin: 5px", id = "filtro_portal", class = "btn-group",
              autonumericInput(inputId = "prop_portal_filt_precio_min", align = "left",
                               label = "Precio mínimo",
                               value = NULL, currencySymbol = NULL, currencySymbolPlacement = "p",
                               decimalPlaces = 0, digitGroupSeparator = ".", decimalCharacter = ",",
                               minimumValue = 0)),
          div(style = "width: 125px; margin: 5px", id = "filtro_portal", class = "btn-group",
              autonumericInput(inputId = "prop_portal_filt_precio_max", align = "left",
                               label = "Precio máximo",
                               value = NULL, currencySymbol = NULL, currencySymbolPlacement = "p",
                               decimalPlaces = 0, digitGroupSeparator = ".", decimalCharacter = ",",
                               minimumValue = 0)),
          div(id="bttn_modal", class = "btn-group", style = "margin-top: 10px",
              actionButton("filtrar_precios_ok", "Filtrar"))
      )
    }

  })
  
  observe({
    req(input$prop_portal_filt_trans, input$prop_portal_filt_tipo)
    
    
    
    if(input$prop_portal_filt_trans != "Todos"){
      all_pages <- all_inmo[all_inmo$venta_alquiler == input$prop_portal_filt_trans,]
    }else{
      all_pages <- all_inmo
    }
    if(input$prop_portal_filt_tipo != "Todos"){
      all_pages <- all_pages[all_pages$tipoPropiedad == input$prop_portal_filt_tipo,]
    }
    
    if(input$prop_portal_filt_dormitorios != "Todos"){
      if(input$prop_portal_filt_tipo == "Proyecto"){
        tipos <- list_table_var_mysql("myplace_tipologias", "dormitorios", input$prop_portal_filt_dormitorios)
        ids_proyectos <- unique(tipos$id)
        all_pages <- all_pages[all_pages$id %in% ids_proyectos,]
      }else{
        if(input$prop_portal_filt_tipo == "Todos"){
          tipos <- list_table_var_mysql("myplace_tipologias", "dormitorios", input$prop_portal_filt_dormitorios)
          ids_proyectos <- unique(tipos$id)
          proyectos <- all_pages[all_pages$id %in% ids_proyectos,]
          all_pages <- all_pages[all_pages$tipoPropiedad != "Proyecto" & !is.na(all_pages$dormitorios) & all_pages$dormitorios == input$prop_portal_filt_dormitorios,]
          all_pages <- rbind(all_pages, proyectos)
          print(paste0(nrow(all_pages), " inmuebles encontrados"))
        }else{
          all_pages <- all_pages[all_pages$dormitorios == input$prop_portal_filt_dormitorios,]
        }
      }
    }

    
    if(mas_filtros_on() == 1){
      input$filtrar_precios_ok
      isolate({
        cambio_dolar <- dollarExchange()
        
        if(!is.null(input$prop_portal_filt_precio_min) && input$prop_portal_filt_precio_min > 0){
          
          if(input$prop_portal_filt_moneda == "Dólares"){
            tipos_dol <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "USD", "precio", ">=", input$prop_portal_filt_precio_min)
            tipos_gua <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "GS", "precio", ">=", input$prop_portal_filt_precio_min/cambio_dolar$venta)
          }else{
            tipos_dol <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "USD", "precio", ">=", input$prop_portal_filt_precio_min*cambio_dolar$compra)
            tipos_gua <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "GS", "precio", ">=", input$prop_portal_filt_precio_min)
          }
          tipos <- rbind(tipos_dol, tipos_gua)
          ids_proyectos <- unique(tipos$id)
          proyectos <- all_pages[all_pages$id %in% ids_proyectos,]
          
          all_pages <- all_pages[all_pages$tipoPropiedad != "Proyecto",]
          if(input$prop_portal_filt_moneda == "Dólares"){
            all_pages <- all_pages %>% mutate(precio_dolar = ifelse(moneda_contrato == "GS", precio/cambio_dolar$venta, precio))
            all_pages <- all_pages[all_pages$precio_dolar >= input$prop_portal_filt_precio_min,]
          }else{
            all_pages <- all_pages %>% mutate(precio_dolar = ifelse(moneda_contrato == "USD", precio*cambio_dolar$compra, precio))
            all_pages <- all_pages[all_pages$precio_dolar >= input$prop_portal_filt_precio_min,]
          }
          
          if(nrow(all_pages) != 0){
            all_pages$precio_dolar <- NULL
          }
          all_pages <- rbind(all_pages, proyectos)
        }
        
        if(!is.null(input$prop_portal_filt_precio_max) && input$prop_portal_filt_precio_max > 0){
          if(is.null(input$prop_portal_filt_precio_min) || input$prop_portal_filt_precio_max > input$prop_portal_filt_precio_min){
            if(input$prop_portal_filt_moneda == "Dólares"){
              tipos_dol <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "USD", "precio", "<=", input$prop_portal_filt_precio_max)
              tipos_gua <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "GS", "precio", "<=", input$prop_portal_filt_precio_max/cambio_dolar$venta)
            }else{
              tipos_dol <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "USD", "precio", "<=", input$prop_portal_filt_precio_max*cambio_dolar$compra)
              tipos_gua <- list_table_var1_var2_cond_mysql("myplace_tipologias", "moneda_contrato", "GS", "precio", "<=", input$prop_portal_filt_precio_max)
            }
            tipos <- rbind(tipos_dol, tipos_gua)
            ids_proyectos <- unique(tipos$id)
            proyectos <- all_pages[all_pages$id %in% ids_proyectos,]
            
            all_pages <- all_pages[all_pages$tipoPropiedad != "Proyecto",]
            if(input$prop_portal_filt_moneda == "Dólares"){
              all_pages <- all_pages %>% mutate(precio_dolar = ifelse(moneda_contrato == "GS", precio/cambio_dolar$venta, precio))
              all_pages <- all_pages[all_pages$precio_dolar <= input$prop_portal_filt_precio_max,]
            }else{
              all_pages <- all_pages %>% mutate(precio_dolar = ifelse(moneda_contrato == "USD", precio*cambio_dolar$compra, precio))
              all_pages <- all_pages[all_pages$precio_dolar <= input$prop_portal_filt_precio_max,]
            }
            
            if(nrow(all_pages) != 0){
              all_pages$precio_dolar <- NULL
            }
            all_pages <- rbind(all_pages, proyectos)
          }
        }
      })
    }
    
    
    if(nrow(all_pages) != 0){
      vars$page_selected <- 1
      vars$data_all_pages <- all_pages %>% arrange(desc(fecha))
      vars$data_per_page <- generate_pages(all_pages, vars$n_per_page, vars$max_pages, 1)$data
    }else{
      vars$page_selected <- 1
      vars$data_all_pages <- data.frame()
      vars$data_per_page <- data.frame()
    }
  })
  
  output$map_prop_portal <- renderLeaflet({
      map_prop_portal_leaflet <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
        htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)}") %>%
        setView(lng = vars$view[2], lat = vars$view[1], zoom = 13) %>%
        addProviderTiles(providers$CartoDB.Positron, group = "mapa") %>%
        addTiles("https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}", group = "satélite") %>%
        #      addTiles("https://mt1.google.com/vt?lyrs=h@159000000,traffic|seconds_into_week:-1&style=3&x={x}&y={y}&z={z}", group = "tráfico") %>% 
        addLayersControl(baseGroups = c("mapa", "satélite"), #overlayGroups = c("propios", "otros", "cierres"),
                         options = layersControlOptions(collapsed=FALSE), position = "bottomleft")
      if(nrow(vars$data_all_pages) != 0){
        map_prop_portal_leaflet <- map_prop_portal_leaflet %>% addMarkers(data = vars$data_all_pages, icon = ~icon_inmo(tipoPropiedad), layerId = ~id, group = "propios",
                                                                          clusterOptions = markerClusterOptions(iconCreateFunction=JS("function (cluster) {    
    var childCount = cluster.getChildCount(); 
    var c = ' marker-custom-';  
    if (childCount < 10) {  
      c += 'large';  
    } else if (childCount < 50) {  
      c += 'medium';  
    } else { 
      c += 'small';  
    }    
    return new L.DivIcon({ html: '<div><span>' + childCount + '</span></div>', className: 'marker-cluster' + c, iconSize: new L.Point(40, 40) });

  }")))
      }
      map_prop_portal_leaflet
  })
  
  observeEvent(input$map_prop_portal_marker_click, {
    click <- input$map_prop_portal_marker_click
    vars$click <- query_mysql(paste0("SELECT * FROM myplace_inmuebles WHERE id = '", click$id, "';"))
    vars$show_inmo <- vars$click
      showModal(tags$div(id="modal_inmo_double", modalDialog(
        uiOutput("show_inmo_ui"),
        br(),
        tags$div(id="bttn_modal", 
                 actionButton("close_show_inmo", "OK"),
                 align = "center"),
        title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Detalles de la propiedad</span></p>")),
        easyClose = FALSE,
        footer = NULL,
        size = "l",
        fade = TRUE
      )))
  })
  
  output$show_inmo_ui <- renderUI({
    req(vars$show_inmo)
    print("vars$show_inmo")
    print(vars$show_inmo)
    if(nrow(vars$show_inmo) != 0){
    inmo <- vars$show_inmo
    print(inmo)
    if(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta"){
      inmo$precio <- round(inmo$precio/1000000)
    }
    print(format(inmo$precio, big.mark = ".", decimal.mark = ",", scientific = FALSE))
    
    agente <- inmo$user
    agente <- list_table_var1_var2_mysql("myplace_usuarios", "company", co, "user", agente)

    vars$agencias <- load_mysql(paste0(co, "_agencias_data"))
    vars$franquicias <- load_mysql(paste0(co, "_franquicias_data"))
    agencia_nam <- agencia_name(agente, vars$agencias, vars$franquicias)
    
    ubi <- data.frame(lat = inmo$lat, lon = inmo$lon)
    
    vars$map_show_inmo <- FALSE
    size <- 100/100000
    lat_min <- ubi$lat - size
    lat_max <- ubi$lat + size
    lon_min <- ubi$lon - size
    lon_max <- ubi$lon + size
    fotos_360 <- filter_box_table_mysql(lat_min, lat_max, lon_min, lon_max, "fotos_street360")
    
    output$map_show_inmo <- renderLeaflet({
      map <- leaflet(height = "100%") %>%
        setView(inmo$lon, inmo$lat, zoom = 18) %>%
        addMarkers(lng = inmo$lon, lat = inmo$lat, icon = skyone_marker) %>%
        addTiles("https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}", group = "mapa") %>%
        addTiles("https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}", group = "satélite") %>%
        addLayersControl(baseGroups = c("mapa", "satélite"),
                         options = layersControlOptions(collapsed=FALSE), position = "bottomleft")
      if(nrow(fotos_360) != 0){
        map <- map %>% addMarkers(data = fotos_360, icon = pin_360, 
                                  popup = ~paste0('<iframe width="200" height="200" allowfullscreen style="border-style:none;" src="https://cdn.pannellum.org/2.5/pannellum.htm#panorama=', img, '&autoLoad=true&autoRotate=2"></iframe>'))
      }
      map
    })
    
    if(inmo$tipoPropiedad == "Proyecto"){
      tipologias <- list_table_var_mysql("myplace_tipologias", "id", inmo$id) %>% arrange(fecha)
      if(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta"){
        tipologias$precio <- round(tipologias$precio/1000000)
      }
      vars$tipologia_list_all <- tipologias
      precio_min <- format(min(tipologias$precio), big.mark = ".", decimal.mark = ",", scientific = FALSE)
      precio_max <- format(max(tipologias$precio), big.mark = ".", decimal.mark = ",", scientific = FALSE)
      dormitorios_min <- min(ifelse(is.na(as.integer(tipologias$dormitorios)), 1, as.integer(tipologias$dormitorios)))
      dormitorios_max <- max(ifelse(is.na(as.integer(tipologias$dormitorios)), 1, as.integer(tipologias$dormitorios)))
      banios_min <- min(as.integer(tipologias$banios))
      banios_max <- max(as.integer(tipologias$banios))
      m2_cons_min <- format(round(min(tipologias$m2_cons)), big.mark = ".", decimal.mark = ",", scientific = FALSE)
      m2_cons_max <- format(round(max(tipologias$m2_cons)), big.mark = ".", decimal.mark = ",", scientific = FALSE)
      garajes_min <- min(as.integer(tipologias$garajes))
      garajes_max <- max(as.integer(tipologias$garajes))
      bauleras_min <- min(as.integer(tipologias$bauleras))
      bauleras_max <- max(as.integer(tipologias$bauleras))
    }
    vars$gal <- NA
    vars$index <- 0
    vars$gal <- num_fotos_inmo(vars$show_inmo$img, TRUE)
    vars$main_foto_gal <- vars$gal[1]
    vars$gal_now <- 1
    
    div(
      div(HTML(paste0("<p><span style='font-size: 180%; font-weight: bold; color: #666666'>", 
                      str_to_upper(inmo$titulo), "</span></p>")), align = "center"),
      div(align = "center",
          div(class = "btn-group", style = "margin-bottom: 10px; width: 342px; margin-top: 10px",
              #fluidPage(style = paste0("border-style: solid; border-width: 1px; border-color: #aaaaaa; 
              #         border-radius: 10px; background-color: white; padding: 15px; height: 400px; margin: 0px;
              #                                      margin-bottom: 10px"),
                      #slickROutput("carousel_fotos_ui", height = "225px")
                      uiOutput("galeria_fotos_ui")
              #)
          ),
          div(style = "width: 342px", class = "btn-group",
              div(
                fluidPage(style = paste0("border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                       border-radius: 10px; background-color: white; padding: 10px; min-height: 200px; margin: 0px;
                                                    margin-bottom: 10px"),
                          
                          div(style = "padding: 0px",
                              div(
                                div(style = "padding: 0px; position: absolute; margin-top: 0px; margin-left: 0px",
                                    HTML(paste0("<p><span style='font-size: 120%; font-weight: normal; color: #888888'>", 
                                                inmo$tipoPropiedad, " en ", inmo$venta_alquiler, "</span></p>")),
                                ),
                                div(style = "padding: 0px; position: absolute; margin-top: 0px; margin-left: 260px",
                                    HTML(paste0("<p><span style='font-size: 120%; font-weight: bold; color: #888888'>", 
                                                "ID: ", as.integer(str_flatten(str_extract_all(inmo$id, "\\d")[[1]])))),
                                )
                              ),
                              if(inmo$tipoPropiedad == "Proyecto"){
                                if(precio_min == precio_max){
                                  div(style = "position: absolute; margin-left: 0px; margin-top: 30px",
                                      HTML(paste0("<p><span style='font-size: 190%; font-weight: lighter; color: ", main_color, "'>", 
                                                  inmo$moneda_contrato, " ", precio_min, 
                                                  ifelse(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta", " millones", ""), "</span></p>"))
                                  )
                                }else{
                                  div(style = "position: absolute; margin-left: 0px; margin-top: 30px",
                                      HTML(paste0("<p><span style='font-size: 190%; font-weight: lighter; color: ", main_color, "'>", 
                                                  inmo$moneda_contrato, " ", paste0(precio_min, "-", precio_max), 
                                                  ifelse(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta", " millones", ""), "</span></p>"))
                                  )
                                }
                              }else{
                                div(style = "position: absolute; margin-left: 0px; margin-top: 30px",
                                    HTML(paste0("<p><span style='font-size: 190%; font-weight: lighter; color: ", main_color, "'>", 
                                                inmo$moneda_contrato, " ", format(inmo$precio, big.mark = ".", decimal.mark = ",", scientific = FALSE), 
                                                ifelse(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta", " millones", ""), "</span></p>"))
                                )
                              },
                              div(style = "position: absolute; margin-left: 0px; margin-top: 75px",
                                  if(inmo$m2 != 0){
                                    if(inmo$tipoPropiedad != "Propiedad rural"){
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-ruler-combined'></i> ", 
                                                      format(inmo$m2, big.mark = ".", decimal.mark = ",", scientific = FALSE), "m2 Terreno", "</span></p>")))
                                    }else{
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-ruler-combined'></i> ", 
                                                      format(inmo$m2/10000, big.mark = ".", decimal.mark = ",", scientific = FALSE), " hectareas", "</span></p>")))
                                    }
                                  },
                                  if(inmo$m2_cons != 0){
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-home'></i> ", 
                                                    inmo$m2_cons, "m2 Edificados", "</span></p>")))
                                  }else{
                                    if(inmo$tipoPropiedad == "Proyecto"){
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-home'></i> ", 
                                                      ifelse(m2_cons_min == m2_cons_max, m2_cons_min, paste0(m2_cons_min, "-", m2_cons_max)),
                                                      "m2 Edif.", "</span></p>")))
                                    }
                                  },
                                  if(inmo$frente != 0)
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-ruler-horizontal'></i> ", 
                                                    inmo$frente, "m Frente", "</span></p>"))),
                                  if(inmo$fondo != 0)
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-ruler-vertical'></i> ", 
                                                    inmo$fondo, "m Fondo", "</span></p>"))),
                                  if(!is.na(inmo$dormitorios)){
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-bed'></i> ", 
                                                    inmo$dormitorios, " Dormitorios", "</span></p>")))
                                  }else{
                                    if(inmo$tipoPropiedad == "Proyecto"){
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-bed'></i> ", 
                                                      ifelse(dormitorios_min == dormitorios_max, dormitorios_min, paste0(dormitorios_min, "-", dormitorios_max)), 
                                                      " Dormitorios", "</span></p>")))
                                    }
                                  },
                                  if(!is.na(inmo$banios)){
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-bath'></i> ", 
                                                    inmo$banios, " Baños", "</span></p>")))
                                  }else{
                                    if(inmo$tipoPropiedad == "Proyecto"){
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-bath'></i> ", 
                                                      ifelse(banios_min == banios_max, banios_min, paste0(banios_min, "-", banios_max)), 
                                                      " Baños", "</span></p>")))
                                    }
                                  },
                                  if(!is.na(inmo$garajes)){
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-car-side'></i> ", 
                                                    inmo$garajes, " Cocheras", "</span></p>")))
                                  }else{
                                    if(inmo$tipoPropiedad == "Proyecto"){
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-car-side'></i> ", 
                                                      ifelse(garajes_min == garajes_max, garajes_min, paste0(garajes_min, "-", garajes_max)), 
                                                      " Cocheras", "</span></p>")))
                                    }
                                  },
                                  if(!is.na(inmo$bauleras)){
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-suitcase'></i> ", 
                                                    inmo$bauleras, " Bauleras", "</span></p>")))
                                  }else{
                                    if(inmo$tipoPropiedad == "Proyecto"){
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-suitcase'></i> ", 
                                                      ifelse(bauleras_min == bauleras_max, bauleras_min, paste0(bauleras_min, "-", bauleras_max)), 
                                                      " Bauleras", "</span></p>")))
                                    }
                                  },
                                  if(!is.na(inmo$banios_compartidos)){
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-toilet'></i> ", 
                                                    inmo$banios_compartidos, " Baños compartidos", "</span></p>")))
                                  },
                                  if(!is.na(inmo$oficinas)){
                                    div(class = "btn-group",
                                        HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-laptop-house'></i> ", 
                                                    inmo$oficinas, " Oficinas", "</span></p>")))
                                  },
                                  if(!is.na(inmo$area_servicio)){
                                    if(inmo$area_servicio == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-broom'></i> ", 
                                                      " Area de servicio", "</span></p>")))
                                  },
                                  if(!is.na(inmo$cocina_equipada)){
                                    if(inmo$cocina_equipada == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-utensils'></i> ", 
                                                      " Cocina equipada", "</span></p>")))
                                  },
                                  if(!is.na(inmo$cocina_propia)){
                                    if(inmo$cocina_propia == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-utensils'></i> ", 
                                                      " Kitchenette", "</span></p>")))
                                  },
                                  if(!is.na(inmo$quincho)){
                                    if(inmo$quincho == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-drumstick-bite'></i> ", 
                                                      " Quincho", "</span></p>")))
                                  },
                                  if(!is.na(inmo$deposito)){
                                    if(inmo$deposito == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-warehouse'></i> ", 
                                                      " Depósito", "</span></p>")))
                                  },
                                  if(!is.na(inmo$piscina)){
                                    if(inmo$piscina == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-swimming-pool'></i> ", 
                                                      " Piscina", "</span></p>")))
                                  },
                                  if(!is.na(inmo$gimnasio)){
                                    if(inmo$gimnasio == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-dumbbell'></i> ", 
                                                      " Gimnasio", "</span></p>")))
                                  },
                                  if(!is.na(inmo$generador)){
                                    if(inmo$generador == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-bolt'></i> ", 
                                                      " Generador", "</span></p>")))
                                  },
                                  if(!is.na(inmo$trifacico)){
                                    if(inmo$trifacico == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-plug'></i> ", 
                                                      " Trifacico", "</span></p>")))
                                  },
                                  if(!is.na(inmo$pet_friendly)){
                                    if(inmo$pet_friendly == "si")
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-dog'></i> ", 
                                                      " Pet friendly", "</span></p>")))
                                  },
                                  if(!is.na(inmo$ascensor)){
                                    ascensor <- str_extract_all(inmo$ascensor, "\\d+")[[1]] %>% as.integer()
                                    if(ascensor > 0)
                                      div(class = "btn-group",
                                          HTML(paste0("<p><span style='padding-right: 7px; font-size: 90%; font-weight: normal; color: black'><i class='fa fa-dashboard'></i> ", 
                                                      " Ascensor", "</span></p>")))
                                  }
                              )
                          )
                ),
                fluidPage(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                       border-radius: 10px; background-color: white; padding: 5px; height: 125px;
                                       margin: 0px; padding-left: 10px",
                          div(align = "left",
                              div(class = "btn-group", style = "width: 200px",
                                  HTML("<p><span style='font-size: 100%; font-weight: normal; color: #888888'>Asesor inmobiliario</span></p>"),
                                  div(HTML(paste0("<p><span style='line-height: 0.9; font-size: 140%; font-weight: bold; color: #888888'>", agente$name, "</span></p>")),
                                      style = "margin-top: -15px; height: 60px"),
                                  div(HTML(paste0("<p><span style='font-size: 90%; font-weight: lighter; color: #444444'>", agencia_nam, "</span></p>")),
                                      style = "margin-top: -20px"),
                                  if(!is.na(agente$face)){
                                    div(class = "btn-group",
                                        a(href = agente$face, target="_blank", actionButton("nada", NULL , icon = icon("facebook"),
                                                                                            style = "margin-top: -20px; font-size: 150%; padding: 0px; padding-left: 0px; background-color: transparent; border-color: transparent"))
                                    )
                                  },
                                  if(!is.na(agente$insta)){
                                    div(class = "btn-group",
                                        a(href = agente$insta, target="_blank", actionButton("nada", NULL , icon = icon("instagram"),
                                                                                             style = "margin-top: -20px; font-size: 150%; padding: 0px; padding-left: 20px; background-color: transparent; border-color: transparent"))
                                    )
                                  },
                                  if(agente$user != ""){
                                    div(class = "btn-group",
                                        a(href= paste0("mailto:", agente$user), target="_blank", 
                                          actionButton("nada", "" , icon = icon("envelope"),
                                                       style = "margin-top: -20px; font-size: 150%; padding: 0px; padding-left: 20px; background-color: transparent; border-color: transparent"))
                                    )
                                  },
                                  if(!is.na(agente$phone)){
                                    text_wp <- paste0("https://wa.me/", agente$phone, "?text=", "")
                                    div(class = "btn-group",
                                        a(href= text_wp, target="_blank", actionButton("nada", NULL , icon = icon("whatsapp"),
                                                                                       style = "margin-top: -20px; font-size: 150%; padding: 0px; padding-left: 20px;
                                                                                                          background-color: transparent; border-color: transparent"))
                                    )
                                  },
                              ),
                              div(class = "btn-group", style = "position: absolute; margin-left: 10px; margin-top: 0px",
                                  div(actionButton("nada", NULL, style = paste0('background-color: transparent;
                                                             border: 0px; width:110px; height: 110px; margin: 0px;
                                                             background-image: url("', agente$img, '");
                                                             background-size: cover, 110px 110px;
                                                             border-radius: 8px 8px 8px 8px')),
                                  )
                              )
                          )
                )
              )
          )
      ),
      if(!is.na(inmo$video)){
        #https://www.youtube.com/watch?v=VJo4htpgH14
        #https://youtu.be/260Ttm-MTDQ?si=pvZy7qpz4AdiNAMa
        video <- inmo$video
        print(video)
        if(str_detect(video, "youtu.be")){
          video <- str_replace(video, fixed("youtu.be/"), fixed("youtube.com/embed/"))
          #video <- str_replace(video, fixed("youtu.be/"), fixed("youtube.com/watch?v="))
        }else{
          if(str_detect(video, fixed("youtube.com/watch?v="))){
            video <- str_replace(video, fixed("youtube.com/watch?v="), fixed("youtube.com/embed/"))
            #video <- video
          }else{
            if(str_detect(video, fixed("youtube.com/shorts/"))){
              video <- video
              #video <- str_replace(video, fixed("youtube.com/shorts/"), fixed("youtube.com/watch?v="))
            }
          }
        }
        print(video)
        if(str_detect(video, fixed("?"))){
          video <- str_split(video, fixed("?"))[[1]][1]
        }
        print(video)
        
        video <- str_split(video, "/")[[1]]
        video <- video[length(video)]
        print(video)
        
        fluidPage(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; min-width: 342px; 
                       border-radius: 10px; background-color: white; padding: 10px; margin: 0px; margin-top: 10px",
                  #HTML(paste0('<iframe src="', video, '?autoplay=1" 
                  #            width="100%" height="100%" allow="accelerometer; autoplay; clipboard-write; encrypted-media;
                  #            gyroscope; picture-in-picture; web-share"></iframe>'))
                  div(embed_youtube(video), align = "center")
        )
      },
      if(inmo$tipoPropiedad == "Proyecto"){
        div(align = "center",
        fluidPage(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; max-width: 684px;
                       border-radius: 10px; background-color: white; padding: 10px; margin: 0px; margin-top: 10px",
                  div(HTML(paste0("<p><span style='font-size: 120%; font-weight: normal; color: #888888'>Tipologías</span></p>")),
                      align = "left"),
                  div(uiOutput("tipologias_box_ui"), align = "center")
        )
        )
      },
      div(
        div(align = "center",
            div(class = "btn-group", style = "width: 342px", align = "left",
                fluidPage(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                       border-radius: 10px; background-color: white; padding: 10px; height: 250px; margin: 0px;
                                                    margin-top: 10px",
                          HTML(paste0("<p><span style='font-size: 120%; font-weight: normal; color: #888888'>Descripción</span></p>")),
                          div(style = "overflow-y: scroll; height: 190px",
                              HTML(paste0("<p><span style='font-size: 100%; font-weight: normal; color: black; white-space: pre-wrap;'>", inmo$descripcion, "</span></p>"))
                          )
                )
            ),
            div(class = "btn-group", style = "width: 342px",
                fluidPage(style = "border-style: solid; border-width: 1px; border-color: #aaaaaa; 
                       border-radius: 10px; background-color: white; padding: 3px; margin: 0px;
                                                    margin-top: 10px",
                          leafletOutput("map_show_inmo", height = 242)
                )
            )
        )
      ),
      div(id = "icon_info",  style = "position: absolute; margin-top: 17px; margin-left: 30px",
          actionButton("inmo_reporte_download", NULL, icon = icon("download"), 
                       style = "background: transparent; border-color: transparent; border-radius: 5px; font-size: 140%;
                                      padding: 0px"),
          div(class = "icon_label", HTML(paste0("<p><span style='font-size: 100%; font-weight: normal; color: #666666'>descargar</span></p>")))
      )
    )
    }else{
      div()
    }
  })
  
  observeEvent(input$close_modal, {
    removeModal()
  })
  
  output$inmo_pages_ui <- renderUI({
      div(
        div(uiOutput("box_inmo_list_ui"), align = "center"),
        div(uiOutput("page_ui"), align = "center"),
        div(uiOutput("cont_page_ui"), align = "center")
      )
  })
  
  obs_edit_tipo <- list()
  
  output$tipologias_box_ui <- renderUI({
    tipo_list_all <- vars$tipologia_list_all
    if(nrow(tipo_list_all) != 0){
      boxes_tipo <- as.list(1:nrow(tipo_list_all))
      boxes_tipo <- lapply(boxes_tipo, function(i){
        tipo <- tipo_list_all[i,]
        div(style = "display:inline-block", 
            div(style = "position: absolute; margin-top: 171px; margin-left: 20px; width: 195px; line-height: 1.2;", 
                HTML(paste0("<p><span style='font-size: 130%; font-weight: normal; color: #777777; height: 45px;'>", 
                            tipo$titulo, "</span></p>"))
            ),
            if(tipo$precio != 0){
              div(style = "position: absolute; margin-top: 216px; margin-left: 20px",
                  h4(paste0(tipo$moneda_contrato, " ", format(tipo$precio, big.mark = ".", decimal.mark = ",", scientific = FALSE), 
                            ifelse(tipo$moneda_contrato == "GS" & tipo$venta_alquiler == "Venta", " millones", "")), 
                     style = paste0("font-weight: lighter; font-size: 180%; color: ", lighten(main_color, 0.20)))
              )
            }else{
              div(style = "position: absolute; margin-top: 226px; margin-left: 20px",
                  h4(" ", style = paste0("font-weight: lighter; font-size: 170%;color: ", lighten(main_color, 0.20)))
              )
            },
            div(style = "position: absolute; margin-top: 266px; margin-left: 20px",
                HTML(paste0("<p><span style='font-size: 110%; font-weight: normal; color: #777777'>
                              <i class='fa fa-bed'></i> ", ifelse(tipo$dormitorios == "0", "M", tipo$dormitorios),
                            "  <i class='fa fa-bath'></i> ", tipo$banios,    
                            "  <i class='fa fa-ruler-combined'></i> ", tipo$m2_cons, "m2",
                            "  <i class='fa fa-car-side'></i> ", tipo$garajes,   
                            "  <i class='fa fa-suitcase'></i> ", tipo$bauleras,
                            "</span></p>"))
            ),
            div(style = "position: absolute; margin-top: 286px; margin-left: 20px",
                HTML(paste0("<p><span style='font-size: 110%; font-weight: normal; color: #777777'>",
                            if(tipo$balcon == "si") "Balcón   ",
                            if(tipo$parrilla == "si") "Parrilla   ",
                            if(tipo$area_servicio == "si") "Area servicio   ",
                            "</span></p>")) 
            ),
            div(style = paste0("border-style: solid; border-width: 1px; border-color: ", main_color, "; 
                       border-radius: 10px; background-color: white; width: 210px; height: 306px;
                                 margin: 10px; padding: 0px"),
                div(actionButton("nada", NULL, style = paste0('background-color: transparent;
                                                             border: 0px; width:208px; height: 156px; margin: 0px;
                                                             background-image: url("', tipo$img, '");
                                                             background-size: cover, 208px 156px;
                                                             border-radius: 8px 8px 0px 0px')),
                )
            )
        )
      })
    }else{
      div()
    }
  })
  
  obs_open_inmo <- list()
  
  observe({
      req(vars$data_per_page)
      if(nrow(vars$data_per_page) > 0){
        isolate({
          data_per_page <- query_mysql(paste0("SELECT * FROM myplace_inmuebles WHERE id IN ", 
                                                   paste("(", paste(paste0("'", vars$data_per_page$id,"'"),collapse = ","), ")"), 
                                                   "ORDER BY fecha DESC;"))
          vars$data_per_page_full <- data_per_page
        })
        output$box_inmo_list_ui <- renderUI({
          boxes <- as.list(1:nrow(data_per_page))
          boxes <- lapply(boxes, function(i){
            inmo <- data_per_page[i,]
            if(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta"){
              inmo$precio <- round(inmo$precio/1000000)
            }
            btOpenInmo <- paste0("open_inmo_button", i) 
            if(inmo$tipoPropiedad == "Proyecto"){
              tipologias <- query_mysql(paste0("SELECT * FROM myplace_tipologias WHERE id IN ", 
                                                    paste("(", paste(paste0("'", inmo$id,"'"),collapse = ","), ")"), ";"))
              if(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta"){
                tipologias$precio <- round(tipologias$precio/1000000)
              }
              precio_min <- format(min(tipologias$precio), big.mark = ".", decimal.mark = ",", scientific = FALSE)
              precio_max <- format(max(tipologias$precio), big.mark = ".", decimal.mark = ",", scientific = FALSE)
              dormitorios_min <- min(ifelse(is.na(as.integer(tipologias$dormitorios)), 1, as.integer(tipologias$dormitorios)))
              dormitorios_max <- max(ifelse(is.na(as.integer(tipologias$dormitorios)), 1, as.integer(tipologias$dormitorios)))
              banios_min <- min(as.integer(tipologias$banios))
              banios_max <- max(as.integer(tipologias$banios))
              m2_cons_min <- format(round(min(tipologias$m2_cons)), big.mark = ".", decimal.mark = ",", scientific = FALSE)
              m2_cons_max <- format(round(max(tipologias$m2_cons)), big.mark = ".", decimal.mark = ",", scientific = FALSE)
              garajes_min <- min(as.integer(tipologias$garajes))
              garajes_max <- max(as.integer(tipologias$garajes))
            }
            
            btOpenInmo <- paste0("open_inmo_button", i) 
            obs_open_inmo[[btOpenInmo]] <<- observeEvent(input[[btOpenInmo]], ignoreNULL = TRUE, ignoreInit = TRUE, {
              freezeReactiveValue(input, btOpenInmo)
              vars$show_inmo <- vars$data_per_page_full[i,]
              showModal(tags$div(id="modal_inmo_double", modalDialog(
                uiOutput("show_inmo_ui"),
                br(),
                tags$div(id="bttn_modal", 
                         actionButton("close_show_inmo", "OK"),
                         align = "center"),
                title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Detalles de la propiedad</span></p>")),
                easyClose = FALSE,
                footer = NULL,
                size = "l",
                fade = TRUE
              )))
            })
            
            div(style = "padding: 7px; display:inline-block", align = "left",
                div(
                  if(str_detect(inmo$id, co)){
                    div(style = "position: absolute; margin-top: 5px; margin-left: 5px",
                        actionButton("nada", NULL, style = paste0('background-color: transparent;
                                                             border: 0px; width:60px; height: 20px; margin: 0px;
                                                             background-image: url("logo_SkyOne_borde_blanco.png");
                                                             background-size: cover, 60px 20px;'))
                    )
                  },
                  div(style = paste0("border-style: solid; border-width: 1px; border-color: ", main_color, "; 
                       border-radius: 10px; background-color: white; width: 160px; height: 193px;
                                 margin: 0px; padding: 0px; box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px"),
                      div(style = "margin-top: 98px; margin-left: 114px; position:absolute",
                         div(style = paste0("width: 45px; background-color: ", main_color, "; height: 20px; border-radius: 5px 0px 0px 5px; padding-left: 5px;"),

                            ),
                         div(style = "margin-top: -22px; margin-left: 5px",
                         HTML(paste0("<p><span style='font-size: 76%; font-weight: normal; padding-right: 10px; margin: 0px; padding: 0px;
                             color: white;'>ID: ", as.integer(str_flatten(str_extract_all(inmo$id, "\\d")[[1]])), "</span></p>"))
                         )
                      ),
                      div(actionButton(btOpenInmo, NULL, style = paste0('background-color: transparent;
                                                             border: 0px; width:158px; height: 118px; margin: 0px;
                                                             background-image: url("', inmo$img, '");
                                                             background-size: cover, 158px 118px;
                                                             border-radius: 8px 8px 0px 0px')),
                      ),
                      div(style = "width: 170px; height: 20px; margin: 7px; margin-top: 0px", 
                          HTML(paste0("<p><span style='font-size: 96%; font-weight: normal; color: #777777; height: 45px'>", 
                                      inmo$tipoPropiedad, " en ", ifelse(inmo$venta_alquiler == "Alquiler temporal", "Alq temp", inmo$venta_alquiler), "</span></p>"))),
                      h4(paste0(inmo$moneda_contrato, " ", ifelse(inmo$tipoPropiedad == "Proyecto", 
                                                                  ifelse(precio_min == precio_max, precio_min, paste0(precio_min, "-", precio_max)),
                                                                  format(inmo$precio, big.mark = ".", decimal.mark = ",", scientific = FALSE)), 
                                ifelse(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta", " millones", "")), 
                         style = paste0("margin: 10px; margin-top: 5px; font-weight: lighter; font-size: ", ifelse(inmo$tipoPropiedad == "Proyecto" && precio_min != precio_max, "100%", "115%"), 
                                        "; color: ", lighten(main_color, 0.20))),
                      div(style = "margin-top: -6px",
                      if(inmo$tipoPropiedad %in% c("Casa", "Casa quinta", "Duplex", "Proyecto", "Departamento", "Edificio")){
                        HTML(paste0("<p><span style='font-size: 86%; font-weight: normal; padding-left: 10px; color: #444444'><i class='fa fa-bed'></i> ", 
                                    ifelse(inmo$tipoPropiedad == "Proyecto", 
                                           ifelse(dormitorios_min == dormitorios_max, dormitorios_min, paste0(dormitorios_min, "-", dormitorios_max)),
                                           ifelse(inmo$dormitorios == "0", "Mono", inmo$dormitorios)), 
                                    " <i class='fa fa-bath'></i> ", 
                                    ifelse(inmo$tipoPropiedad == "Proyecto", 
                                           ifelse(banios_min == banios_max, banios_min, paste0(banios_min, "-", banios_max)),
                                           inmo$banios), 
                                    " <i class='fa fa-ruler-combined'></i> ",
                                    ifelse(inmo$tipoPropiedad == "Proyecto", 
                                           ifelse(m2_cons_min == m2_cons_max, m2_cons_min, paste0(m2_cons_min, "-", m2_cons_max)),
                                           inmo$m2_cons), "m2",
                                    "</span></p>"))
                      },
                      if(inmo$tipoPropiedad %in% c("Terreno")){
                        HTML(paste0("<p><span style='font-size: 86%; font-weight: normal; padding-left: 10px; color: #444444'>",
                                    " <i class='fa fa-ruler-combined'></i> ", format(inmo$m2, big.mark = ".", decimal.mark = ",", scientific = FALSE), "m2</span></p>"))
                      },
                      if(inmo$tipoPropiedad %in% c("Propiedad rural")){
                        HTML(paste0("<p><span style='font-size: 86%; font-weight: normal; padding-left: 10px; color: #444444'>",
                                    " <i class='fa fa-ruler-combined'></i> ", format(inmo$m2/10000, big.mark = ".", decimal.mark = ",", scientific = FALSE), " hectareas</span></p>"))
                      },
                      if(inmo$tipoPropiedad %in% c("Deposito", "Tinglado", "Oficina", "Salón comercial")){
                        HTML(paste0("<p><span style='font-size: 86%; font-weight: normal; padding-left: 10px; color: #444444'>",
                                    " <i class='fa fa-ruler-combined'></i> ", format(inmo$m2_cons, big.mark = ".", decimal.mark = ",", scientific = FALSE), "m2",
                                    if(!is.na(inmo$banios)) paste0(" <i class='fa fa-bath'></i> ", inmo$banios),
                                    if(!is.na(inmo$oficinas)) paste0(" <i class='fa fa-laptop-house'></i> ", inmo$oficinas),
                                    if(!is.na(inmo$garajes)) paste0(" <i class='fa fa-car-side'></i> ", inmo$garajes),
                                    "</span></p>"))
                      }
                      )
                  )
                )
            )
          })
        })
      }else{
        output$box_inmo_list_ui <- renderUI({
          div()
        })
      }
  })
  
  observeEvent(input$close_show_inmo, {
    vars$show_inmo <- NULL
    removeModal()
  })
  
  obs_open_proy <- list()
  
  observe({
    req(vars$scroll, vars$data_per_page_proy)
    if(vars$scroll && nrow(vars$data_per_page_proy) > 0){
      list_proy_all <- query_mysql(paste0("SELECT * FROM myplace_inmuebles WHERE id IN ", 
                                               paste("(", paste(paste0("'", vars$data_per_page_proy$id,"'"),collapse = ","), ")"), 
                                               " ORDER BY fecha DESC;"))
      vars$list_proy_all <- list_proy_all
      output$box_proy_list_ui <- renderUI({
        boxes_proy <- as.list(1:nrow(list_proy_all))
        boxes_proy <- lapply(boxes_proy, function(i){
          print(paste0("Cargando Proyecto ", i))
          inmo <- list_proy_all[i,]
          if(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta"){
            inmo$precio <- round(inmo$precio/1000000)
          }
          btOpenProy <- paste0("open_proy_button", i) 
          if(inmo$tipoPropiedad == "Proyecto"){
            tipologias <- list_table_var_mysql("myplace_tipologias", "id", inmo$id)
            if(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta"){
              tipologias$precio <- round(tipologias$precio/1000000)
            }
            precio_min <- format(min(tipologias$precio), big.mark = ".", decimal.mark = ",", scientific = FALSE)
            precio_max <- format(max(tipologias$precio), big.mark = ".", decimal.mark = ",", scientific = FALSE)
            dormitorios_min <- min(ifelse(is.na(as.integer(tipologias$dormitorios)), 1, as.integer(tipologias$dormitorios)))
            dormitorios_max <- max(ifelse(is.na(as.integer(tipologias$dormitorios)), 1, as.integer(tipologias$dormitorios)))
            banios_min <- min(as.integer(tipologias$banios))
            banios_max <- max(as.integer(tipologias$banios))
            m2_cons_min <- format(round(min(tipologias$m2_cons)), big.mark = ".", decimal.mark = ",", scientific = FALSE)
            m2_cons_max <- format(round(max(tipologias$m2_cons)), big.mark = ".", decimal.mark = ",", scientific = FALSE)
            garajes_min <- min(as.integer(tipologias$garajes))
            garajes_max <- max(as.integer(tipologias$garajes))
          }
          
          obs_open_proy[[btOpenProy]] <<- observeEvent(input[[btOpenProy]], ignoreNULL = TRUE, ignoreInit = TRUE, {
            freezeReactiveValue(input, btOpenProy)
            vars$show_inmo <- vars$list_proy_all[i,]
            showModal(tags$div(id="modal_inmo_double", modalDialog(
              uiOutput("show_inmo_ui"),
              br(),
              tags$div(id="bttn_modal", 
                       actionButton("close_show_inmo", "OK"),
                       align = "center"),
              title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Detalles de la propiedad</span></p>")),
              easyClose = FALSE,
              footer = NULL,
              size = "l",
              fade = TRUE
            )))
          })
          
          div(style = "padding: 15px; display:inline-block", align = "left",
              div(
                if(str_detect(inmo$id, co)){
                  div(style = "position: absolute; margin-top: 5px; margin-left: 5px",
                      actionButton("nada", NULL, style = paste0('background-color: transparent;
                                                             border: 0px; width:60px; height: 20px; margin: 0px;
                                                             background-image: url("logo_SkyOne_borde_blanco.png");
                                                             background-size: cover, 60px 20px;'))
                  )
                },
                div(style = paste0("border-style: solid; border-width: 1px; border-color: ", main_color, "; 
                       border-radius: 10px; background-color: white; width: 164px; height: 233px;
                                 margin: 0px; padding: 0px; box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px"),
                    div(style = "margin-top: 98px; margin-left: 118px; position:absolute",
                        div(style = paste0("width: 45px; background-color: ", main_color, "; height: 20px; border-radius: 5px 0px 0px 5px; padding-left: 5px;"),
                            
                        ),
                        div(style = "margin-top: -22px; margin-left: 5px",
                            HTML(paste0("<p><span style='font-size: 76%; font-weight: normal; padding-right: 10px; margin: 0px; padding: 0px;
                             color: white;'>ID: ", as.integer(str_flatten(str_extract_all(inmo$id, "\\d")[[1]])), "</span></p>"))
                        )
                    ),
                    div(actionButton(btOpenProy, NULL, style = paste0('background-color: transparent;
                                                             border: 0px; width:162px; height: 122px; margin: 0px;
                                                             background-image: url("', inmo$img, '");
                                                             background-size: cover, 162px 122px;
                                                             border-radius: 8px 8px 0px 0px')),
                    ),
                    div(style = "width: 156px; height: 35px; margin: 7px; margin-top: 5px; line-height: 1.2", 
                        HTML(paste0("<p><span style='font-size: 110%; font-weight: normal; color: #777777; height: 45px; font-family: 'Sora';>", 
                                    str_trunc(str_to_upper(inmo$titulo), 45), "</span></p>"))),
                    h4(paste0(inmo$moneda_contrato, " ", 
                              ifelse(precio_min == precio_max, precio_min, 
                                     paste0(precio_min, "-", precio_max)), ifelse(inmo$moneda_contrato == "GS" & inmo$venta_alquiler == "Venta", " millones", "")), 
                       style = paste0("margin: 10px; margin-top: 23px; font-weight: lighter; font-size: ", 
                                      ifelse(precio_min != precio_max, "100%", "115%"), "; color: ", lighten(main_color, 0.20))),
                    div(style = "margin-top: -5px",
                          HTML(paste0("<p><span style='font-size: 86%; font-weight: normal; padding-left: 10px; color: #444444'><i class='fa fa-bed'></i> ", 
                                      ifelse(inmo$tipoPropiedad == "Proyecto", 
                                             ifelse(dormitorios_min == dormitorios_max, dormitorios_min, paste0(dormitorios_min, "-", dormitorios_max)),
                                             inmo$dormitorios), 
                                      " <i class='fa fa-bath'></i> ", 
                                      ifelse(inmo$tipoPropiedad == "Proyecto", 
                                             ifelse(banios_min == banios_max, banios_min, paste0(banios_min, "-", banios_max)),
                                             inmo$banios), 
                                      " <i class='fa fa-ruler-combined'></i> ",
                                      ifelse(inmo$tipoPropiedad == "Proyecto", 
                                             ifelse(m2_cons_min == m2_cons_max, m2_cons_min, paste0(m2_cons_min, "-", m2_cons_max)),
                                             inmo$m2_cons), "m2",
                                      "</span></p>"))
                    )
                )
              )
          )
        })
      })
    }else{
      output$box_proy_list_ui <- renderUI({
        div()
      })
    }
    vars$loaded <- "ok"
  })
  
  obs_page_proy <- list()
  
  observe({
    if(nrow(all_proy) != 0){
      page <- generate_pages(all_proy, vars$n_per_page_proy, vars$max_pages_proy, vars$page_selected_proy)
      output$proy_page_ui <- renderUI({
        pages <- as.list(page$min:page$max)
        pages <- lapply(pages, function(i){
          btPage <- paste0("proy_page", i)
          obs_page_proy[[btPage]] <<- observeEvent(input[[btPage]], ignoreNULL = TRUE, ignoreInit = TRUE, {
            freezeReactiveValue(input, btPage)
            isolate({
              vars$page_selected_proy <- i
              if(i == page$n_pages){
                vars$data_per_page_proy <- all_proy[(vars$n_per_page_proy*i-vars$n_per_page_proy + 1):(vars$n_per_page_proy*(i - 1) + page$last_page),]
              }else{
                vars$data_per_page_proy <- all_proy[(vars$n_per_page_proy*i-vars$n_per_page_proy + 1):(vars$n_per_page_proy*i),]
              }
            })
          })
          div(style = "padding: 5px; display:inline-block",
              if(i == page$min & page$min != page$max){
                tags$div(class = "btn-group",
                         actionButton("go_first_page_proy", NULL, icon = icon("angle-double-left"),
                                      style = paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; margin-right: 10px; width: 30px; font-size: 90%; padding-left: 10px")),
                         actionButton(btPage, as.character(i), 
                                      style = ifelse(i == vars$page_selected_proy, 
                                                     paste0("background-color: ", main_color, "; color: white; border: 1px; border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"),
                                                     paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%")))
                )
              },
              if(i == page$max & page$min != page$max){
                tags$div(class = "btn-group",
                         actionButton(btPage, as.character(i), 
                                      style = ifelse(i == vars$page_selected_proy, 
                                                     paste0("background-color: ", main_color, "; color: white; border: 1px; border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"),
                                                     paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"))),
                         actionButton("go_last_page_proy", NULL, icon = icon("angle-double-right"),
                                      style = paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; margin-left: 10px; width: 30px; font-size: 90%; padding-left: 10px"))
                )
              },
              if((i != page$min & i != page$max) | page$min == page$max){
                actionButton(btPage, as.character(i), 
                             style = ifelse(i == vars$page_selected_proy, 
                                            paste0("background-color: ", main_color, "; color: white; border: 1px; border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%"),
                                            paste0("background-color: white; color: ", main_color, "; border: 1px;  border-radius: 5px;
                                                border-color: ", main_color, "; font-size: 90%")))
              }
          )
        })
      })
    }else{
      output$proy_page_ui <- renderUI({
        div()
      })
    }
  })
  
  output$cont_proy_page_ui <- renderUI({
    req(vars$data_per_page_proy)
    if(nrow(all_proy) != 0){
      vars$data_per_page_proy <- vars$data_per_page_proy[!is.na(vars$data_per_page_proy$id),]
      div(style = "background-color: white; border-radius: 5px; width: 160px; padding-left: 6px",
          paste0("  Mostrando ", (vars$page_selected_proy - 1)*vars$n_per_page_proy + 1, "-", 
                 (vars$page_selected_proy - 1)*vars$n_per_page_proy + nrow(vars$data_per_page_proy), " de ",
                 nrow(all_proy))
      )
    }
  })
  
  observeEvent(input$go_first_page_proy, {
    req(vars$page_selected_proy)
    isolate({
      vars$data_per_page_proy <- generate_pages(all_proy, vars$n_per_page_proy, vars$max_pages_proy, 1)$data
      vars$page_selected_proy <- 1
    })
  })
  
  observeEvent(input$go_last_page_proy, {
    req(vars$page_selected_proy)
    isolate({
      page <- generate_pages(all_proy, vars$n_per_page_proy, vars$max_pages_proy, 1)
      vars$page_selected_proy <- page$n_pages
      vars$data_per_page_proy <- all_pages[(vars$n_per_page_proy*page$n_pages-vars$n_per_page_proy + 1):(vars$n_per_page_proy*(page$n_pages - 1) + page$last_page),]
    })
  })
  
  
  
######################################################################################################
#oficinas
  
  obs_open_ofi <- list()
  
  observe({
    oficinas <- load_mysql("skyone_agencias_data")
    oficinas <- oficinas[!str_detect(oficinas$name, "Aliados") & !oficinas$id %in% c("agencia_0000000002", "agencia_0000000010"),]
    brokers <- list_table_var_mysql("myplace_usuarios", "user", oficinas$mail) %>% select(agencia, name_broker = name, phone_broker = phone, img_broker = img)
    oficinas <- left_join(oficinas, brokers, by = c("id" = "agencia"))
      output$oficinas_list <- renderUI({
        boxes <- as.list(1:nrow(oficinas))
        boxes <- lapply(boxes, function(i){
          ofi <- oficinas[i,]

          btOpenOfi <- paste0("open_ofi_button", i) 

          obs_open_inmo[[btOpenOfi]] <<- observeEvent(input[[btOpenOfi]], ignoreNULL = TRUE, ignoreInit = TRUE, {
            freezeReactiveValue(input, btOpenOfi)
            vars$show_ofi <- oficinas[i,]
            showModal(tags$div(id="modal_inmo_double", modalDialog(
              div(id = "inline",
                  textInput("new_asesor_name", "Nombre y Apellido"),
                  textInput("new_asesor_phone", "Teléfono"),
                  textAreaInput("new_asesor_comment", "¿Por qué te gustaría ser un asesor Skyone?")
              ),
              br(),
              tags$div(id="bttn_modal", 
                       actionButton("new_asesor_ok", "Enviar"),
                       actionButton("close_modal", "Cancelar"),
                       align = "center"),
              title = HTML(paste0("<p><span style='margin-left: 20px; font-size: 100%; font-weight: normal; color: white;'>Asesor SkyOne</span></p>")),
              easyClose = FALSE,
              footer = NULL,
              size = "s",
              fade = TRUE
            )))
          })
          
          div(style = "padding: 20px; display:inline-block", align = "left",
              div(
                div(style = paste0('border-style: solid; border-width: 1px; border-color: ', main_color, '; 
                                    border-radius: 10px; 
                                    background: white;
                                    width: 250px; height: 460px;
                                    margin: 0px; padding: 0px; box-shadow: rgba(0, 0, 0, 0.4) 0px 5px 20px 0px'),
                    div(style = 'border-radius: 9px 9px 0px 0px;
                                 background-image: url("fondo_ofis.jpg");
                                 background-size: cover, 250px 460px;
                                 width: 248px; height: 240px;
                                 margin: 0px; padding: 0px;',
                        div(style = "width: 240px; height: 240px;", align = "center",
                            br(),
                            img(src = "skyone_logo_blanco.png", width = 80),
                            br(),
                            h3(str_remove(ofi$name, "SkyOne "), style = "color: white"),
                            br(),
                            h5(ofi$addr, style = "color: white; font-size: 90%")
                            )
                    )
                ),
                tags$div(id="bttn_modal", style = "position: absolute; margin-top: -50px; margin-left: 47px",
                         actionButton(btOpenOfi, "Quiero ser Asesor"),
                ),
                div(align = "center", style = "position:absolute; margin-top: -280px; width: 250px;
                                               font-size: 120%; color: #666666; padding: 10px",
                    div(style = "padding: 5px; height: 100px",
                        actionButton("perfil_open", NULL, style = paste0('background-color: transparent;
                                                             border-radius: 50px;
                                                             border: 0px; width:100px; height: 100px;
                                                             background-image: url("', ofi$img_broker, '");
                                                             background-size: cover, 100px 100px;'))),
                    h5(ofi$name_broker, style = paste0("color: ", main_color, "; font-size: 110%")),
                    h5("Broker Manager", style = paste0("color: ", main_color, "; font-size: 90%")),
                    h5(ofi$phone_broker, style = paste0("color: ", main_color, "; font-size: 90%"))
                )
              )
          )
        })
      })
  })
  
  
  
  
  
}



shinyApp(ui, server)

