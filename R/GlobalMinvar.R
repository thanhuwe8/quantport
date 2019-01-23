GlobalMinvar <- function(ret, covmat, short=TRUE, freq){
    # target is annualized number (for instance 7%=0.07)
    N <- length(ret)
    freq <- match.arg(freq, c("daily", "monthly", "quarterly"))

    # optimization is performed using frequency of ret and covmat (in example it's monthly)
    # Short-selling is not allowed
    if(short==FALSE){
        Dmat <- 2*covmat
        dvec <- rep(0,N)
        Amat <- cbind(rep(1,N), diag(1,N))
        bvec <- c(1, rep(0,N))
        opt_result <- quadprog::solve.QP(Dmat=Dmat,dvec=dvec,Amat=Amat,bvec=bvec,meq=1)
    # Short-selling is allowed
    } else if(short==TRUE){
        Dmat <- 2*covmat
        dvec <- rep(0,N)
        Amat <- cbind(rep(1,N))
        bvec <- c(1)
        opt_result <- quadprog::solve.QP(Dmat=Dmat,dvec=dvec,Amat=Amat,bvec=bvec,meq=1)
    } else {
        stop("Short argument should be TRUE or FALSE")
    }
    # Weight of global minimum variance
    gmvw <- round(opt_result$solution,4)

    portfoliosd <- ScaleSd(opt_result, freq)
    portfolioret <- t(ret)%*%gmvw
    portfolioret <- ScaleRet(portfolioret, freq)

    # return annualized value for portfolio return and portfolio sd
    result <- list(weight=gmvw, portfolioret=portfolioret, portfoliosd=portfoliosd)

}
