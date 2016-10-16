#' rent_or_buy function
#' Runs the simulation on whats better: renting or buying
#' @param price, price of the house
#' @param down, size of sample for picking the tickers
#' @param interest, size of sample for picking the tickers
#' @param loan_yrs, size of sample for picking the tickers
#' @param tax, size of sample for picking the tickers
#' @param maintain, size of sample for picking the tickers
#' @param hoa, size of sample for picking the tickers
#' @param insur, size of sample for picking the tickers
#' @param apprec, size of sample for picking the tickers
#' @param marg_tax, size of sample for picking the tickers
#' @param inflation, size of sample for picking the tickers
#' @param rent, size of sample for picking the tickers
#' @param rent_inflation, size of sample for picking the tickers
#' @param cash_return, size of sample for picking the tickers
#' @keywords arith
#' @export
#' @examples
#' rent_or_buy()
#' @import PortfolioAnalytics

rent_or_buy <- function ( 
  price = 750000,
down = price*0.2,
interest = 0.06,
loan_yrs = 30,
tax = 0.0125,
maintain = price*0.005,
hoa = 0,
insur = 800,
apprec = 0.03,
marg_tax = 0.3,
inflation = 0.02,
rent = 2500,
rent_inflation = 0.03,
cash_return = 0.12) {
    df1 <- data.frame(month=0:(loan_yrs*12), house_cost=NA, debt = NA, morgage = NA,
    interest_debt = NA, principal=NA, rent_inf=NA, buy_money=NA, rent_money=NA)
    df1[1,] <- c(0, price, price-down, 0, 0, 0, rent, 0, down )
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
    
    p <- ggplot2::ggplot(df1, ggplot2::aes_string(df1$month, df1$rent_money)) + ggplot2::geom_line()+ggplot2::geom_line(data = df1, ggplot2::aes_string(x = df1$month, y = df1$buy_money))
    p}



