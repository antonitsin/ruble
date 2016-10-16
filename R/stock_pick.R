#' The stock_pick function
#' Constructs the optimal portofolio once the stock tickers are provided or designs one based on sample of tickers.
#' @param stocks, stock tickers for portofolio, can be null
#' @param stocks_lim, size of sample for picking the tickers
#' @param freq, size of sample for picking the tickers
#' @param start, size of sample for picking the tickers
#' @param min_pos, size of sample for picking the tickers
#' @keywords arith
#' @export
#' @examples
#' stock_pick()
#'

stock_pick <- function(stocks=NULL, stocks_lim=15, freq="week", start = "2010-01-01", min_pos=4) {
start1 <- as.Date(start)
min_pos <- min_pos
if (length(stocks)==0) {
stocks_1 <- as.character(TTR::stockSymbols()[,1])
n_stocks <- length(stocks_1)
stocks <- stocks_1[sample(1:n_stocks, stocks_lim)]
stockexist <- function(stocks) {
  d <- list()
  n <- length(stocks)
  t1 <- numeric(n)
  t2 <- data.frame(link=numeric(), error=numeric(), date=numeric())
  d1 <- list()
  t3 <- data.frame(link=numeric(), date=numeric())
  t4 <- data.frame(link=numeric(), date=numeric()) 
  start2 <- start1
  for (i in 1:n) {
    tryCatch({
      d[[i]] <- list(read.delim(sprintf("http://ichart.finance.yahoo.com/table.csv?s=%s&a=0&b=1&c=1970&g=w&ignore=.csv", stocks[i]), TRUE, sep = ","))},
      error=function(e) {t1[i] <<- 1},
      warning=function(e) {t1[i] <<- 1})
    t2[i,1] <- stocks[i]
    t2[i,2] <- t1[i]
  }
  stocks2 <- t2[t2$error!=1,]$link
  n1 <- length(stocks2)
  
  for (i in 1:n1) {
  d1[[i]] <- list(read.delim(sprintf("http://ichart.finance.yahoo.com/table.csv?s=%s&a=0&b=1&c=1970&g=w&ignore=.csv", stocks2[i]), TRUE, sep = ","))
  t3[i,1] <- stocks2[i]
  t3[i,2] <- min(as.Date(d1[[i]][[1]]$Date, origin = "1900-01-01"))
  }
  
  t3$date <- as.Date(t3$date, origin = "1900-01-01")
  t3[t3$date < start2, ]$link}


stocks3 <- stockexist(stocks)
tickers <- stocks3}
else tickers <- stocks
returns <- stockPortfolio::getReturns(tickers, freq="week", start = start1, get = "overlapOnly" )
returns2 <- xts::as.xts(returns$R)
fund.names <- colnames(returns2)
pspec <- PortfolioAnalytics::portfolio.spec(assets=fund.names)
pspec <- PortfolioAnalytics::add.constraint(portfolio=pspec, type="full_investment")
pspec <- PortfolioAnalytics::add.constraint(portfolio=pspec,
                          type="box",
                          min=0.01,
                          max=0.8)
pspec <- PortfolioAnalytics::add.constraint(portfolio=pspec, type="position_limit", max_pos=min(7, length(fund.names)))
pspec <- PortfolioAnalytics::add.constraint(portfolio=pspec, type="position_limit", min_pos=min(min_pos, length(fund.names)))
pspec <- PortfolioAnalytics::add.objective(portfolio=pspec, type="return", name="mean")


set.portfolio.moments<-PortfolioAnalytics::set.portfolio.moments
opt_maxret <- PortfolioAnalytics::optimize.portfolio(R=returns2, portfolio=pspec,
                                 optimize_method="random", search_size=200,
                                 trace=TRUE)
opt_maxret
}
