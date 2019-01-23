#' Title
#'
#' @param ret
#' @param covmat
#' @param short
#' @param rf
#' @param freq
#'
#' @return
#' @export
#'
#' @examples
UltimateWeight <- function(ret,covmat,short,rf=0,freq){

    weight_type <- c("Tangency", "MinimumVariance",
                     "InverseVolatility","EqualWeight")

    # Tangency portfolio
    tangency_optim <- TangencyQP(ret=ret,covmat=covmat,short=short,rf=rf,freq)
    tangency_weight <- tangency_optim$weight
    tangency_sd <- tangency_optim$portfoliosd
    tangency_ret <- tangency_optim$portfolioret

    # Minimum Variance Portfolio
    minvar_optim <- GlobalMinvar(ret=ret, covmat=covmat, short=short, freq=freq)
    minvar_weight <- minvar_optim$weight
    minvar_sd <- minvar_optim$portfoliosd
    minvar_ret <- minvar_optim$portfolioret

    # Inverse Volatility Portfolio
    inverse_optim <- InverseVola(ret=ret, covmat=covmat, freq=freq)
    inverse_weight <- inverse_optim$weight
    inverse_sd <- inverse_optim$portfoliosd
    inverse_ret <- inverse_optim$portfolioret

    # Equal Weight Portfolio
    equalweight_optim <- EqualWeight(ret=ret,covmat=covmat,freq=freq)
    equalweight_weight <- equalweight_optim$weight
    equalweight_sd <- equalweight_optim$portfoliosd
    equalweight_ret <- equalweight_optim$portfolioret

    # Arrange Stats data
    weight_type <- c("Tangency", "MinimumVariance", "InverseVolatility", "EqualWeight")
    SD_type <- c(tangency_sd, minvar_sd, inverse_sd, equalweight_sd)
    Ret_type <- c(tangency_ret, minvar_ret, inverse_ret, equalweight_ret)
    sharpe_ratio <- (Ret_type-rf)/SD_type

    final_weight <- NULL
    final_weight <- data.frame(cbind(final_weight, tangency_weight,
                                     minvar_weight, inverse_weight, equalweight_weight))
    colnames(final_weight) <- weight_type

    # Diversification measure
    WE <- apply(final_weight,2,WeightEntropy)
    HR <- apply(final_weight,2,Herfindahl)
    DR <- apply(final_weight,2,DiversificationRatio,covmat=covmat)

    metrics <-data.frame(WeightType=weight_type, SD=SD_type, Return=Ret_type,
                         SharpeRatio=sharpe_ratio, WeightEntropy=WE,
                         Herfindahl=HR,DiversificationRatio=DR)

    return(list(final_weight, metrics))

}
