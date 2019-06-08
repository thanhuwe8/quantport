# BacktestPort <- function(data, short, rf, freq, window, smoothing){
#     start_index <- window+1
#     end_index <- dim(data)[1]
#
# }
#
#
# end_index <- dim(dataset1)[1]
# start_index
# end_index
#
# window = 10
# start_index <- window+1
#
# backtest_retdata <- dataset1[start_index:end_index,]
# rownames(backtest_retdata) <- seq(1:loopcount)
# backtest_traindata <- dataset1[1:(end_index-window),]
# rownames(backtest_traindata) <- seq(1:loopcount)
#
# loopcount <- dim(backtest_retdata)[1]-window
#
# print(loopcount)
# weight_final <- NULL
# portfolio_final <- NULL
# track_cov <- list()
#
# for (i in 1:loopcount){
#     ret <- apply(backtest_traindata[i:(i+window-1),2:6], 2, mean)
#     covmat <- cov(backtest_traindata[i:(i+window-1),2:6])
#     print(i)
#
#     test_inverse <- tryCatch(
#         diag(chol(covmat)),
#         error = function(e) e
#     )
#     if(inherits(test_inverse, "error")==TRUE){
#         covmat <- track_cov[[i-1]]
#     }
#     track_cov[[i]] <- covmat
#
#     optim <- TangencyQP(ret, covmat,T,0,"monthly")
#     weight <- optim$weight
#     weight <- rbind(weight_final, weight)
#
#     performance <- weight*backtest_retdata[i,-1]
#     portfolio_final <- rbind(portfolio_final, performance)
#
# }
#
# portfolio_final
#
#
#
#
#
# ret <- apply(backtest_traindata[53:(53+window-1),2:6], 2, mean)
# covmat <- cov(backtest_traindata[53:(53+window-1),2:6])
# optim <- TangencyQP(ret, track_cov[[52]], T, 0, "monthly")
# optim
#
# backtest_traindata[53:(53+10-1),2:6]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
