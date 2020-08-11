#' Select data for report
#'
#' Selects data for report.
#'
#' @keywords internal
#' @param d Data frame as returned from \emph{countcheck()}
#' @return Data frame to be passed as \emph{y_new_df} to \emph{html_report()}
select_for_report <- function(d) {
  r <- d[d$y_new - d$ucl_partpool > 0,
         c("unit", "y_new",
           "ucl_partpool", "fe_partpool")]
  r <- r[order(-r$fe_partpool), ]
  r <- r[, c("y_new", "ucl_partpool", "unit")]
  row.names(r) <- NULL
  r
}

#' Generate HTML report
#'
#' Generates HTML report.
#'
#' @keywords internal
#' @param y_new_df Data frame with columns
#'   \emph{y_new}, \emph{ucl_partpool}, \emph{unit}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name}
#' @return Vector with strings to be written as is in HTML file.
html_report <- function(y_new_df, unit_df) {
  # check arguments
  stopifnot(
    # y_new_df must be data frame
    is.data.frame(y_new_df),
    # unit_df must be data frame
    is.data.frame(unit_df),
    # y_new_df must have expected number of columns
    ncol(y_new_df) == 3,
    # unit_df must have expected number of columns
    ncol(unit_df) == 3,
    # colnames y_new_df must be as expected
    colnames(y_new_df) == c("y_new", "ucl_partpool", "unit"),
    # colnames y_new_df must be as expected
    colnames(unit_df) == c("unit", "unit_group_name", "unit_name")
  )
  "Hi"
}
