#install.packages("rsconnect")
library(rsconnect)

rsconnect::setAccountInfo(name='savmcnair',
                          token='8AE8F0B6F8B63C4343D4A4CB0CAEBB71',
                          secret='33qSqlMub2NL20SaEadxRPLaeOpT1J1rQIQF+rcc')

rsconnect::deployApp('C:/Users/smcnair1/Desktop/MWF_FINAL/dynamic_analysis')

