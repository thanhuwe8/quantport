
.objectfun <- function(x, ret, covmat, rf){
    return(-t(x)%*%(ret-rf)/sqrt(t(x)%*%covmat%*%x))
}

TangencySQ <- function(ret, covmat, short=TRUE, rf=0, freq, lb, ub){
    N <- length(ret)

    # Linear Inequality Constraint
    Amat <- diag(-1, N)
    bvec <- rep(0, N)

    # Linear Equality Constraint
    Aeq <- t(rep(1,N))
    Beq <- 1

    # lb and ub

}
