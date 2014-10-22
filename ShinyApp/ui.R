# Developing Data Products - Project
# GSS data explorer app

library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Data Exploration: Income, Education, Gender and Religion!"),
    sidebarPanel(
        h3('Data Options'),
        
        sliderInput("irange", 
                    label = "Year(s) of interest:",
                    min = 1972, max = 2012, value = c(1972, 2012)),
        
        sliderInput("irangeage", 
                    label = "Subject age of interest:",
                    min = 18, max = 89, value = c(18, 89)),
        
        selectInput("igendergroup", 
                    label = "Pick Gender Grouping",
                    choices = list("Together", "Separate",
                                   "Male Only", "Female Only"),
                    selected = "Together"),
        
        radioButtons("iremoveNA",
                           label="Remove records with NA degree record",
                           c("Remove NA"=TRUE, "Keep NA"=FALSE)),
        
        actionButton("igoButton","Update Summary Table"),
        
        h4('The years of interest'),
        verbatimTextOutput("oyearstext"),
        
        
        h4('The age(s) of interest'),
        verbatimTextOutput("oagestext"),
        
        h4('Gender Grouping'),
        verbatimTextOutput("ogendergroup"),
        
        
        h4('Remove NA degree records'),
        verbatimTextOutput("oremoveNA")
        
        
    ),
    
    mainPanel(
        
        tabsetPanel(
            tabPanel("Documentation",
                     includeHTML("www/EducationIncomeSexReligionHelp.html")),
            tabPanel("Barplot",
                     plotOutput("oplot1"),
                     h4('Data Summary'),
                     dataTableOutput('osummarytext')),
            tabPanel("Facet plot",plotOutput("oplot2"),
                     h4('Data Summary'),
                     dataTableOutput('osummarytext2')),
            tabPanel("Box plot",plotOutput("oplot3"),
                     h4('Data Summary'),
                     dataTableOutput('osummarytext3'))
            
        ) #tabsetPanel End 
    ) # mainPanel End
) # pagewithsidebar End
)# Shiny UI End