#' Simulate a \code{p*p} Orthogonal Random Matrix
#' 
#' Simulate a \code{p*p} random orthogonal matrix from the Bingham distribution
#' using a rejection sampler.
#' 
#' 
#' @param A a symmetric matrix.
#' @param B a diagonal matrix with decreasing entries.
#' @return A random pxp orthogonal matrix simulated from the Bingham
#' distribution.
#' @note This only works for small matrices, otherwise the sampler will reject
#' too frequently to be useful.
#' @author Peter Hoff
#' @references Hoff(2009)
#' @examples
#' 
#' Z<-matrix(rnorm(10*5),10,5) ; A<-t(Z)%*%Z
#' B<-diag(sort(rexp(5),decreasing=TRUE))
#' U<-rbing.Op(A,B)
#' U<-rbing.matrix.gibbs(A,B,U)
#' 
#' 
#' ## The function is currently defined as
#' function (A, B) 
#' {
#'     b <- diag(B)
#'     bmx <- max(b)
#'     bmn <- min(b)
#'     if(bmx>bmn)
#'     {
#'     A <- A * (bmx - bmn)
#'     b <- (b - bmn)/(bmx - bmn)
#'     vlA <- eigen(A)$val
#'     diag(A) <- diag(A) - vlA[1]
#'     vlA <- eigen(A)$val
#'     nu <- max(dim(A)[1] + 1, round(-vlA[length(vlA)]))
#'     del <- nu/2
#'     M <- solve(diag(del, nrow = dim(A)[1]) - A)/2
#'     rej <- TRUE
#'     cholM <- chol(M)
#'     nrej <- 0
#'     while (rej) {
#'         Z <- matrix(rnorm(nu * dim(M)[1]), nrow = nu, ncol = dim(M)[1])
#'         Y <- Z %*% cholM
#'         tmp <- eigen(t(Y) %*% Y)
#'         U <- tmp$vec %*% diag((-1)^rbinom(dim(A)[1], 1, 0.5))
#'         L <- diag(tmp$val)
#'         D <- diag(b) - L
#'         lrr <- sum(diag((D %*% t(U) %*% A %*% U))) - sum(-sort(diag(-D)) * 
#'             vlA)
#'         rej <- (log(runif(1)) > lrr)
#'         nrej <- nrej + 1
#'     }
#'     }
#'     if(bmx==bmn) { U<-rustiefel(dim(A)[1],dim(A)[1]) } 
#'     U
#'   }
#' 
#' @export rbing.Op
rbing.Op <-
function(A,B)
{
  #simulate from the bingham distribution on O(p) 
  #having density proportional to etr(B t(U)%*%A%*%U ) 
  #using the rejection sampler described in Hoff(2009)
  #this only works for small matrices, otherwise the sampler
  #will reject too frequently

  ### assumes B is a diagonal matrix with *decreasing* entries 
  
  b<-diag(B) ; bmx<-max(b) ; bmn<-min(b)  
  if(bmx>bmn)
  { 
    A<-A*(bmx-bmn) ; b<-(b-bmn)/(bmx -bmn)
    vlA<-eigen(A)$val  
    diag(A)<-diag(A)-vlA[1]
    vlA<-eigen(A)$val  

    nu<- max(dim(A)[1]+1,round(-vlA[length(vlA)]))
    del<- nu/2
    M<- solve( diag(del,nrow=dim(A)[1] ) - A )/2

    rej<-TRUE
    cholM<-chol(M)
    nrej<-0
    while(rej)
    {
      Z<-matrix(rnorm(nu*dim(M)[1]),nrow=nu,ncol=dim(M)[1])
      Y<-Z%*%cholM ; tmp<-eigen(t(Y)%*%Y)
      U<-tmp$vec%*%diag((-1)^rbinom(dim(A)[1],1,.5)) ; L<-diag(tmp$val)
      D<-diag(b)-L
      lrr<- sum(diag(( D%*%t(U)%*%A%*%U)) ) - sum( -sort(diag(-D))*vlA)
      rej<- ( log(runif(1))> lrr )
      nrej<-nrej+1
    }
  }
  if(bmx==bmn) { U<-rustiefel(dim(A)[1],dim(A)[1]) } 
   U
}
