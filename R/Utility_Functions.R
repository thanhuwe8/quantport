ScaleTarget <- function(target, freq){
    switch (freq,
            daily = {
                target_scale <- target/252
            },
            monthly = {
                target_scale <- target/12
            },
            quarterly = {
                target_scale <- target/4
            }
    )
    return(target_scale)
}

ScaleSd <- function(opt_result, freq){
    switch(freq,
           daily={
               portfoliosd <- sqrt(opt_result$value*252)
           },
           monthly={
               portfoliosd <- sqrt(opt_result$value*12)
           },
           quarterly={
               portfoliosd <- sqrt(opt_result$value*4)
           })
    return(portfoliosd)
}

ScaleRet <- function(portfolioret, freq){
    switch(freq,
           daily = {
               portfolioret <- portfolioret*252
           },
           monthly = {
               portfolioret <- portfolioret*12
           },
           quarterly = {
               portfolioret <- portfolioret*4
           }
    )
    return(portfolioret)
}

ScaleRetSD <- function(portfolioret, portfoliosd, freq){
    switch(freq,
           daily = {
               portfolioret <- portfolioret*252
               portfoliosd <- portfoliosd*sqrt(252)
           },
           monthly = {
               portfolioret <- portfolioret*12
               portfoliosd <- portfoliosd*sqrt(12)
           },
           quarterly = {
               portfolioret <- portfolioret*4
               portfoliosd <- portfoliosd*sqrt(4)
           }
           )
    return(data.frame(portfolioret=portfolioret, portfoliosd=portfoliosd))
}

WeightEntropy <- function(weight){
    # we define x * log(x) = 0 in the case x=0
    lv <- log(weight)
    lv[lv==-Inf] <- 0
    return(-sum(weight*lv))
}

Herfindahl <- function(weight){
    return(1-sum(weight^2))
}

DiversificationRatio <- function(weight,covmat){
    numerator <- sum(sqrt(diag(covmat))*weight)
    denominator <- sqrt(t(weight)%*%covmat%*%weight)
    return(as.numeric(numerator/denominator))
}



