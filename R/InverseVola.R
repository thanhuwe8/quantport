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

    portfolio_sd <- sqrt(t(ivw)%*%covmat%*%ivw)
    portfolio_ret <- (t(ivw)%*%ret)

    portfoliosd <- portfolio_sd
    portfolioret <- portfolio_ret

    # Utility function
    stats_final <- ScaleRetSD(portfolioret, portfoliosd, freq)

    # return annualized value for portfolio return and portfolio sd
    result <- list(weight=ivw, portfolioret=stats_final$portfolioret,
                   portfoliosd=stats_final$portfoliosd)

}

