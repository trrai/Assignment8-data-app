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
                 p(strong("Highlighted Points:"), "(Click and drag on chart to select points!)", tableOutput('selected'))
          
          
          ),
        tabPanel("Table", 
                 p("The table below is a collection of the data visualized in the plot. Although, in addition to seeing the 
                   sepal height and petal height, you're also able to see the sepal width and petal width! You can search for 
                   specific data entries using the search bar on the right, or organize how many results you would like to see
                   per page using the selector on the left."),
                 dataTableOutput('table')
                 )
      )
     
    )
  )
)

shinyUI(ui)