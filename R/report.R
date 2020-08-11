#' Select data for report
#'
#' Selects data for report.
#'
#' @export
#' @param d Data frame as returned from \emph{countcheck()}
#' @return Data frame to be passed as \emph{countcheck_df} to \emph{html_report()}
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
#' @export
#' @param countcheck_df Data frame with columns
#'   \emph{y_new}, \emph{ucl_partpool}, \emph{unit}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name}, \emph{unit_url}
#' @return Vector with strings to be written as is in HTML file.
html_report <- function(countcheck_df, unit_df) {
  # check arguments
  stopifnot(
    # countcheck_df must be data frame (TODO later: also list of data frames)
    is.data.frame(countcheck_df)
  )
  head <- html_head()
  body <- html_body(countcheck_df, unit_df)
  paste0("<!DOCTYPE html>\n", "<html>\n", head, body, "</html>\n")
}

#' Generate HTML head
#'
#' Generates HTML head.
#'
#' @keywords internal
#' @return String with HTML code for head.
html_head <- function() {
  paste0("<head>\n", "<title>Hi!</title>\n", "</head>\n")
}

#' Generate HTML body
#'
#' Generates HTML body.
#'
#' @keywords internal
#' @param countcheck_df Data frame with columns
#'   \emph{y_new}, \emph{ucl_partpool}, \emph{unit}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name}, \emph{unit_url}
#' @return String with HTML code for body.
html_body <- function(countcheck_df, unit_df) {
  table <- html_table(countcheck_df, unit_df)
  paste0("<body>\n", table, "</body>\n")
}

#' Generate HTML table
#'
#' Generates HTML table.
#'
#' @keywords internal
#' @param countcheck_df Data frame with columns
#'   \emph{y_new}, \emph{ucl_partpool}, \emph{unit}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name}, \emph{unit_url}
#' @return String with HTML code for table.
html_table <- function(countcheck_df, unit_df) {
  # check arguments
  stopifnot(
    # countcheck_df must be data frame
    is.data.frame(countcheck_df),
    # unit_df must be data frame
    is.data.frame(unit_df),
    # countcheck_df must not be empty
    nrow(countcheck_df) > 0,
    # unit_df must not be empty
    nrow(unit_df) > 0,
    # countcheck_df must have expected number of columns
    ncol(countcheck_df) == 3,
    # unit_df must have expected number of columns
    ncol(unit_df) == 4,
    # colnames countcheck_df must be as expected
    colnames(countcheck_df) == c("y_new", "ucl_partpool", "unit"),
    # colnames countcheck_df must be as expected
    colnames(unit_df) == c("unit", "unit_group_name", "unit_name", "unit_url")
  )
  # Escape <, >, &, " and ' in names
  unit_df$unit_group_name <- escape(unit_df$unit_group_name)
  unit_df$unit_name <- escape(unit_df$unit_name)
  # Table header
  table_header <- paste0(
    "<tr>",
    "<th class=\"left\">y_new</th>",
    "<th class=\"left\">ucl</th>",
    "<th class=\"left\">group</th>",
    "<th class=\"left\">unit</th>",
    "</tr>\n"
  )
  # Construct table rows
  table_rows <- ""
  for (i in 1:nrow(countcheck_df)) {
    countcheck_rec <- countcheck_df[i, ]
    countcheck_unit <- as.integer(countcheck_rec["unit"])
    unit_rec <- unit_df[unit_df$unit == countcheck_unit, ]
    table_rows <- paste0(
      table_rows,
      "<tr>",
      "<td class=\"y_new\">", countcheck_rec["y_new"], "</td>",
      "<td class=\"ucl\">", countcheck_rec["ucl_partpool"], "</td>",
      "<td class=\"unit_group_name\">", unit_rec["unit_group_name"], "</td>",
      "<td class=\"unit_name\">",
      "<a href=\"", unit_rec["unit_url"], "\">",
      countcheck_unit, " - ", unit_rec["unit_name"],
      "</a>",
      "</td>",
      "</tr>\n")
  }
  # Return string for table
  paste0("<table>\n", table_header, table_rows, "</table>\n")
}

#' Escape special characters so that string can be inserted
#' into HTML
#'
#' Escapes special characters so that string can be inserted
#' into HTML, in particular <, >, &, " and '.
#'
#' @keywords internal
#' @param string Input string
#' @return String with special characters escaped
escape <- function(string) {
  s <- gsub("&", "&amp;", string)
  s <- gsub("<", "&lt;", s)
  s <- gsub(">", "&gt;", s)
  s <- gsub("\"", "&quot;", s)
  s <- gsub("'", "&#39;", s)
  s
}
