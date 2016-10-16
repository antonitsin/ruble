
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Renting vs Buying Analysis"),

  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("price",
                "House cost (k):",
                min = 400,
                max = 1200,
                value = 750),
    
    sliderInput("down",
                "Downpayment (k):",
                min = 50,
                max = 1000,
                value = 150),
    
    sliderInput("interest",
                "Morgage interest: (%)",
                min = 0,
                max = 8,
                value = 5,
                step=0.05),
    
    radioButtons("loan_yrs", label = h3("Loan years"),
                 choices = list("30 Yrs" = 30, "15 Yrs" = 15, "10 Yrs" = 10), 
                 selected = 30), 
    
    sliderInput("tax",
                "Property tax (%):",
                min = 0,
                max = 2,
                value = 1.025,
                step=0.025),

  
  sliderInput("maintain",
              "Maintanence annual cost:",
              min = 1000,
              max = 15000,
              value = 1000),
  
  sliderInput("hoa",
              "HOA:",
              min = 0,
              max = 1000,
              value = 0),
  
  sliderInput("insur",
              "Insuarance:",
              min = 50,
              max = 1000,
              value = 800),
  
  sliderInput("apprec",
              "Appreciation (%):",
              min = 0,
              max = 8,
              value = 2,
              step=0.05),
  
  sliderInput("marg_tax",
              "Tax bracket (%):",
              min = 10,
              max = 50,
              value = 30),
  
  sliderInput("inflation",
              "Inflation (%):",
              min = 0,
              max = 10,
              value = 2),
  
  sliderInput("rent",
              "Rent:",
              min = 1000,
              max = 7000,
              value = 2600),
  
  sliderInput("rent_inflation",
              "Rent Inflation:",
              min = 0,
              max = 8,
              value = 2,
              step=1),
  
  sliderInput("cash_return",
              "Cash return:",
              min = 0,
              max = 8,
              value = 4,
              step=1)
  

),
  
#  Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot"),
    h1("Youtube video for analysis"),
    p("Buying or renting the house is an important decision. Ultimately it all boils down to numbers. In this analysis there are a lot of
      numbers and different possibilities."),
    p("This Shiny app been built to help you comprehend all different situations. This implementation differs
      from one in the video by assuming the property taxes are paid for the purchase price and not for the market price of the property.
      Also excluding 6% of selling commision."),
    HTML('<iframe width="700" height="350" src="https://www.youtube.com/embed/YL10H_EcB-E" frameborder="0" allowfullscreen></iframe>')
    
  )


))




