
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quantport

The package `quantport` provides routines to perform portfolio
optimization based on quadratic and sequential programming. With Sharpe
Ratio maximization problem (tangency portfolio), the lower boundary and
upper boundary for any single asset, as well as other constraints could
be implemented using Sequential Programming.

The main advantage of this package is easy-to-use and simplicity. The
package is based purely on functional programming. You do not need to
create object like S3 or S4 to run portfolio optimization. The result
from optimization will be stored in dataframe or list only. The mean
vector and the covariance matrix could be used from daily, monthly or
quarterly data. The package could be used in complement with your master
studies in portfolio optimization or courses such as CFA, FRM, etc.

# Plan for development

In the near future, we will add further functionalities including
Differential Evolutionary Optimization (DE) and Canonical
Black-Litterman model.

## Installation

There are several packages required: `quadprog`, `DEoptim`, `NlcOptim`,
`ggplot2` and `tidyverse`. We plan to submit this package to
[CRAN](https://CRAN.R-project.org) in the near future. At the mean time,
the package could be downloaded via github using `devtools`:

``` r
devtools::install_github("thanhuwe8/quantport")
```

## Example

This is a basic example which shows you how to solve the portfolio
optimization problem. We have the data in the form of data.frame with 10
assets monthly return as below:

``` r
data(dataset1)
kable(head(dataset1,3))
```

| Date       |         FPT |         GAS |         GMD |         VCB |       VNM |       REE |         MSN |         VIC |         HPG |         SSI |
| :--------- | ----------: | ----------: | ----------: | ----------: | --------: | --------: | ----------: | ----------: | ----------: | ----------: |
| 2013-02-28 | \-0.0771388 |   0.0292289 |   0.1640979 | \-0.0149015 | 0.0198857 | 0.0117005 | \-0.0587924 |   0.0077519 | \-0.0280561 | \-0.0270979 |
| 2013-03-29 |   0.0212766 |   0.1631420 |   0.3123053 | \-0.0091842 | 0.1262491 | 0.0053971 |   0.1071028 | \-0.0524038 |   0.0742268 | \-0.0332435 |
| 2013-04-26 | \-0.0156250 | \-0.0093506 | \-0.2403561 | \-0.1434024 | 0.0688163 | 0.0107362 | \-0.1209585 | \-0.0233384 |   0.0575816 | \-0.0223048 |

Then we calculate 2 required inputs for portfolio optimization as
follows:

``` r
data_test <- dataset1[,-1]
mean_vec <- apply(data_test, MARGIN=2, mean)
cov_mat <- cov(data_test)
kable(mean_vec)
```

|     |         x |
| --- | --------: |
| FPT | 0.0175349 |
| GAS | 0.0205154 |
| GMD | 0.0171414 |
| VCB | 0.0184696 |
| VNM | 0.0184208 |
| REE | 0.0157175 |
| MSN | 0.0040312 |
| VIC | 0.0257915 |
| HPG | 0.0292043 |
| SSI | 0.0160022 |

``` r
kable(cov_mat)
```

|     |       FPT |       GAS |       GMD |       VCB |       VNM |       REE |       MSN |       VIC |       HPG |       SSI |
| --- | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: |
| FPT | 0.0042614 | 0.0033102 | 0.0021415 | 0.0024455 | 0.0020232 | 0.0034155 | 0.0022578 | 0.0020202 | 0.0027855 | 0.0034875 |
| GAS | 0.0033102 | 0.0116427 | 0.0025431 | 0.0035473 | 0.0022243 | 0.0027905 | 0.0044717 | 0.0024626 | 0.0048307 | 0.0032298 |
| GMD | 0.0021415 | 0.0025431 | 0.0088099 | 0.0026539 | 0.0018935 | 0.0031162 | 0.0026985 | 0.0011345 | 0.0024260 | 0.0020834 |
| VCB | 0.0024455 | 0.0035473 | 0.0026539 | 0.0069645 | 0.0019444 | 0.0026043 | 0.0032404 | 0.0028170 | 0.0029619 | 0.0032546 |
| VNM | 0.0020232 | 0.0022243 | 0.0018935 | 0.0019444 | 0.0054617 | 0.0020543 | 0.0018221 | 0.0011131 | 0.0017396 | 0.0018961 |
| REE | 0.0034155 | 0.0027905 | 0.0031162 | 0.0026043 | 0.0020543 | 0.0064170 | 0.0020180 | 0.0018594 | 0.0027920 | 0.0038513 |
| MSN | 0.0022578 | 0.0044717 | 0.0026985 | 0.0032404 | 0.0018221 | 0.0020180 | 0.0072603 | 0.0022859 | 0.0030890 | 0.0029749 |
| VIC | 0.0020202 | 0.0024626 | 0.0011345 | 0.0028170 | 0.0011131 | 0.0018594 | 0.0022859 | 0.0064643 | 0.0009622 | 0.0017002 |
| HPG | 0.0027855 | 0.0048307 | 0.0024260 | 0.0029619 | 0.0017396 | 0.0027920 | 0.0030890 | 0.0009622 | 0.0076791 | 0.0034633 |
| SSI | 0.0034875 | 0.0032298 | 0.0020834 | 0.0032546 | 0.0018961 | 0.0038513 | 0.0029749 | 0.0017002 | 0.0034633 | 0.0071576 |

Then we provide necessary inputs to the `TangencyQP` to find the weight
of optimal portfolio with maximum Sharpe
Ratio.

``` r
tangency_result <- quantport::TangencyQP(ret=mean_vec,covmat=cov_mat,short=T,rf=0,freq="monthly") 
optimal_weight <- data.frame(tangency_result$weight)
```

<img src="man/figures/README-barplot-1.png" width="100%" />

Portfolio return and standard deviation are also stored and accessed
using `$` operator

``` r
print(tangency_result$portfolioret)
#>           [,1]
#> [1,] 0.4095923
print(tangency_result$portfoliosd)
#>           [,1]
#> [1,] 0.2320305
print(tangency_result$SharpeRatio)
#>          [,1]
#> [1,] 1.765252
```

There are other useful functions you could find in the vignettes of this
package. Below is the efficient frontier with short-sale constraints.
The dots to the right of the curve is single asset risk-return trade-off
point. The red dot is tangency portfolio and the green dot is minimum
variance portfolio. Mean return and standard deviation are both
annualized assuming 252 trading
days.

``` r
ef <- quantport::showEfficient(ret=mean_vec,covmat=cov_mat,short=F,rf=0.05,freq="monthly",simpoints=200,assetpoints=T) 
```

<img src="man/figures/README-efficient-1.png" width="100%" />

The weight of all popular porfolio could be calculated using
`UltimateWeight` function as
below:

``` r
final_result <- UltimateWeight(ret=mean_vec,covmat=cov_mat, short=T,target=0.08,rf=0,freq="monthly")
kable(round(final_result[[1]],4))
```

|     | Tangency | MinimumVariance | InverseVolatility | EqualWeight |
| --- | -------: | --------------: | ----------------: | ----------: |
| FPT |   0.0579 |          0.3244 |            0.1889 |         0.1 |
| GAS | \-0.0108 |        \-0.0878 |            0.0522 |         0.1 |
| GMD |   0.1416 |          0.0619 |            0.0682 |         0.1 |
| VCB | \-0.0043 |          0.0394 |            0.1047 |         0.1 |
| VNM |   0.2847 |          0.2229 |            0.1233 |         0.1 |
| REE | \-0.1223 |          0.1614 |            0.1092 |         0.1 |
| MSN | \-0.4251 |          0.5370 |            0.0899 |         0.1 |
| VIC |   0.5419 |        \-0.0526 |            0.0911 |         0.1 |
| HPG |   0.5168 |        \-0.2389 |            0.0783 |         0.1 |
| SSI |   0.0195 |          0.0323 |            0.0942 |         0.1 |

``` r
kable(final_result[[2]])
```

| WeightType        |        SD |    Return | SharpeRatio |
| :---------------- | --------: | --------: | ----------: |
| Tangency          | 0.2320305 | 0.4095923 |   1.7652517 |
| MinimumVariance   | 0.2241153 | 0.0800000 |   0.3569591 |
| InverseVolatility | 0.1872915 | 0.2157626 |   1.1520146 |
| EqualWeight       | 0.1913088 | 0.2193945 |   1.1468080 |
