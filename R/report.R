#' Select data for report
#'
#' Selects data for report.
#'
#' Selected columns:
#' \itemize{
#' \item \emph{unit}:            ID for unit
#' \item \emph{y_new}:           new count values of interest
#' \item \emph{ucl_partpool}:    UCL based on n_new and partial-pooling
#'                                 estimate of theta
#' \item \emph{fe_partpool}:     factor \emph{f}, with observed y_new
#'                                 exceeding partial-pooling UCL by
#'                                 \emph{f * sd(y_new)},
#'                                 given n_new and partial-pooling estimate
#'                                 of theta
#' }
#'
#' Condition that always applies: \emph{y_new} must exceed \emph{ucl_partpool}.
#'
#' Additional optional conditions:
#' \itemize{
#' \item \emph{y_new} exceeds \emph{min_y_new} (default: 0)
#' \item difference between \emph{y_new} and \emph{ucl_partpool}
#'   exceeds \emph{min_diff} (default: 0)
#' \item \emph{unit_group_name} (if present) matches part of group name
#'   in \emph{unit_df} (if present) for units in \emph{d}
#' }
#'
#' Returned data is sorted by \emph{fe_partpool} in descending order.
#' Therefore, items towards the top are less likely to be the result of
#' random fluctuations.
#'
#' @export
#' @param d Data frame as returned from \emph{countcheck()}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name},
#'   and \emph{unit_url} (ignored if NA).
#'   Must contain exactly one record for each unit in
#'   \emph{d}.
#'   (default: NULL)
#' @param unit_group_name Name of unit group for which data
#'   should be returned. Can be part of name (substring).
#'   (default: NULL)
#' @param min_y_new Minimum value for y_new (default: 0)
#' @param min_diff Minimum difference between y_new and ucl_partpool
#'   (default: 0)
#' @return Data frame to be passed in \emph{countcheck_list}
#'   to \emph{html_report()}
select_for_report <- function(d,
                              unit_df = NULL,
                              unit_group_name = NULL,
                              min_y_new = 0,
                              min_diff = 0) {
  # check arguments
  stopifnot(
    # d must be data frame
    is.data.frame(d),
    # unit_df must be data frame or NULL
    is.null(unit_df) | is.data.frame(unit_df),
    # unit_group_name must be string or NULL
    is.null(unit_group_name) | is.character(unit_group_name),
    # min_y_new must be non-negative number
    is.numeric(min_y_new),
    min_y_new >= 0,
    # min_diff must be non-negative number
    is.numeric(min_diff),
    min_diff >= 0
  )
  s <- d[d$y_new - d$ucl_partpool > 0,
         c("unit", "y_new",
           "ucl_partpool", "fe_partpool")]
  s <- s[s$y_new >= min_y_new, ]
  s <- s[s$y_new - s$ucl_partpool >= min_diff, ]
  s <- s[order(-s$fe_partpool), ]
  s <- s[, c("y_new", "ucl_partpool", "unit")]
  # filter by unit group name only if both unit_df and unit_group_name
  # have been passed to function
  if (! is.null(unit_df) & ! is.null(unit_group_name)) {
    s <- s[matching_unit_group(s,unit_df, unit_group_name), ]
  }
  row.names(s) <- NULL
  s
}

#' Selects rows with matching unit group
#'
#' Selects rows with matching unit group - helper function used
#' in select_for_report(). Condition: \emph{unit_group_name}
#' matches part of group name in \emph{unit_df} for units in \emph{s}.
#'
#' @keywords internal
#' @param s Data frame of same type as returned by \emph{select_for_report()}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name},
#'   and \emph{unit_url} (ignored if NA).
#'   Must contain exactly one record for each unit in
#'   \emph{s}.
#' @param unit_group_name Name of unit group for which data
#'   should be returned. Can be part of name (substring).
#' @return Vector of type logical
matching_unit_group <- function(s,
                                unit_df,
                                unit_group_name) {
  include <- logical(nrow(s))
  for (i in 1:nrow(s)) {
    countcheck_rec <- s[i, ]
    countcheck_unit <- as.integer(countcheck_rec["unit"])
    unit_rec <- unit_df[unit_df$unit == countcheck_unit, ]
    include[i] <-
      grepl(unit_group_name,
            unit_rec["unit_group_name"],
            fixed = TRUE)
  }
  include
}

#' Generate HTML report
#'
#' Generates HTML report for multiple tables as returned by
#' \emph{select_for_report}.
#'
#' @export
#' @param countcheck_list Data to be shown in report. List of lists with
#'   two items named "caption" and "countcheck_df".
#'   The item \emph{countcheck_df} in each of the nested lists is a data frame
#'   with columns \emph{y_new}, \emph{ucl_partpool}, and \emph{unit} -
#'   as returned by \emph{select_for_report()}.
#'   The item \emph{caption} in each of the nested lists is used for
#'   the table caption.
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name},
#'   and \emph{unit_url} (ignored if NA).
#'   Must contain exactly one record for each unit in
#'   \emph{countcheck_df} dataframes in \emph{countcheck_list}.
#' @param title Title for HTML document
#' @param table_width_px Table width in pixels (for all tables)
#' @param column_headers Column headers for tables; vector with five headers -
#'   the elements of the vector must be named \emph{group}, \emph{count},
#'   \emph{ucl}, \emph{unit}, and \emph{name}
#' @param charset Character set of data and HTML document
#' @param lang Language of HTML document
#' @param home_url URL for link to "Home" included at top of HTML document
#'   (optional)
#' @param style Additional CSS rules (optional)
#' @return String with HTML code for report
html_report <- function(countcheck_list,
                        unit_df,
                        title = "Report",
                        table_width_px = 1000,
                        column_headers = c(
                          group = "Group",
                          count = "Count",
                          ucl = "UCL",
                          unit = "Unit",
                          name = "Name"),
                        charset = "utf-8",
                        lang = "en",
                        home_url = NULL,
                        style = NULL) {
  # check arguments
  stopifnot(
    # countcheck_list must be list
    is.list(countcheck_list),
    # countcheck_list must not be data frame
    ! is.data.frame(countcheck_list),
    # unit_df must be data frame
    is.data.frame(unit_df)
  )
  paste0(
    "<!DOCTYPE html>\n",
    "<html lang=\"", lang, "\">\n",
    html_head(title, charset, table_width_px, style),
    html_body(countcheck_list, unit_df, title, column_headers, home_url),
    "</html>\n"
  )
}

#' Generate HTML head
#'
#' Generates HTML head.
#'
#' @keywords internal
#' @param title Title for HTML document
#' @param charset Character set of data and HTML document
#' @param table_width_px Table width in pixels (for all tables)
#' @param style Additional CSS rules (optional)
#' @return String with HTML code for head
html_head <- function(title,
                      charset,
                      table_width_px,
                      style) {
  if (is.null(style)) {
    append_style <- ""
  } else {
    append_style <- style
  }
  default_style <- paste0(
    "body {font-family: \"Arial\", \"Lucida Sans Unicode\", \"Verdana\", \"sans-serif\";}\n",
    "a:link {color: #000000;}\n",
    "a:visited {color: #000000;}\n",
    ".header {margin-top: 10px; margin-bottom: 0px; padding-top: 0px; padding-bottom: 0px; text-align: center;}\n",
    ".header h1 {margin: 0px; color: #808080; font-size: xx-large;}\n",
    ".header .home {margin: 0px; margin-bottom: 10px; font-size: small;}\n",
    ".content {font-size: small; padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px;}\n",
    ".content .table {margin-top: 10px; margin-bottom: 30px; padding-top: 0px; padding-bottom: 0px;}\n",
    ".content .table h2 {margin-top: 0px; margin-bottom: 10px; color: #808080; font-size: x-large; text-align: center;}\n",
    ".content .table table {border: thin #888888 solid; border-collapse: collapse; width: ", table_width_px, "px; margin-left: auto; margin-right: auto}\n",
    ".content .table th, td {padding-top: 2px; padding-bottom: 2px; padding-left: 3px; padding-right: 5px; border: 1px #888888 solid; vertical-align: top;}\n",
    ".content .table th {background-color: #FFFFFF}\n",
    ".footer {margin-top: 0px; margin-bottom: 30px; padding-top: 0px; padding-bottom: 0px; text-align: center; font-size: small;}\n",
    ".left {text-align: left}\n",
    ".right {text-align: right}\n"
  )
  paste0(
    "<head>\n",
    "<meta charset=\"", charset, "\">\n",
    "<title>", escape(title), "</title>\n",
    "<style>", default_style, append_style, "</style>\n",
    "</head>\n"
  )
}

#' Generate HTML body
#'
#' Generates HTML body.
#'
#' @keywords internal
#' @param countcheck_list Data to be shown in report. List of lists with
#'   two items named "caption" and "countcheck_df".
#'   The item \emph{countcheck_df} in each of the nested lists is a data frame
#'   with columns \emph{y_new}, \emph{ucl_partpool}, and \emph{unit} -
#'   as returned by \emph{select_for_report()}.
#'   The item \emph{caption} in each of the nested lists is used for
#'   the table caption.
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name},
#'   and \emph{unit_url} (ignored if NA).
#'   Must contain exactly one record for each unit in
#'   \emph{countcheck_df} dataframes in \emph{countcheck_list}.
#' @param title for HTML document
#' @param column_headers Column headers for tables; vector with five headers -
#'   the elements of the vector must be named \emph{group}, \emph{count},
#'   \emph{ucl}, \emph{unit}, and \emph{name}
#' @param home_url URL for link to "Home" included at top of HTML document
#'   (optional)
#' @return String with HTML code for body
html_body <- function(countcheck_list,
                      unit_df,
                      title,
                      column_headers,
                      home_url = NULL) {
  if (is.null(home_url)) {
    home_link <- ""
  } else {
    home_link <- paste0(
      "<div class=\"home\"><a href=\"",
      home_url,
      "\">Home</a></div>\n"
    )
  }
  table_list <- list()
  for (i in 1:length(countcheck_list)) {
    caption <- countcheck_list[[i]]$caption
    countcheck_df <- countcheck_list[[i]]$df
    table_list[i] <- html_table(
      countcheck_df,
      unit_df,
      caption,
      column_headers)
  }
  paste0(
    "<body>\n",
    "<div class=\"header\">\n",
    home_link,
    "<h1>", escape(title), "</h1>\n",
    "</div>\n",
    "<div class=\"content\">\n",
    paste(as.character(table_list), collapse = ""),
    "</div>\n",
    "<div class=\"footer\">\n",
    Sys.time(),
    "</div>\n",
    "</body>\n"
  )
}

#' Generate HTML table
#'
#' Generates HTML table.
#'
#' @keywords internal
#' @param countcheck_df Data frame with columns
#'   \emph{y_new}, \emph{ucl_partpool}, and \emph{unit} -
#'   as returned by \emph{select_for_report}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name},
#'   and \emph{unit_url} (ignored if NA).
#'   Must contain exactly one record for each unit in
#'   \emph{countcheck_df} dataframes in \emph{countcheck_list}.
#' @param caption Caption for table
#' @param headers Vector with five column headers -
#'   the elements of the vector must be named \emph{group}, \emph{count},
#'   \emph{ucl}, \emph{unit}, and \emph{name}
#' @return String with HTML code for table
html_table <- function(countcheck_df,
                       unit_df,
                       caption,
                       headers = c(group = "Group",
                                   count = "Count",
                                   ucl = "UCL",
                                   unit = "Unit",
                                   name = "Name")) {
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
    colnames(unit_df) == c("unit", "unit_name", "unit_url", "unit_group_name"),
    # names of header vector must be as specified
    names(headers) == c("group", "count", "ucl", "unit", "name")
  )
  # Escape <, >, &, " and ' in names
  unit_df$unit_group_name <- escape(unit_df$unit_group_name)
  unit_df$unit_name <- escape(unit_df$unit_name)
  caption <- escape(caption)
  headers <- escape(headers)
  # Before table
  pre <- paste0(
    "<div class=\"table\">\n",
    "<h2>", caption, "</h2>\n"
  )
  # Table header
  table_header <- paste0(
    "<tr>",
    "<th class=\"left\">", headers["group"], "</th>",
    "<th class=\"right\">", headers["count"], "</th>",
    "<th class=\"right\">", headers["ucl"], "</th>",
    "<th class=\"right\">", headers["unit"], "</th>",
    "<th class=\"left\">", headers["name"], "</th>",
    "</tr>\n"
  )
  # Construct table rows
  table_rows <- ""
  for (i in 1:nrow(countcheck_df)) {
    countcheck_rec <- countcheck_df[i, ]
    countcheck_unit <- as.integer(countcheck_rec["unit"])
    unit_rec <- unit_df[unit_df$unit == countcheck_unit, ]
    if (is.na(unit_rec["unit_url"])) {
      td_unit <- paste0("<td class=\"right unit\">",
                        countcheck_unit,
                        "</td>")
    } else {
      td_unit <- paste0("<td class=\"right unit\">",
                        "<a href=\"", unit_rec["unit_url"], "\">",
                        countcheck_unit,
                        "</a>",
                        "</td>")
    }
    table_rows <- paste0(
      table_rows,
      "<tr>",
      "<td class=\"left group\">",
      unit_rec["unit_group_name"],
      "</td>",
      "<td class=\"right count\">", countcheck_rec["y_new"], "</td>",
      "<td class=\"right ucl\">", countcheck_rec["ucl_partpool"], "</td>",
      td_unit,
      "<td class=\"left name\">", unit_rec["unit_name"], "</td>",
      "</tr>\n"
    )
  }
  # After table
  post <- "</div>\n"
  # Return string for table
  paste0(pre, "<table>\n", table_header, table_rows, "</table>\n", post)
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
