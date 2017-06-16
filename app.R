#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(tidyverse)
CA <- read_delim("CA.csv", delim="|")

shinyApp(
ui = fluidPage(
  headerPanel('Spatial data by feature'),
  sidebarPanel(
  selectInput(inputId="feature", label="Select a feature",c("Park","School", "Valley", "Spring", "Tunnel", "Stream","Gut","Mind","Train","Summit","Reservoir")),
  sliderInput(inputId="trans", label="Select a opacity", min=0, max=1, value=0.35)
  ),mainPanel( 
  leafletOutput("mymap"))),


server = function(input, output) {
  output$mymap <- renderLeaflet({
    leaflet() %>% addProviderTiles(providers$Stamen.TonerLines,
                                   options = providerTileOptions(opacity = input$trans)) %>% 
      setView(lng = -120, lat = 38, zoom = 9)})
    observe({
        sites <- CA %>% 
          filter(CA$class == input$feature)
        
        leafletProxy("mymap") %>% clearMarkers() %>% addProviderTiles(providers$Stamen.Toner)%>% addMarkers(lng = sites$lon, lat= sites$lat, label=input$feature, clusterOptions = markerClusterOptions()
)
        })
  }, options = list(height = 600)
)


