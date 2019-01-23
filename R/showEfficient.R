#' PlotEfficient Frontier
#'
#' @param ret
#' @param covmat
#' @param short
#' @param freq
#' @param simpoints
#' @param assetpoints
#'
#' @return
#' @export
#'
#' @examples
ShowEfficient <- function(ret, covmat, short,rf=0, freq, simpoints, assetpoints){
    switch (freq,
            daily = {
                ret_range <- seq(min(ret)*252+0.0001,max(ret)*252-0.0001, length.out=simpoints)
                asset_ret <- ret*252
                sd_vec <- sqrt(diag(covmat)*252)
            },
            monthly = {
                ret_range <- seq(min(ret)*12+0.0001, max(ret)*12-0.0001, length.out=simpoints)
                asset_ret <- ret*12
                sd_vec <- sqrt(diag(covmat)*12)
            },
            quarterly = {
                ret_range <- seq(min(ret)*4+0.0001, max(ret)*4-0.0001, length.out=simpoints)
                asset_ret <- ret*4
                sd_vec <- sqrt(diag(covmat)*4)
            }
    )
    #sd_vec <- NULL

    for (i in ret_range){
        optim_result <- MinvarWeight(ret, covmat, i, short=short, freq)
        optim_sd <- optim_result$portfoliosd
        sd_vec <- append(sd_vec, optim_sd)
        asset_ret <- append(asset_ret, i)
    }

    noa <- length(ret)
    #plot(x=sd_vec, y=asset_ret)
    ret_and_sd <- data.frame(portfoliosd=sd_vec, portfolioret=asset_ret)



    # Tangency portfolio
    tangency_optim <- TangencyQP(ret=ret,covmat=covmat,short=short,rf=rf,freq)
    tangency_sd <- tangency_optim$portfoliosd
    tangency_ret <- tangency_optim$portfolioret

    # Minimum Variance Portfolio
    minvar_optim <- GlobalMinvar(ret=ret,covmat=covmat,short=short,freq=freq)
    minvar_sd <-minvar_optim$portfoliosd
    minvar_ret <- minvar_optim$portfolioret

    # Inverse Volatility Portfolio
    inverse_optim <- InverseVola(ret=ret, covmat=covmat, freq=freq)
    inverse_sd <- inverse_optim$portfoliosd
    inverse_ret <- inverse_optim$portfolioret

    # Equal Weight Portfolio
    equalweight_optim <- EqualWeight(ret=ret,covmat=covmat,freq=freq)
    equalweight_sd <- equalweight_optim$portfoliosd
    equalweight_ret <- equalweight_optim$portfolioret



    if (assetpoints==TRUE){
        plotfin <- ggplot(ret_and_sd, aes(x=portfoliosd, y=portfolioret))+geom_point(alpha=1/5)+
            scale_color_brewer(palette="Paired")+ggtitle("Efficient Frontier")+
            xlab("Annualized standard deviation")+
            ylab("Annualized mean return")+
            geom_point(aes(x=tangency_sd,y=tangency_ret), colour="#DE892C", size=4)+
            annotate("text",x=tangency_sd,y=tangency_ret+0.02, label="tangency")+
            geom_point(aes(x=minvar_sd,y=minvar_ret), colour="#44426A", size=3) +
            annotate("text",x=minvar_sd-0.01,y=minvar_ret, label="MV")+
            geom_point(aes(x=inverse_sd,y=inverse_ret), colour="#1B7369",size=3)+
            annotate("text",x=inverse_sd+0.01,y=inverse_ret+0.02, label="IV")+
            geom_point(aes(x=equalweight_sd,y=equalweight_ret), colour="#266ECD",size=3)+
            annotate("text",x=equalweight_sd+0.01,y=equalweight_ret-0.02, label="EQW")+
            theme(legend.position="top")
    } else if (assetpoints==FALSE){
        plotdataF <- ret_and_sd[-(1:noa),]
        plotfin <- ggplot(plotdataF, aes(x=portfoliosd,y=portfolioret))+ geom_point() +
            scale_color_brewer(palette="Paired")+ggtitle("Efficient Frontier")+
            xlab("Annualized standard deviation")+
            ylab("Annualized mean return")+
            geom_point(aes(x=tangency_sd,y=tangency_ret), colour="#DE892C")+
            annotate("text",x=tangency_sd,y=tangency_ret+0.02, label="tangency")+
            geom_point(aes(x=minvar_sd,y=minvar_ret), colour="#44426A", show.legend = T) +
            annotate("text",x=minvar_sd-0.01,y=minvar_ret, label="MV")+
            geom_point(aes(x=inverse_sd,y=inverse_ret), colour="#1B7369", show.legend = T) +
            annotate("text",x=inverse_sd-0.01,y=inverse_ret, label="MV")

    } else {
        stop("assetpoints should be TRUE or FALSE")
    }
    plot(plotfin)
    return(ret_and_sd)
}


