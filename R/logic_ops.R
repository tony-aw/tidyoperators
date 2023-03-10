#' Logic operators
#'
#'@description
#' Additional logic operators: \cr
#' \cr
#' The \code{x %xor% y} operator is the "exclusive-or" operator, the same as \code{xor(x, y)}. \cr
#' \cr
#' The \code{x %n&%} operator is the "not-and" operator, the same as \code{(!x) & (!y)}. \cr
#' \cr
#' The \code{x %out% y} operator is the same as \code{!x %in% y}. \cr
#' \cr
#' The \code{x %?=% y} operator checks if \code{x} and \code{y}
#' are **both** unreal or unknown (i.e. NA, NaN, Inf, -Inf). \cr
#' \cr
#' The \code{n %=numtype% numtype} operator is a vectorized operator that checks
#' for every value of numeric vector \code{n}
#' if it can be considered a number belonging to type \code{numtype}.
#' See arguments for details. \cr
#' \cr
#' The \code{s %=strtype% strtype} operator is a vectorized operator that checks
#' for every value of character vector \code{s} \cr
#' if it can seen as a certain \code{strtype}. See arguments for details. \cr
#' \cr
#' The \code{s %sgrep% p} operator is a vectorized operator that checls
#' for every value of characyer vector \code{s} if it has pattern \code{p}.
#'
#' @param x,y see \link[base]{Logic}.
#' @param n a numeric vector.
#' @param s a character vector.
#' @param p the result from \link{s_pattern},
#' or else a character vector of the same length as \code{s} with regular expressions.
#' @param numtype a single string giving the type if numeric to be checked.
#' The following options are supported: \cr
#'  *  \code{"~0"}: zero, or else a number whose absolute value is smaller than the
#'  Machine tolerance (\code{sqrt(.Machine$double.eps)}). \cr
#'  *  \code{"B"}: binary numbers (exaclty 0 or exactly 1); \cr
#'  *  \code{"prop"}: proportions - numbers between 0 and 1 (exactly 0 or 1 is also allowed); \cr
#'  *  \code{"N"}: Natural numbers (non-negative integers including zero); \cr
#'  *  \code{"I"}: Integers; \cr
#'  *  \code{"odd"}: odd integers; \cr
#'  *  \code{"even"}: even integers; \cr
#'  *  \code{"R"}: Real numbers; \cr
#'  *  \code{"unreal"}: infinity, NA, or NaN; \cr
#' @param strtype a single string giving the type of string to be checked.
#' The following options are supported: \cr
#'  *  \code{"empty"}: checks if the string only consists of empty spaces. \cr
#'  *  \code{"unreal"}: checks if the string is NA, or if it has literal string "NA", "NaN" or "Inf",
#'  regardless if it has leading or trailing spaces. \cr
#'  *  \code{"numeric"}: checks if the string can be converted to a number,
#'  disregarding leading and trailing spaces.
#'  I.e. the string "5.0" can be converted to the the actual number \code{5.0}. \cr
#'  *  \code{"special"}: checks if the string consists of only special characters. \cr
#'
#' @examples
#' x <- c(TRUE, FALSE, TRUE, FALSE, NA, FALSE, TRUE)
#' y <- c(FALSE, TRUE, TRUE, FALSE, NA, NA, NA)
#' cbind(x, y, "x %xor% y"=x %xor% y, "x %n&% y" = x %n&% y, "x %?=% y" = x %?=% y)
#'
#' 1:3 %out% 1:10
#' 1:10 %out% 1:3
#'
#'
#' n <- c(0:5, 0:-5, 0.1, -0.1, 0, 1, Inf, -Inf, NA, NaN)
#' 1e-20 %=numtype% "~0"
#' n[n %=numtype% "B"]
#' n[n %=numtype% "prop"]
#' n[n %=numtype% "N"]
#' n[n %=numtype% "I"]
#' n[n %=numtype% "odd"]
#' n[n %=numtype% "even"]
#' n[n %=numtype% "R"]
#' n[n %=numtype% "unreal"]
#'
#' s <- c(" AbcZ123 ", " abc ", " 1.3 ", " !#$%^&*() ", "  ", "  NA  ", "  NaN  ", " Inf ")
#' s[s %=strtype% "empty"]
#' s[s %=strtype% "unreal"]
#' s[s %=strtype% "numeric"]
#' s[s %=strtype% "special"]
#'
#'
#' s <- c("Hello world", "Goodbye world")
#' p <- s_pattern(regex = c("Hello", "Hello"))
#' s %sgrep% p
#'


#' @name logic_ops
NULL

#' @rdname logic_ops
#' @export
`%xor%` <- function(x, y) {
  xor(x,y)
}

#' @rdname logic_ops
#' @export
`%n&%` <- function(x, y) {
  (!x) & (!y)
}

#' @rdname logic_ops
#' @export
`%out%` <- function(x, y) {
  return(!x %in% y)
}

#' @rdname logic_ops
#' @export
`%?=%` <- function(x, y) {
  check.na <- is.na(x) & is.na(y)
  check.nan <- is.nan(x) & is.nan(y)
  check.inf <- is.infinite(x) & is.infinite(y)
  return(check.na|check.nan|check.inf)
}

#' @rdname logic_ops
#' @export
`%sgrep%` <- function(s, p) {
  if(isTRUE(attr(p, "engine")=="stringi")){
    return(do.call(stringi::stri_detect, c(list(str=s), p)))
  }
  else{
    return(stringi::stri_detect(s, regex=p))
  }
}

#' @rdname logic_ops
#' @export
`%=numtype%` <- function(n, numtype) {
  if(length(numtype)>1){stop("numtype must be a sinlge string")}
  if(! numtype %in% c("unreal", "~0", "B", "prop", "N", "I", "odd", "even", "R")){
    stop("numtype not recognised")
  }
  if(!is.numeric(n)) { stop("n must be numeric") }
  check.unreal <- is.infinite(n) | is.nan(n) | is.na(n)
  switch(
    numtype,
    "unreal" = check.unreal,
    "~0" = ifelse(check.unreal, FALSE, abs(n) < sqrt(.Machine$double.eps)),
    "B" = ifelse(check.unreal, FALSE, n %in% c(0, 1)),
    "prop" = ifelse(check.unreal, FALSE, n >= 0 & n <= 1),
    "N" = ifelse(check.unreal, FALSE, (n==round(n)) & (n>=0)),
    "I" = ifelse(check.unreal, FALSE, n==round(n)),
    "odd" = ifelse(check.unreal, FALSE, n==round(n) & !(n/2 == round(n/2))),
    "even" = ifelse(check.unreal, FALSE, n==round(n) & (n/2 == round(n/2))),
    "R" = !check.unreal
  )
}

#' @rdname logic_ops
#' @export
`%=strtype%` <- function(s, strtype) {
  if(length(strtype)>1){stop("strtype must be a sinlge string")}
  if(! strtype %in% c("unreal", "empty", "numeric", "special")){
    stop("strtype not recognised")
  }
  check.unreal <- is.na(s)
  s.clean <- trimws(s, which="both")
  switch(
    strtype,
    "empty" = ifelse(
      check.unreal, FALSE, s.clean==""
    ),
    "unreal" = ifelse(
      check.unreal, TRUE, s.clean=="NA"|s.clean=="NaN"|s.clean=="Inf"|s.clean=="-Inf"
    ),
    "numeric" = ifelse(
      check.unreal, FALSE, suppressWarnings(!is.na(as.numeric(s.clean)))
    ),
    "special" = ifelse(
      check.unreal, FALSE,
      (nchar(s.clean)==nchar(gsub("[[:alnum:]]", "", s.clean))) & (nchar(s.clean)>0)
    )
  )
}
