## Global
## load packages ----
library(shiny)
library(tidyverse)

## read data ----
participants <- read_csv("participants.csv")
questions <- read_csv("questions.csv")

## UI ----
ui <- fluidPage(
  
  h1("Delta Presentations Icebreaker"),
  
  hr(),
  

  h3("1. Share a Fact"),
  
  br(),
  
  actionButton(inputId = "select_question",
               label = "Press to select a question"),
  
  tableOutput("question_output"),
  
  br(),
  br(),
  
  h3("2. Glows and Grows"),
  h4("Please share a positive experience (achivement, something you are proud of) AND something that you think you can improve or learn from this past year working on the synthesis project"),
  
  
  br(),
  br(),
  
  
  h3("3. Choose a number from 1-17 to see who comes next"),
  
    # Copy the line below to make a number input box into the UI.
    textInput("num_input", 
                 label = "Type Number", 
                 value = NA),
    
    
    tableOutput("name_ouput"),
    
  fluidRow(
    column(width = 4,
           checkboxGroupInput("checkGroup", 
                              label = h5("Selected Numbers"), 
                              choices = list("1" = 1, 
                                             "2" = 2, 
                                             "3" = 3,
                                             "4" = 4,
                                             "5" = 5,
                                             "6" = 6),
                              selected = NA)
           ),
    column(width = 4,
           checkboxGroupInput("checkGroup", 
                              label = " ", 
                              choices = list("7" = 7,
                                             "8" = 8,
                                             "9" = 9,
                                             "10" = 10,
                                             "11" = 11,
                                             "12" = 12),
                              selected = NA)
           ),
    
    column(width = 4,
           checkboxGroupInput("checkGroup", 
                              label = " ", 
                              choices = list("13" = 13,
                                             "14" = 14,
                                             "15" = 15,
                                             "16" = 16,
                                             "17" = 17))
    ) #END 3rd column
    
    
  )# END fluid row
    
) #END UI Fluid page

## Sever ----

server <- function(input, output){
  
  # summary_table_RCT <- eventReactive(input$tbl, {summary_table})
  
  the_question <- eventReactive(input$select_question, {
    
    temp_question <- purrr::map_dfr(1:1, ~ slice_sample(questions,
                                       n = 1, replace = T),
                                     .id = "simulation") %>%
      select(Question = questions)
    
    # ## transform to DF
    # the_question <- as.data.frame(temp_question)

  })

  output$question_output <- renderTable({the_question()})

  draft_name <- reactive({participants %>% 
    filter(draft_num == input$num_input) %>% 
      select(Name = participant_name)
    
    }) #END reactive DF
  
  # name output table
  output$name_ouput <- renderTable({ draft_name() })
  
  
} # END server

# combine UI & server into an app ----
  shinyApp(ui = ui, server = server)

