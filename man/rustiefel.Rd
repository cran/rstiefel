% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rustiefel.R
\name{rustiefel}
\alias{rustiefel}
\title{Siumlate a Uniformly Distributed Random Orthonormal Matrix}
\usage{
rustiefel(m, R)
}
\arguments{
\item{m}{the length of each column vector.}

\item{R}{the number of column vectors.}
}
\value{
an \code{m*R} orthonormal matrix.
}
\description{
Siumlate a random orthonormal matrix from the uniform distribution on the
Stiefel manifold.
}
\examples{

## The function is currently defined as
function (m, R) 
{
    X <- matrix(rnorm(m * R), m, R)
    tmp <- eigen(t(X) \%*\% X)
    X \%*\% (tmp$vec \%*\% sqrt(diag(1/tmp$val, nrow = R)) \%*\% t(tmp$vec))
  }

}
\references{
Hoff(2007)
}
\author{
Peter Hoff
}
