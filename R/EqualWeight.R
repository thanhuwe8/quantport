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
EqualWeight <- function(ret, covmat, freq){
    N <- length(ret)
    freq <- match.arg(freq, c("daily", "monthly", "quarterly"))

    # target are transformed into frequency data
    if (N != nrow(covmat)) {
        stop("return vector should have the same number of rows as covariance matrix")
    }
    if (any(diag(chol(covmat))<0)){
        stop("covariance matrix should be positive semi-definite")
    }

    # Calculate Equal Weight first
    eqw <- rep(1/N,N)

    portfolio_sd <- sqrt(t(eqw)%*%covmat%*%eqw)
    portfolio_ret <- (t(eqw)%*%ret)

    portfoliosd <- portfolio_sd
    portfolioret <- portfolio_ret

    stats_final <- ScaleRetSD(portfolioret, portfoliosd, freq)

    # return annualized value for portfolio return and portfolio sd
    result <- list(weight=eqw, portfolioret=stats_final$portfolioret,
                   portfoliosd=stats_final$portfoliosd)

}

