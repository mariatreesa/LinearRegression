#' Function to fit linear model by way of QR decomposition
#' Authors: Brian Masinde (brima748), Maria Treesa Sebastian (marse306), Omkar(omkbh878)
#'
#' @param formula as formula
#' @param data as data frame
#'
#' @return estimates as S3 object
#' @export linreg_QR
#'


linreg_QR <- function(formula, data) {
  # get the independent variables into a n*p matrix
  X <- model.matrix(formula, data = data)
  # extract all the variable names from the formula
  vars <- all.vars(formula)
  if(is.numeric(data[ ,vars[1]]) == FALSE){
    stop("Dependent variable is not numeric")
  }
  # get the first variables as independent
  Y <- as.matrix(data[, vars[1]])
  # use function qr to decompose X'X
  QR <- qr(X)
  #Use the function solve
  beta <- solve(QR, Y)
  # Get etimated y
  y_hat <- X %*% beta
  # subtract y from y_hat
  res <- as.vector(Y - y_hat)
  # Standard errors of the residuals p is the rank of the QR matrix
  se_sq <- sum(res^2)/ (nrow(X) - QR$rank)
  #Using cholesky inversion
  beta_var <-  diag(chol2inv(QR$qr) * se_sq)

  # create an object
  estimates <- list(
    "Coefficients" = beta,
    "Coefficient Variance" = beta_var,
    match.call()
  )

  # assign a class to the object
  class(estimates) <- "linreg_QR"
  # return object
  estimates

}



