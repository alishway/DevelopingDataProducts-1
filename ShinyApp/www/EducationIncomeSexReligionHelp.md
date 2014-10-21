---
title: "About"
output: 
    html_document:
        theme: cerulean
---

# About

A little info to get you working with this shiny app. 


## How to use the app.

At the top of this app there are a number of tabs (Documentation, Barplot, Facet plot and Box plot).
- Documentation: That's all this info right here!
- Barplot: This tab shows a barplot of the mean family income seperated by degree.
- Facet plot: A scatter plot showing the change in time of the average family income for each degree group and the male femal groups.
- Box plot: A box plot showing the mean family income separated into religous groups and male/female groups.

Adjust the sliders to produce a range of years that you are interested in examining and do the same for the the age of respondents you are interested in examining.

You can pick the gender grouping that you'd like to examine with the drop down menu. The options are
- Together (no distinction between genders)
- Seperate (treat males and females as seperate groups)
- Male only (just the males)
- Female only (just the females)

The radio buttons Remove NA ad Keep NA concern analysis of respondents whom have no recrod for highest degree obtained. Keep NAs means that we will also include such records.

The update Summary Table button: Hitting this button does something different on each of the tabed pages of this app. This button provides us with a summary table with the "relevant" information being shown to you on the plot. NOTE: when you make changes to your options the plots will update but you must hit the update summary table button to actually update the table.



## What this app is about.

This app has been made primarily to test the use of shiny apps to create data products. 

The aim is to explore data concerning US citizens, their family income, their education, the sex of the repondents and their religion.

DISCLAIMER: Although it's interesting to look at relationships as set out here in the shiny app it is important that any conclusions you wish to draw are based on a thorough statistical analysis. Make sure the source of the data is understood and that you understand the assumptions and any analysis that is being performed before using "results" for anything more than fun and illustration.

## The data

The data is taken from  a long standing survey of US citizens, the 'General Social Survey' (GSS). A sociological survey used to collect data on demographic characteristics and attitudes of residents of the United States. This is a cumulative data file for surveys conducted between 1972 - 2012. The data complete data set can be found at this [Persistent URL](http://doi.org/10.3886/ICPSR34802.v1).

### The observational units from the GSS data

Quoting from the GSS codebook the observational units for the study are "English-speaking persons 18 years of age or over, living in noninstitutional arrangements within the United States".
