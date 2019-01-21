library(NlcOptim)

# Draft of Black-Litterman model

# Part 0: Necessary Function
# vector P (Nx1 matrix, need to be transposed later)
mmtum <- function(data){
    temp <- apply((1+data),2,prod)
    temp[temp>median(temp)] <- 1
    temp[temp<median(temp)] <- -1
    print(sum(temp))
    print("tested momentum vector")
    return(temp)
}

# vector Q
expQ <- function(data, n){
    a <- mmtum(data)
    ret <- apply((1+data), 2, prod)
    exprt <- sum(a*(ret-1))/n
    return(exprt)
}

# reverse optimization
revOp <- function(data, n, rf){
    mean <- mean(data)*n
    std <- sd(data)*sqrt(n)
    value <- (mean-rf)/(std^2)
    if (value <=1){
        print(value)
        print('Value < 1, take 2.4 as suggested by Black-Litterman')
        return(2.4)
    }
    if (value > 1){
        print(value)
        print('OK')
        return(value)
    }
}

# Pi calculation
bpi <- function(lambda, data, dataw){
    cov.mat <- cov(data)
    value <- (lambda*cov.mat)%*%t(dataw)
    return(value)
}

# Omega Calculation
omegaCal <- function(data){
    P <- t(as.matrix(mmtum(data)))
    cov.mat <- cov(data)
    omega <- P%*%(0.1*cov.mat)%*%t(P)
    print(omega)
    return(omega)
}



blw <- function(tau, cov.mat, P, omega, pi, Q){
    bl.er <- solve(solve(tau*cov.mat)+t(P)%*%(solve(omega))%*%P)%*%
        (solve(tau*cov.mat)%*%pi + t(P)%*%(solve(omega)%*%Q))
    return(bl.er)
}


# Wrapper for momentum black-litterman expected return (no short-selling)
blklitm <- function(data, dataw, datai, period, nassets, tau, rf){
    tau = tau
    cov.mat <- cov(data)
    P <- t(mmtum(data))
    omega <- omegaCal(data)
    lambda <- revOp(datai, period, rf)
    pi <- bpi(lambda, data, dataw[nrow(dataw),])
    Q <- expQ(data,nassets)
    result <- blw(tau, cov.mat, P, omega, pi, Q)
    return(result)
}
