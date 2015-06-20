#' Repeats randomizations and scores summary statistics
#'
#' Repeats resampling/shuffling of dataframes and scores the values returned by
#' user-define function which is applied to each randomized dataframe.
#' @inheritParams basefunctions
#' @param type character; the name of the randomization function to be applied to \code{dataframe}.
#' See \link[basefunctions]{randomization functions}.
#' @param dataframe a dataframe with the data to be suffled or resampled.
#' @param statistics a function that calculates the statistics of interest from the dataframe.
#' The first argument should be the dataframe with the data and preferavly should
#' return a (named) vector, data frame, matrix or array.
#' @param ntrials integer; number of randomizations to perform.
#' @param simplify logical; should the result be simplified
#' to a vector, matrix or higher dimensional array if possible? 
#' @param ... further arguments to be passed to the randomization functions
#' (e.g., \code{cols}, \code{replace}, \code{stratum}).
#' 
#' @section Details:
#' 
#' This function corresponds to \emph{Repeat and score} in Resampling Stats add-in for Excell
#' (www.resample.com). The randomization function defined by \code{type} is applied \code{ntrials}
#' times on the data provided by \code{dataframe}. At each trial the function defined by argument
#' \code{statistics} is applied to the resulting dataframe and the resulting objects are returned.
#'
#' @return a list of objects returned by the function defined by \code{statistics}
#' or a vector, matrix or array when \code{simplify=TRUE} and simplification can be done
#' (see \code{\link[base]{simplify2array}}).
#' 
#' @section References:
#' 
#' Statistics.com LCC. 2009. Resampling Stats Add-in for Excel User’s Guide.
#' \url{http://www.resample.com/content/software/excel/userguide/RSXLHelp.pdf}
Rsampling <- function(type=c("normal_rand", "rows_as_units", "columns_as_units", "within_rows", "within_columns"),
                       dataframe, statistics, ntrials=10000, simplify=TRUE, ...){
    f1 <- match.fun(match.arg(type))
    rlply(ntrials, statistics(f1(dataframe, ...)), .progress="text") %>%
        {if(simplify) simplify2array(.) else .}
}