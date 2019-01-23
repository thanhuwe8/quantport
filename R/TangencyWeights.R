
#' Calculate Tangency Portfolio Weight based on Quadratic Programming
#' @author Thanh Nguyen Minh
#'
#' @description
#' Compute the tangency portfolio weight which maximizes sharpe ratio based on Quadratic Programming Algorithm.
#' Short sale constraint could be used. Lower and upper bound for each asset could not be implemented by this
#' function. Please refer to `TangencySQ` to implement lower and upper boundary for weight.
#'
#' @param ret a vector stores mean return of assets (\samp{N x 1}). A vector should store daily, monthly
#' or quarterly return.
#' @param covmat a matrix stores covariance matrix of asset returns. A matrix should be scaled by daily, monthly
#' or quarterly return alligned with `ret` vector.
#' @param short a boolean stores TRUE for short sale constraint or FALSE for no constraint
#' @param rf a scalar store annualized risk free rate
#' @param freq a string stores frequency used by ret and covmat. It should be "daily", "monthly" or "quarterly"
#'
#' @return Return a list with the following slots
#' \item{TangencyWeight}{A vector of asset weights}
#' \item{portfolioret}{A scalar of tangency portfolio return (annualized)}
#' \item{portfoliosd}{A scalar of tangency portfolio standard deviation (annualized)}
#' \item{sharpeRatio}{A scalar of sharpe ratio of tangency portfolio (annualized)}
#' @export
#'
#' @examples
#' data(dataset1)
#' mean_return <- apply(dataset1[,-1], MARGIN=2, mean)
#' cov_matrix <- cov(dataset1[,-1])
#' result <- TangencyQP(mean_return, cov_matrix, short=TRUE, rf=0.07, freq="monthly")
TangencyQP <- function(ret, covmat, short=TRUE, rf=0, freq){

    freq <- match.arg(freq, c("daily", "monthly", "quarterly"))

    N <- length(ret)

    if (N != nrow(covmat)) {
        stop("return vector should have the same number of rows as covariance matrix")
    }
    if (any(diag(chol(covmat))<0)){
        stop("covariance matrix should be positive semi-definite")
    }
    if (rf<0){
        stop("Risk free should be minumum at 0")
    }
    switch(freq,
           daily = {
               rff = rf/252
               excessret = ret-rff
           },
           monthly = {
               rff = rf/12
               excessret = ret-rff
           },
           quarterly = {
               rff = rf/4
               excessret = ret-rf
           })
    # Short-selling is not allowed.
    if(short==FALSE){
        N <- length(excessret)
        Dmat <- 2*covmat
        dvec <- rep.int(0,N)
        Amat <- cbind(excessret, diag(1,N))
        bvec <- c(1,rep(0,N))
        weight <- quadprog::solve.QP(Dmat=Dmat,dvec=dvec,Amat=Amat,bvec=bvec,meq=1)

        tangencyWeight <- round(weight$solution/sum(weight$solution),4)
        portfolioret <- t(tangencyWeight)%*%ret
        portfoliosd <- sqrt(t(tangencyWeight)%*%covmat%*%tangencyWeight)
        sharpeRatio <- (portfolioret-rf)/portfoliosd

    } else if(short==TRUE){
        # Analytical Solution
        covmat_inverse <- solve(covmat)
        ones <- rep(1,N)
        ret_minus_rfones <- ret-rff*ones
        numer <- covmat_inverse%*%ret_minus_rfones
        denom <- as.numeric(t(ones)%*%numer)

        tangencyWeight <- numer[,1]/denom
        portfolioret <- t(tangencyWeight)%*%ret
        portfoliosd <- sqrt(t(tangencyWeight)%*%covmat%*%tangencyWeight)
        sharpeRatio <- (portfolioret-rff)/portfoliosd
    } else {
        stop("Short should be TRUE or FALSE")
    }
    # switch to scale return and standard deviation

    stats_final <- ScaleRetSD(portfolioret, portfoliosd, freq)

    # SharpeRatio Calculation
    sharpeRatio <- as.numeric((portfolioret-rf)/portfoliosd)

    result <-  list(weight=tangencyWeight, portfolioret=stats_final$portfolioret,
                    portfoliosd=stats_final$portfoliosd, SharpeRatio=sharpeRatio)
}
