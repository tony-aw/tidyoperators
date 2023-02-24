#' s_strapply
#'
#'@description
#' The \code{s_strapply(x, fun, w=F, clp=NULL, custom_sapply=NULL)} function
#' applies the following steps to every element (every string) of character vector \code{x}: \cr
#' 1) the string is split into a vector of single characters (\code{w=F}),
#' or a vector of space-delimited words (\code{w=T}). \cr
#' 2) the function \code{fun()} is applied to the vector from step 1. \cr
#' 3) the result from step 2 is pasted together to form a single string element again,
#' using \code{paste0(..., collapse=clp)}. \cr
#'
#' The point of this function is to increase the flexibility and usefulness
#' of the other string operators in this package.
#' Please see the Vignette for examples.
#'
#'
#' @param x a string or character vector.
#' @param fun a function **with a single argument** to be applied to the splitted string.
#' @param w logical; should each string in character vector \code{x} be splitted into space-delimited words (\code{w=T}),
#' or into single characters (w=F).
#' @param clp: how should each string be pasted together? If NULL (Default),
#' the string is pasted together using \code{paste0(..., collapse="")} if \code{w=F},
#' and using \code{paste0(..., collapse=" ")} if \code{w=T}.
#' @param custom_sapply a function. \code{s_strapply()} internally uses \code{sapply}.
#' The user may choose to replace this with a custom sapply-like function,
#' usually for multi-threading purposes.\cr
#' \code{custom_sapply} must have the same argument convention
#' as \code{sapply}, or else use the arguments \code{x} and \code{fun}. \cr
#' For example: \cr
#' \code{plan(multisession)} \cr
#' \code{s_strapply(..., custom_sapply=future.apply::future_sapply)} \cr
#'
#' @details
#'
#' Extensive examples on how to use this function can be found in the Vignette.
#'
#' @returns
#'
#' The \code{s_strapply()} function
#' generally returns a character vector of the same length as \code{x},
#' although this could depend on the function chosen for \code{fun}. \cr
#' \cr
#'
#'
#' @examples
#' x <- c(paste0(letters[1:13], collapse=""), paste0(letters[14:26], collapse=""))
#' print(x)
#' # sort every string in reverse alphabetic order:
#' s_strapply(x, fun=\(x)sort(x, decreasing = TRUE))
#'
#' # get which letter of the alphabet every character is:
#' s_strapply(x, fun=\(x)match(tolower(x), letters), clp=",")
#'
#'
#' # count
#' # get second-last vowel in every word:
#' x <- c("Outrageous, egregious, preposterous!", "Pleasant evening everyone")
#' print(x)
#' p <- s_pattern("a|e|i|o|u", ignore.case=TRUE)
#' s_strapply(x, w=T, fun=\(x)s_extract(x, -2, p))
#'

#' @export
s_strapply <- function(x, fun, w=FALSE, clp=NULL, custom_sapply=NULL) {
  if(length(w)>1){stop("w must be of length 1")}
  if(length(clp)>1){stop("clp must be of length 1")}

  if(is.null(clp)){clp <- ifelse(w, " ", "")}
  fun2 <- function(x){
    unlist(strsplit(x, split=ifelse(w, " ", ""))) |>
      fun() |> paste0(collapse = clp)
  }
  if(is.null(custom_sapply)){
    return(sapply(x, fun2, USE.NAMES = FALSE))
  }
  if(!is.null(custom_sapply)){
    return(custom_sapply(x, fun2) |> unname())
  }

}
