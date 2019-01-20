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
showEfficient <- function(ret, covmat, short,rf=0, freq, simpoints, assetpoints){
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

    tangency_optim <- TangencyQP(ret,covmat,short=short,rf=rf,freq)

    tangency_sd <- tangency_optim$portfoliosd
    tangency_ret <- tangency_optim$portfolioret

    minvar_sd <-min(sd_vec)
    minvar_ret <- asset_ret[which(minvar_sd==min(minvar_sd))]

    if (assetpoints==TRUE){
        plotfin <- ggplot(ret_and_sd, aes(x=portfoliosd, y=portfolioret))+geom_point()+
            scale_color_brewer(palette="Paired")+ggtitle("Efficient Frontier")+
            xlab("Annualized standard deviation")+
            ylab("Annualized mean return")+
            geom_point(aes(x=tangency_sd,y=tangency_ret), colour="red")+
            geom_point(aes(x=minvar_sd,y=minvar_ret), colour="green")
    } else if (assetpoints==FALSE){
        plotdataF <- ret_and_sd[-(1:noa),]
        plotfin <- ggplot(plotdataF, aes(x=portfoliosd,y=portfolioret))+ geom_point() +
            scale_color_brewer(palette="Paired")+ggtitle("Efficient Frontier")+
            xlab("Annualized standard deviation")+
            ylab("Annualized mean return")+
            geom_point(aes(x=tangency_sd,y=tangency_ret))+
            geom_point(aes(x=tangency_sd,y=tangency_ret), colour="red")+
            geom_point(aes(x=minvar_sd,y=minvar_ret), colour="green")

    } else {
        stop("assetpoints should be TRUE or FALSE")
    }
    plot(plotfin)
    return(ret_and_sd)
}
