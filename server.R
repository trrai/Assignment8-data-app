library(shiny)
library(ggplot2)
library(dplyr)

data("iris")
iris_db<-iris

server <- function(input, output) {
  
  filtered <- reactive({
    data <- iris_db %>%
      filter(Species == input$species.choice) %>% 
      filter(Sepal.Length > input$sepal.choice[1] & Sepal.Length < input$sepal.choice[2]) %>%
      filter(Petal.Length > input$petal.choice[1] & Petal.Length < input$petal.choice[2])
    return(data)
  })
  
  output$plot <- renderPlot({

    p <- ggplot(data = filtered(), mapping = aes(x = Sepal.Length, y = Petal.Length)) +
      geom_point(size = input$size.choice) + xlab("Sepal Length") + ylab("Petal Length") + 
      ggtitle("Comparing Sepal and Petal Length") + theme( axis.text = element_text(size=12), 
            axis.title = element_text(size=15), plot.title = element_text(size=20))
   
    if(input$smooth) {
      p <- p + geom_smooth(se = FALSE)
    }
    
    return(p)
  })
  
  #Make group of reactive variables
  reactives<-reactiveValues()
  
  desc<-reactive({
    paragraph<-paste0("The graph above is a visual representation for data collected from 150 Iris plants. Currently, the graph represents the ",
    input$species.choice, " species of Iris plants. The visual shows a correlation between the sepal length of the plant and the
    petal length. Sepal length is on a scale from ", input$sepal.choice[1], "cm to ", input$sepal.choice[2],"cm and petal length
    ranges from ", input$petal.choice[1], "cm to ", input$petal.choice[2], "cm. ")
    return(paragraph)
  })
  
  output$description<- renderText({
    return(desc())
  })
  
  reactives$selectedXRange<-"" #initialize values
  reactives$selectedYRange<-"" 
  
  observeEvent(input$plot_brush, { 
  
    selected<-brushedPoints(iris_db, input$plot_brush)
    reactives$selectedXRange<-selected$Sepal.Length
    reactives$selectedYRange<-selected$Petal.Length
    
    
  })
  
  selected_df <- reactive({
    x<-reactives$selectedXRange
    y<-reactives$selectedYRange
    names<-c("Sepal Length", "Petal Length")
    selected_points<-data.frame(x,y)
    colnames(selected_points)<-names
    return(selected_points)
  })
    
  output$selected <- renderTable({
    return(selected_df())
  })

  
  output$table <- renderDataTable({
    return(filtered())
  })
}

shinyServer(server)