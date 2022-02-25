# Example for simple function to be tested
#
# 1. Change working directory
# 2. Call: testthat::test_dir('tests') within RStudio or R

increment <- function(value) {
  emptyvec = c()
  if (identical(value, emptyvec)){
    return(value)
  }else{
    value + 1
    return(value)
  }
  
}