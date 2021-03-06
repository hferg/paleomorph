% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{countMissing}
\alias{countMissing}
\title{Count the number of missing landmarks in an array}
\usage{
countMissing(A)
}
\arguments{
\item{A}{An N x 3 x M array where N is the number of landmarks, 3 is the number of dimensions, and M is the number of specimens.}
}
\value{
A length n vector giving the number of missing landmarks for each specimen.
}
\description{
Count the number of missing landmarks in an array
}
\examples{



 A <- array(1:(3*6*7), dim = c(7, 3, 6))
 A[2, , 1] <- NA
 countMissing(A)
}

