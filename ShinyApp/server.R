# The introductory server.R script
library(shiny)

# This is where we put call to helper functions or data loading functions
#
# Code out here is run only once.
library(dplyr)
library(ggplot2)

# Read in the data
gsstbl <- readRDS("./data/gsstbl.rds")

# Suppress warning
options( warn = -1 ) # Set this to zero for regular behaviour

shinyServer(
    function(input, output){
        
        # The variables and text outputs concerning years
        
        yrlwr <- reactive(input$irange[1])
        yrupr <- reactive(input$irange[2])
        output$oyearstext <- renderText({ 
            paste("From", yrlwr(), "to", yrupr())
        })
        
        agelwr <- reactive(input$irangeage[1])
        ageupr <- reactive(input$irangeage[2])
        output$oagestext <- renderText({
            paste("From", agelwr(), "to", ageupr())
        })
        
        # The variables and text outputs concerning gender group
        gendergroupoption <- reactive(input$igendergroup)
        output$ogendergroup <- renderPrint({gendergroupoption()})
        
        # The variables and outputs concerning the go button
        output$ogotext <- renderText({
            if (input$igoButton == 0){"You haven't hit go!"}
            else if (input$igoButton %% 2 == 1){"You've hit go an odd num of times"}
            else if (input$igoButton %% 2 == 0){"You've hit go an even num of times"}
        })
        
        removeNAs <- reactive(input$iremoveNA)
        output$oremoveNA <- renderText({ 
            paste("Remove NAs:", removeNAs())
        })
        
        
        
        # Data filtering based on input options
        # - Date
        # - gender grouping
        # - NA records
        # - age
        
        # Need to put a data reset here
        #gsstbl_filtered <- gsstbl
        #===========================
        
        #==============
        # Filter years
        #============== 
        gsstbl_filter_years <- reactive({
            # Need to catch the case when user picks a specific year where there is no data
            # '79,81,92,95,97,99,01,03,05,07,09,11
            if( yrlwr()!=yrupr() ){
                filter(gsstbl, (year >= yrlwr() ) & (year <= yrupr() ) )
            }else if( yrupr() %in% c(1979,1981,1992,1995,1997,1999,2001,2003,2005,2007,2009,2011) ){
                filter(gsstbl, (year >= yrlwr() ) & (year <= yrupr() + 1 ) )
            }else{
                filter(gsstbl, (year >= yrlwr() ) & (year <= yrupr() ) )
            }
        })
        #==========================
        # Filter on gender + years
        #==========================
        gsstbl_filter_gender <- reactive({
            if(gendergroupoption() == "Male Only") {gsstbl_filter_years() %>% filter(sex=="Male")}
            else if (gendergroupoption() == "Female Only") {gsstbl_filter_years() %>% filter(sex=="Female")}
            else {gsstbl_filter_years()} # want both male and female
        })
        
        #================================
        # Filter on age + gender + years
        #================================ 
        gsstbl_filter_age <- reactive({
            gsstbl_filter_gender() %>% filter( ( (age >= agelwr() )&(age <= ageupr() ) ) )
        })
        
        #============================================
        # Filter on na removal + age + gender + years
        #============================================
        gsstbl_filtered <- reactive({
            if(removeNAs()){na.omit(gsstbl_filter_age())}
            else {gsstbl_filter_age()}
        })
        
        
        
        # Make average income histogram
        output$oplot1 <- renderPlot({
            if( gendergroupoption() == "Separate"){
                gsstbl_filtered() %>%
                    group_by(degree,sex) %>%
                    summarize(meanFamilyIncome=mean(coninc,na.rm=TRUE)) %>%
                    ggplot(aes(x=degree,y=meanFamilyIncome,fill=sex)) +
                    geom_bar(stat="identity", position=position_dodge()) +
                    labs(title="Average income by highest form of education")
                
            }else{
                gsstbl_filtered() %>%
                    group_by(degree) %>%
                    summarize(meanFamilyIncome=mean(coninc,na.rm=TRUE)) %>%
                    ggplot(aes(x=degree,y=meanFamilyIncome,fill=degree)) +
                    geom_bar(stat="identity") +
                    labs(title="Average income by highest form of education")
            }

        })# End of render plot
        
        
        
        # Make facet plot
        output$oplot2 <- renderPlot({
            
            if( gendergroupoption() == "Separate"){
                gsstbl_filtered() %>%
                    group_by(year,degree,sex) %>%
                    summarize(meanInc=mean(coninc,na.rm=TRUE)) %>%
                    ggplot(aes(x=year,y=meanInc,group=sex,color=sex)) + 
                    geom_point() + 
                    #geom_line() + 
                    facet_wrap(~ degree,ncol = 2,scales="free") +
                    #geom_smooth(method="lm", se=FALSE) +
                    labs(title="Change in time of average income grouped by degree & gender with linear fit")
                
            }else{
                gsstbl_filtered() %>%
                    group_by(year,degree,sex) %>%
                    summarize(meanInc=mean(coninc,na.rm=TRUE)) %>%
                    ggplot(aes(x=year,y=meanInc,color=degree)) + 
                    geom_point() + 
                    #geom_line() + 
                    facet_wrap(~ degree, ncol = 2,scales="free") +
                    #geom_smooth(method="lm", se=FALSE) +
                    labs(title="Change in time of average income grouped by degree & gender with linear fit")
            }
        })# End render plot
        
        
        # Make boxplot
        output$oplot3 <- renderPlot({
            
            if( gendergroupoption() == "Separate"){
                gsstbl_filtered() %>% 
                    group_by(degree,relig,sex) %>%
                    ggplot(aes(x=relig,y=coninc,color=sex,fill=relig)) + 
                    geom_boxplot(position=position_dodge()) +
                    theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
                #facet_wrap(~relig, ncol=3)
                
            }else{
                gsstbl_filtered() %>% 
                    group_by(degree,relig) %>%
                    ggplot(aes(x=relig,y=coninc,fill=relig)) + 
                    geom_boxplot(position=position_dodge(),color="black") +
                    theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
                #facet_wrap(~relig, ncol=3)
            }
        }) # End render plot
        
        
        # The summary table for the bar chart (plot1)
        output$osummarytext <- renderDataTable({
            if(input$igoButton){
                isolate(
                    if( gendergroupoption() == "Separate"){
                        gsstbl_filtered() %>% 
                            group_by(degree,sex) %>% 
                            summarize(meanFamilyIncome=mean(coninc,na.rm=TRUE))     
                    }else{
                        gsstbl_filtered() %>% 
                            group_by(degree) %>% 
                            summarize(meanFamilyIncome=mean(coninc,na.rm=TRUE)) 
                    } #End else
                ) # End Isolate
            } # End push button If
        }) # End osummarytext render DataTable
    
        # The summary table for the facet chart (plot2)
        output$osummarytext2 <- renderDataTable({
            if(input$igoButton){
                isolate(
                    if( gendergroupoption() == "Separate"){
                        gsstbl_filtered() %>% 
                            group_by(year,degree,sex) %>% 
                            summarize(meanFamilyIncome=mean(coninc,na.rm=TRUE))     
                    }else{
                        gsstbl_filtered() %>% 
                            group_by(year,degree) %>% 
                            summarize(meanFamilyIncome=mean(coninc,na.rm=TRUE)) 
                    } #End else
                ) # End Isolate
            } # End push button If
        }) # End osummarytext render DataTable
        
        # The summary table for the box chart (plot3)
        output$osummarytext3 <- renderDataTable({
            if(input$igoButton){
                isolate(
                    if( gendergroupoption() == "Separate"){
                        gsstbl_filtered() %>% 
                            group_by(relig,sex) %>% 
                            summarize(num.dataRecords=length(relig),
                                      medianFamilyIncome=median(coninc,na.rm=TRUE),
                                      meanFamilyIncome=mean(coninc,na.rm=TRUE))     
                    }else{
                        gsstbl_filtered() %>% 
                            group_by(relig) %>% 
                            summarize(num.dataRecords=length(relig),
                                      medianFamilyIncome=median(coninc,na.rm=TRUE),
                                      meanFamilyIncome=mean(coninc,na.rm=TRUE)) 
                    } #End else
                ) # End Isolate
            } # End push button If
        }) # End osummarytext render DataTable
        
        
    }# End main function input,output
)# End shiny server