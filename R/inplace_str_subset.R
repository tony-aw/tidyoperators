#' In place modifying string subsetting
#'
#' @description
#' In-place modifier versions of string subsetting: \cr
#' \cr
#' \code{x %sget <-% ss } is the same as \code{ x <- x %sget% ss} \cr
#' \cr
#' \code{x %strim <-% ss } is the same as \code{ x <- x %strim% ss} \cr
#' \cr
#'
#' See also the documentation on string subsetting (\link[=%ss%]{string subset}). \cr
#' Note that there is no in-place modifier versions of \code{%ss%}.\cr
#' \cr
#'
#' @param x,ss see \link[=%ss%]{string subset}.
#'
#' @return
#' These operators do not return any value: they are in-place modifiers, and thus modify \code{x} directly.
#'
#' @examples
#' ss <- c(2,2)
#'
#' x <- c(paste0(letters[1:13], collapse=""), paste0(letters[14:26], collapse=""))
#' print(x)
#' x %sget <-% ss # same as x <- x %sget% ss
#' print(x)
#'
#' x <- c(paste0(letters[1:13], collapse=""), paste0(letters[14:26], collapse=""))
#' print(x)
#' x %strim <-% ss # same as x <- x %strim% ss
#' print(x)
#'
#'
#' #############################################################################
#'
#'
#' ss <- c(2,2)
#'
#' x <- c(paste0(letters[1:13], collapse=""), paste0(letters[14:26], collapse=""))
#' print(x)
#' x %sget <-% ss # same as x <- x %sget% ss
#' print(x)
#'
#' x <- c(paste0(letters[1:13], collapse=""), paste0(letters[14:26], collapse=""))
#' print(x)
#' x %strim <-% ss # same as x <- x %strim% ss
#' print(x)
#'

#' @name inplace_str_subset
NULL

#' @rdname inplace_str_subset
#' @export
`%sget <-%` <- function(x, ss) {
  eval(call("<-", substitute(x), x %sget% ss), envir = parent.frame(n = 1))
}

#' @rdname inplace_str_subset
#' @export
`%strim <-%` <- function(x, ss) {
  eval(call("<-", substitute(x), x %strim% ss), envir = parent.frame(n = 1))
}


