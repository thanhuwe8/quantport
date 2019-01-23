PiCal <- function(delta=2.4, covmat, wm){
    #delta is scalar, 2.4 by default
    #comat: n.n
    #wm: n.1
    if(nrow(covmat)!=length(wm)){
        stop("length of wm should equal to rows/columns of covmat")
    }
    if(sum(wm[wm<0])!=0){
        stop("market portfolio weights should be positive")
    }
    Pi <- delta*covmat%*%wm
    return(Pi)
}
