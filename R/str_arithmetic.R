#' String arithmetic
#'
#'@description
#' String arithmetic operators. \cr
#' \cr
#' The \code{x %s+% y } operator is equivalent to \code{paste0(x,y)}. \cr
#' \cr
#' The \code{x %s-% p } operator removes character/pattern defined in \code{p} from \code{x}. \cr
#' \cr
#' The \code{x %s*% n } operator repeats every element of \code{x} for \code{n} times,
#' and glues them together. \cr
#' \cr
#' The \code{x %s/% p } operator counts how often regular expression or character pattern \code{p}
#' occurs in each element of \code{x}. \cr
#' \cr
#' @param x a string or character vector.
#' @param y a string, or a character vector of the same length as \code{x}.
#' @param p a pattern (regular expression), or character vector of regular expressions of the same length as \code{x},
#' giving the pattern to look for. \cr
#' The default interpretation is a regular expression, using: \cr
#' \code{fixed=FALSE, ignore.case=FALSE, perl=FALSE} (see link[base]{grep}).\cr
#' To evaluate pattern \code{p} with non-default options, simply replace \code{p} with \code{s_pattern(p, ...)}. \cr
#' See \code{\link{s_pattern}}.
#' @param n a number, or a numeric vector of the same length as \code{x}.
#'
#'
#' @details
#' These operators and functions serve as a way to provide straight-forward string arithmetic,
#' missing from base R. \cr
#' \cr
#' The pattern \code{p} is by default understood to be characters or regular expressions evaluated with the default arguments
#' (\code{fixed=FALSE, ignore.case=FALSE, perl=FALSE}). \cr
#' To change this, simply replace \code{p} with \code{s_pattern(p, fixed, ignore.case, perl)}. \cr
#' For example, \code{x %s/% p } counts how often regular expression p occurs in x, \cr
#' whereas \code{x %s/% s_pattern(p, ignore.case=TRUE) } will do the same except it does not distinguish between capital/upper and lower characters.\cr
#' See \code{\link{s_pattern}} for more information.
#'
#' Extensive examples on how to use these operators and functions can be found in the vignette.
#'
#' @returns
#' The \code{%s+%}, \code{%s-%}, and \code{%s*%} operators
#' return a character vector of the same length as \code{x}. \cr
#' The \code{%s/%} returns a integer vector of the same length as \code{x}.
#'
#'
#' @examples
#' x <- c(paste0(letters[1:13], collapse=""), paste0(letters[14:26], collapse=""))
#' print(x)
#' y <- "a"
#' p <- "a|e|i|o|u" # same as p <- s_pattern("a|e|i|o|u", fixed=FALSE, ignore.case=FALSE, perl=FALSE)
#' n <- c(3, 2)
#'
#' x %s+% y # =paste0(x,y)
#' x %s-% p # remove all vowels from x
#' x %s*% n
#' x %s/% p # count how often vowels appear in each string of vector x.
#'
#'
#' #############################################################################
#'
#'
#' x <- c(paste0(letters[1:13], collapse=""), paste0(letters[14:26], collapse=""))
#' print(x)
#' y <- "a"
#' # pattern with ignore.case=TRUE:
#' p <- s_pattern("A|E|I|O|U", fixed=FALSE, ignore.case=TRUE, perl=FALSE)
#' n <- c(2, 3)
#'
#' x %s+% y # =paste0(x,y)
#' x %s-% p # remove all vowels from x
#' x %s*% n
#' x %s/% p # count how often vowels appears in each string of vector x.
#'
#'
#' #############################################################################
#'
#'
#' p <- s_pattern("\\v+", perl=TRUE) # perl expression; only works with perl=TRUE
#' x <- "line1 \n line2"
#' print(x)
#' x %s-% p # remove vertical line
#'

#' @rdname str_arithmetic
#' @export
`%s+%` <- function(x, y) { paste0(x, y) }

#' @rdname str_arithmetic
#' @export
`%s-%` <- function (x, p) {
  fxd <- ic <- prl <- FALSE
  if(!is.null(attr(p, "fixed"))){fxd <- attr(p, "fixed")}
  if(!is.null(attr(p, "ignore.case"))){ic <- attr(p, "ignore.case")}
  if(!is.null(attr(p, "perl"))){prl <- attr(p, "perl")}
  mapply(function(x, p){
    gsub(pattern = p, replacement = "",  x = x, fixed = fxd, ignore.case = ic, perl = prl)
  }, x, p, USE.NAMES = FALSE)
}

#' @rdname str_arithmetic
#' @export
`%s*%` <- function (x, n) {
  strrep(x, n)
}

#' @rdname str_arithmetic
#' @export
`%s/%` <- function (x, p) {
  fxd <- ic <- prl <- FALSE
  if(!is.null(attr(p, "fixed"))){fxd <- attr(p, "fixed")}
  if(!is.null(attr(p, "ignore.case"))){ic <- attr(p, "ignore.case")}
  if(!is.null(attr(p, "perl"))){prl <- attr(p, "perl")}
  mapply(function(x, p){
    lengths(regmatches(x, gregexpr(p, x, fixed = fxd, ignore.case = ic, perl = prl)))
  }, x, p, USE.NAMES = FALSE)
}
