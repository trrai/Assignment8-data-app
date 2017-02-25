library(shiny)

data("iris")
iris_db<-iris

sepal.range <- range(iris_db$Sepal.Length)
petal.range <- range(iris_db$Petal.Length)

ui <- fluidPage(
  

  titlePanel("Iris Data Viewer"),
  

  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput('sepal.choice', label="Sepal Length", min=sepal.range[1], max=sepal.range[2], value=sepal.range, step=.1),
      
      sliderInput('petal.choice', label="Petal Length", min=petal.range[1], max=petal.range[2], value=petal.range, step=.1),
      
      selectInput('species.choice', label="Species: ", choices = c("setosa", "versicolor", "virginica")),
      
      checkboxInput('smooth', label=strong("Show Trendline"), value=TRUE),
      
      numericInput('size.choice',  value=1, min=1, label="Dot Size: ")
      
    ),
    
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", 
                 plotOutput('plot', brush = "plot_brush"),
                 p(textOutput('description', inline=TRUE)),
                 p(strong("Highlighted Points:"), tableOutput('selected'))
          
          
          ),
        tabPanel("Table", dataTableOutput('table'))
      )
     
    )
  )
)

shinyUI(ui)