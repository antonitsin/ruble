
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
   
    price = input$price*1000
    down = input$down*1000
    interest = input$interest/100
    loan_yrs = as.numeric(input$loan_yrs)
    tax = input$tax/100
    maintain = input$maintain
    hoa = input$hoa
    insur = input$insur
    apprec = input$apprec/100
    marg_tax = input$marg_tax/100
    inflation = input$inflation/100
    rent = input$rent
    rent_inflation = input$rent_inflation/100
    cash_return = input$cash_return/100

    
        
    df1 <- data.frame(month=0:(loan_yrs*12), house_cost=NA, debt = NA, morgage = NA,
                      interest_debt = NA, principal=NA, rent_inf=NA, buy_money=NA, rent_money=NA)
    df1[1,] <- c(0, price, price-down, 0, 0, 0, rent, down, down )
    df1$morgage <- ((interest/12)*(price-down))/(1-(1+interest/12)^-(loan_yrs*12))
    for (i in 2:((loan_yrs*12)+1)) {
      df1$house_cost[i] <- df1$house_cost[i-1] * (1+apprec/12)
      df1$interest_debt[i] <- df1$debt[i-1] * interest/12
      df1$principal[i] <- df1$morgage[i] - df1$interest_debt[i]
      df1$debt[i] <- df1$debt[i-1] - df1$principal[i]
      df1$buy_money[i] <- df1$house_cost[i] - df1$debt[i] 
    }
 
    df1$insur <-insur/12
    df1$hoa <- hoa/12
    df1$maintain <- maintain/12
    df1$tax <- price*tax/12
    df1$savings <- (df1$interest_debt+df1$tax)*marg_tax
    df1$buy_cash <- df1$morgage + df1$insur + df1$hoa + df1$maintain + df1$tax - df1$savings
    
    for (i in 2:((loan_yrs*12)+1)) {
      df1$rent_inf[i] <- df1$rent_inf[i-1]*(1+rent_inflation/12)
      df1$rent_money[i] <- df1$rent_money[i-1]*(1+cash_return/12) + (df1$buy_cash[i]-df1$rent_inf[i])
    }
    
plot(df1$rent_money) 
lines(df1$buy_money, col="green")
ggplot2::ggplot(df1, ggplot2::aes_string(x=df1$month/12, y=df1$rent_money/1000 )) + ggplot2::geom_line(colour="red", size=1.5) +
  ggplot2::geom_line(data = df1, ggplot2::aes_string(x=df1$month/12, y=df1$buy_money/1000), colour="blue", size=1.5)+
  ggplot2::geom_vline(xintercept = seq(1, 30, by=5),colour="grey", linetype = "longdash")+
  ggplot2::ggtitle("Renting vs Buying Analysis") +
  ggplot2::labs(x="Year from purchase",y="Equity, $k") 
  })

})


