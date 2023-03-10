% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/str_subset_funs.R
\name{substr_repl}
\alias{substr_repl}
\alias{substr_chartr}
\alias{substr_addin}
\alias{substr_extract}
\alias{substr_arrange}
\title{Sub-string functions}
\usage{
substr_repl(x, rp, ..., loc = NULL, start = NULL, end = NULL, fish = FALSE)

substr_chartr(
  x,
  old = "a-zA-Z",
  new = "A-Za-z",
  ...,
  loc = NULL,
  start = NULL,
  end = NULL,
  fish = FALSE
)

substr_addin(
  x,
  addition,
  side = "after",
  ...,
  loc = NULL,
  at = NULL,
  fish = FALSE
)

substr_extract(
  x,
  type = "at",
  ...,
  loc = NULL,
  start = NULL,
  end = NULL,
  fish = FALSE
)

substr_arrange(
  x,
  arr = "incr",
  ...,
  loc = NULL,
  start = NULL,
  end = NULL,
  fish = FALSE
)
}
\arguments{
\item{x}{a string or character vector.}

\item{rp}{a string, or a character vector of the same length as \code{x},
giving the replacing strings.}

\item{...}{only applicable if \code{fish=TRUE};
other arguments to be passed to the \code{stringfish} functions.}

\item{loc}{The result from the \link{stri_locate_ith} function.
It does not matter if the result is in the list form (\code{simplify = FALSE}),
or in the matrix form (\code{simplify = TRUE}).
See \link{stri_locate_ith}. \cr
NOTE: you cannot fill in both \code{loc} and \code{start,end},
or both \code{loc} and \code{at}. Choose one or the other.}

\item{start, end}{integers, or integer vectors of the same length as \code{x},
giving the start and end position of the range to be modified.}

\item{fish}{although \code{tidyoperators} has no dependencies other than \code{stringi},
it does allow the internal functions to use the multi-threadable \code{stringfish}
functions. To do so, set \code{fish=TRUE};
this requires \code{stringfish} to be installed.}

\item{old, new}{see \link[base]{chartr}.
Defaults to \code{old="a-zA-Z", new="A-Za-z"},
which means upper case characters will be transformed to lower case characters,
and vice-versa.}

\item{addition}{a string, or a character vector of the same length as \code{x},
giving the string(s) to add-in.}

\item{side}{which side of the position to add in the string.
Either \code{"before"} or \code{"after"}.}

\item{at}{an integer, or integer vector of the same length as \code{x}.}

\item{type}{a single string, giving the part of the string to extract.
3 options available: \cr
\itemize{
\item \code{type = "at"}: extracts the string part at the position range; \cr
\item \code{type = "before"}: extracts the string part before the position range; \cr
\item \code{type = "after"}: extracts the string part after the position range. \cr
}}

\item{arr}{a single string, giving how the sub-string should be arranged.
3 options available: \cr
\itemize{
\item \code{arr = "incr"}: sort the sub-string alphabetically.
\item \code{arr = "decr"}: sort the sub-string reverse alphabetically.
\item \code{arr = "rev"}: reverse the sub-string.
}}
}
\value{
A modified character vector.
If no match is found in a certain string of character vector \code{x},
the unmodified string is returned.
The exception is for the \code{substr_extract()} function:
in this function, non-matches return \code{NA}.
}
\description{
Fully vectorized sub-string functions. \cr
These functions extract, replace, add-in, transform, or re-arrange,
the \eqn{i^{th}} pattern occurrence or position range. \cr
\cr
The \code{substr_repl(x, rp, ...)} function
replaces a position (range) with string \code{rp}. \cr
\cr
The \code{substr_chartr(x, old, new, ...)} function
transforms the sub-string at a position (range) using \code{chartr(old, new)}. \cr
\cr
The \code{substr_addin(x, addition, side, ...)} function
adds the additional string \code{addition} at the side
(specified by argument \code{side}) of a position. \cr
\cr
The \code{substr_extract(x, type, ...)} function
extracts the string at, before, or after some position. \cr
\cr
The \code{substr_arrange(x, arr, ...)} function
sorts or reverse the sub-string at a position (range). \cr
\cr
}
\details{
These functions
serve as a way to provide straight-forward sub-string modification and/or extraction. \cr
All substr_ functions internally only use fully vectorized R functions
(no loops or apply-like functions). \cr
}
\examples{

# numerical substr ====

x <- rep("12345678910", 2)
start=c(1, 2); end=c(3,4)
substr_extract(x, start=start, end=end)
substr_extract(x, type="before", start=start, end=end)
substr_extract(x, type="after", start=start, end=end)
substr_repl(x, "??", start=start, end=end)
substr_chartr(x, start=start, end=end)
substr_addin(x, " ", "after", at=end)
substr_addin(x, " ", "before", at=start)

start=10; end=11
substr_extract(x, start=start, end=end)
substr_extract(x, type="before", start=start, end=end)
substr_extract(x, type="after", start=start, end=end)
substr_repl(x, "??", start=start, end=end)
substr_chartr(x, start=start, end=end)
substr_addin(x, " ", "after", at=end)
substr_addin(x, " ", "before", at=start)

start=5; end=6
substr_extract(x, start=start, end=end)
substr_extract(x, type="before", start=start, end=end)
substr_extract(x, type="after", start=start, end=end)
substr_repl(x, "??", start=start, end=end)
substr_chartr(x, start=start, end=end)
substr_addin(x, " ", "after", at=end)
substr_addin(x, " ", "before", at=start)


#############################################################################

# simple pattern ====

x <- c("goodGOODGoodgOOd", "goodGOODGoodgOOd", paste0(letters[1:13], collapse=""))
print(x)
loc <- stri_locate_ith(
  # locate second-last occurrence of "good" of each string in x:
  x, -2, regex="good", case_insensitive=TRUE
)
substr_extract(x, loc=loc) # extract second-last "good"
substr_repl(x, c("??", "!!", " "), loc=loc) # replace second-last "good"
substr_chartr(x, loc=loc) # switch upper/lower case of second-last "good"
substr_addin(x, c(" ", "~", " "), "after", loc=loc) # add white space after second-last "good"
substr_addin(x, c(" ", "~", " "), "before", loc=loc) # add white space before second-last "good"
substr_arrange(x, loc=loc) # sort second-last "good"
substr_arrange(x, "rev", loc=loc) # reverse second-last "good"
substr_arrange(x, "decr", loc=loc) # reverse-sort second-last "good"


}
