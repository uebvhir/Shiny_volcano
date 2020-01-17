library(shiny)
library(shinydashboard)
library(shinyjs)

ui <- dashboardPage(
  dashboardHeader(title = "Volcano Plot",
                  titleWidth = 230),
  skin = "purple", 
  dashboardSidebar(
    #Generem el menu lateral amb 'sidebarMenu'
    sidebarMenu(
      menuItem("Upload files & Settings", tabName = "upload", icon = icon("upload")),
      menuItem("Results", tabName = "results", icon = icon("bar-chart")),
      menuItem("Help", tabName = "help", icon = icon("question-circle"))
    )
  ),
  #Generem els panells de cada apartat del menu lateral amb 'dashboardBody'
  dashboardBody(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
    tabItems(
      tabItem(tabName = "upload",
              h3("Choose input files"), br(),
              fluidPage(splitLayout(
                fileInput('file1', 'Upload your data file',
                          accept = c('text/csv',
                                     'text/comma-separated-values',
                                     'text/tab-separated-values',
                                     'text/plain',
                                     '.csv',
                                     '.tsv')),
                hr(),
                radioButtons('sep1', 'Separator', c('Tab' ='\t','Comma (,)' =',', 'Semicolon (;)' =';'),";"),
                radioButtons('dec1', 'Decimal',   c('Point (.)'='.', 'Comma (,)'=','), '.')
              )),
              
              fluidPage(splitLayout(
                box(title = "First rows and columns of the data matrix", status = "primary", solidHeader = TRUE, 
                    tableOutput("table1"), height = "auto", width = "auto"))
              ),
             hr(),
              fluidPage(splitLayout(
                textInput("title", "Please enter the title plot:")))
              
      ),
      
      tabItem(tabName="results",
              fluidRow(
              box(title = "Configure your Volcano",status = "primary", solidHeader = TRUE,width=10,
                  fluidPage(splitLayout(
                    sliderInput("Bvalue", "Choose the desired B value", 0, 30, 1,step = 0.5),
                    radioButtons("color", "Choose the color for the DE genes", c("red","green","blue")))),
                  fluidPage(splitLayout(
                    sliderInput("FCm", "Choose the negative Fold Change", -10, 0, -2,step = 0.5),
                    sliderInput("FC", "Choose the positive Fold Change", 0, 10, 2,step = 0.5))))),
              fluidRow(
              box(title = "Volcano Plot", status = "primary", solidHeader = TRUE, width = 10,
                  plotOutput("plot1")),
              fluidPage(splitLayout(downloadButton('down', 'Download as pdf'))))),
      
      tabItem(tabName = "help",
              p("Volcano plot  is a type of scatter-plot that is used to quickly identify changes in large data 
                sets composed of replicate data. It plots significance versus fold-change on the y and x axes, 
                respectively. As a prerequisite for invoking the volcano plot, you must run a Differential 
                gene expression analysis.
                This web tool performs a strong (volcano plot) of a dataset uploaded by the user and allow to 
                change the thresholds for y and x axes to select which genes are desired to be emphasized.
                You need to perform this steps to have a nice volcano plot :) :"),
              tags$ol(
                tags$li(p(strong("Upload your file: ")," We need the data file to perform heat map with the
                          web tool:"),
                    tags$ul(tags$li(p(strong("Data file: "), "Load your data (usually a toptable derived from a
                                      differential expression analysis) of interest in .csv or .txt 
                                      format, knowing in advance how the values and decimal numbers are separated.
                                      The minimal columns you need in your data file are (the columns name should 
                                      be the same as follows):")),
                                      tags$ul(p(strong("Gene Symbol:"),"A column with the name/identification of 
                                                the genes.")),
                                      tags$ul(p(strong("logFC:"), "A column with the biological change, usually fold
                                                change")),
                                      tags$ul(p(strong("B value:"),"A column with the statistical significance."))))
                                     
                
      )
    )
  )
)
)

