BLcanon <- function(ret,covmat,P,Q,Pi,tau){
    # He and Litterman method to calculate Omega - Proportionality to the
    # the variance of the prior

    Omega <- diag(P%*%(tau*covmat)%*%t(P))
    Omega <- diag(Omega,nrow(P))

    C <- solve(tau*covmat)%*%Pi + t(P)%*%solve(Omega)%*%Q
    H <- solve(tau*covmat)+t(P)%*%solve(Omega)%*%P
    A <- t(Q)%*%solve(Omega)%*%Q + t(Pi)%*%solve(tau*covmat)%*%Pi

    ER <- solve(H)%*%C
    var_PER <- solve(H)
    var_R <- covmat + var_PER
    return(list(BLmean=ER,BLvar=var_R))
}

