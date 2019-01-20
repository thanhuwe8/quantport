#' Calculate assets weights for minimum variance portfolio given target return
#' @author Thanh Nguyen Minh
#'
#' @description
#' Compute the minumum variance portfolio given target return based on Quadratic Programming.
#' Short sale constraint could be used. Lower and upper bound could not be implemented by this function
#' @param ret a vector stores mean return of assets (\samp{N x 1}). A vector should store daily, monthly
#' or quarterly return.
#' @param covmat a matrix stores covariance matrix of asset returns. A matrix should be scaled by daily, monthly
#' or quarterly return alligned with `ret` vector.
#' @param target
#' @param short a boolean stores TRUE for short sale constraint or FALSE for no constraint
#' @param rf a scalar store annualized risk free rate
#' @param freq
#'
#' @return
#' @export
#'
#' @examples
MinvarWeight <- function(ret, covmat, target, short=TRUE, freq){
    # target is annualized number (for instance 7%=0.07)
    N <- length(ret)
    freq <- match.arg(freq, c("daily", "monthly", "quarterly"))
    # target are transformed into frequency data
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
    if (target_scale < min(ret) || target_scale > max(ret)){
        stop("Target should be limited to min and max of the return vector")
    }
    if (N != nrow(covmat)) {
        stop("return vector should have the same number of rows as covariance matrix")
    }
    if (any(diag(chol(covmat))<0)){
        stop("covariance matrix should be positive semi-definite")
    }

    # optimization is performed using frequency of ret and covmat (in example it's monthly)
    if(short==FALSE){
        Dmat <- 2*covmat
        dvec <- rep(0,N)
        Amat <- cbind(rep(1,N), ret, diag(1,N))
        bvec <- c(1, target_scale, rep(0,N))
        opt_result <- quadprog::solve.QP(Dmat=Dmat,dvec=dvec,Amat=Amat,bvec=bvec,meq=2)
    } else if(short==TRUE){
        Dmat <- 2*covmat
        dvec <- rep(0,N)
        Amat <- cbind(rep(1,N), ret)
        bvec <- c(1,target_scale)
        opt_result <- quadprog::solve.QP(Dmat=Dmat,dvec=dvec,Amat=Amat,bvec=bvec,meq=2)
    } else {
        stop("Short argument should be TRUE or FALSE")
    }
    effw <- round(opt_result$solution,4)
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
    # return annualized value for portfolio return and portfolio sd
    result <- list(weight=effw, portfolioret=target, portfoliosd=portfoliosd)

}
