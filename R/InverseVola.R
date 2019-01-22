#' Title
#'
#' @param ret
#' @param covmat
#' @param freq
#'
#' @return
#' @export
#'
#' @examples
InverseVola <- function(ret, covmat, freq){
    # target is annualized number (for instance 7%=0.07)
    N <- length(ret)
    freq <- match.arg(freq, c("daily", "monthly", "quarterly"))
    # target are transformed into frequency data
    if (N != nrow(covmat)) {
        stop("return vector should have the same number of rows as covariance matrix")
    }
    if (any(diag(chol(covmat))<0)){
        stop("covariance matrix should be positive semi-definite")
    }

    asset_sd <- sqrt(diag(cov(covmat)))
    inverse_sd <- 1/asset_sd
    ivw <- inverse_sd/sum(inverse_sd)

    portfolio_sd <- t(ivw)%*%covmat%*%ivw
    portfolio_ret <- (t(ivw)%*%ret)

    portfoliosd <- portfolio_sd[1,1]
    portfolioret <- portfolio_ret[1,1]

    switch(freq,
           daily={
               portfoliosd <- sqrt(portfoliosd*252)
               portfolioret <- portfolioret*252
           },
           monthly={
               portfoliosd <- sqrt(portfoliosd*12)
               portfolioret <- portfolioret*12
           },
           quarterly={
               portfoliosd <- sqrt(portfoliosd*4)
               portfolioret <- portfolioret*4
           })
    # return annualized value for portfolio return and portfolio sd
    result <- list(weight=ivw, portfolioret=portfolioret, portfoliosd=portfoliosd)

}

