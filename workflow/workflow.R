library(available)
library(usethis)
library(roxygen2)
use_github(protocol = "https", auth_token = "626f98f7c5aea3e802dd3f751c92b2c0476a5d61")

use_package_doc()
use_package("quadprog", type="Imports")
use_vignette("quantport_vignette")
use_readme_rmd()

dataset1 <- read.csv("/Users/thanhuwe8/Projects/R project/MVA_BL/dataset1.csv")
dataset1 <- dataset1[,-1]


data(dataset1)
mean_vec <- apply(dataset1[,-1], 2,mean)
cov_mat <- cov(dataset1[,-1])


aaa <- TangencyQP(mean_vec, cov_mat, short=F, rf=0, "monthly")
bbb <- EqualWeight(mean_vec, cov_mat, "monthly")
ccc <- InverseVola(mean_vec, cov_mat, "monthly")
ddd <- GlobalMinvar(mean_vec, cov_mat, T, "monthly")
eee <- GlobalMinvar(mean_vec, cov_mat, F, "monthly")
fff <- eee$weight
ggg <- ddd$weight
hhh <- cbind(fff,ggg)


ret <- mean_vec[1:4]
covmat <- cov_mat[1:4,1:4]
mw2 <- c(0.1,0.4,0.1,0.4)
PI2 <- PiCal(2.4,cm2,mw2)
Pi <- PI2

P <- matrix(c(1,0,0,-1,0,1,0,0), ncol=4, byrow = T)
P
Q <- c(0.01, 0.03)

BL <- BLcanon(mv2,cm2,P,Q,PI2,0.5)
BL
Omega <- P%*%(tau*covmat)%*%t(P)

