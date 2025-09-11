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