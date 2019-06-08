set.seed(2)
x <- matrix(rnorm(50*2), ncol=2)
x[1:25,1] <- x[1:25,1]+3
x[1:25,2] <- x[1:25,2]-4

km.out = kmeans(x,2,nstart=20)
plot(x, col=(km.out$cluster +1), main="K-Means Clustering Results with K=2", xlab="", ylab="", pch=20, cex=2)

set.seed(4)
km.out=kmeans(x,3,nstart=20)
km.out
plot(x, col=km.out$cluster+1)

library(ISLR)
nci.labs <- NCI60$labs
nci.data <- NCI60$data
par(mfrow=c(1,3))

sd.data = scale(nci.data)
data.dist <- dist(sd.data)
plot(hclust(data.dist))
plot(hclust(data.dist), labels=nci.labs, main="Complete Linkage")


x <- matrix(rnorm(100), nrow=5)

timesfive(5)
