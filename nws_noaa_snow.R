snowfall<-function(year,month,num_days=28)
{
  
month<-sprintf("%02d",month)
  
noaa<-paste("http://www.nohrsc.noaa.gov/nsa/discussions_text/National/snowfall/",year,month,"/snowfall_",year,month,"0106_e.txt", sep="")
snow_sum<-read.table(noaa,sep="|",skip=1,header=T,fill=T)
  
  
for(i in 2:num_days)
{
#snow_sum<-ddply(snow, .(Zip_Code), summarise, Snow = sum(Amount))
#write.table(snow_sum,"snow.txt",row.names=F,sep="|")
day=sprintf("%02d",i)
noaa<-paste("http://www.nohrsc.noaa.gov/nsa/discussions_text/National/snowfall/",year,month,"/snowfall_",year,month,day,"06_e.txt",sep="")
snow<-read.table(noaa,sep="|",skip=1,header=T,fill=T)

snow_sum<-rbind(snow_sum,snow)

}
return(snow_sum)
}

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Geo Snow Totals by NWS-NOAA Weather Station Observations"),

  sidebarLayout(
    sidebarPanel(
      h6("Total snowfall (inches) accumulated from November-January in given year."),
      sliderInput("Amount",
                  "Cutoff Snow Amount (Inches):",
                  min = 1,
                  max = 50,
                  value = 15),
          
    selectInput("Year", "Select Year:", 
                choices = list(2013,2012,2011), selected = 2013)),    
    
    
    mainPanel(
      htmlOutput("view")
    )
  )
))

library(shiny)

shinyServer(function(input, output) {


  output$view<- renderGvis({
    
    if(input$Year==2013)sim<-subset(Q42013,Amount>input$Amount)
    if(input$Year==2012)sim<-subset(Q42012,Amount>input$Amount)
    if(input$Year==2011)sim<-subset(Q42011,Amount>input$Amount)
    
    gvisGeoChart(sim, "loc", "Amount",options=list(region="US",displayMode="Markers", colorAxis="{colors:['purple', 'red', 'orange', 'grey']}", backgroundColor="lightblue"), chartid="Snow")
    
  })
})
