#' Select data for report
#'
#' Selects data for report.
#'
#' @export
#' @param d Data frame as returned from \emph{countcheck()}
#' @return Data frame to be passed in \emph{countcheck_list}
#'   to \emph{html_report()}
select_for_report <- function(d) {
  s <- d[d$y_new - d$ucl_partpool > 0,
         c("unit", "y_new",
           "ucl_partpool", "fe_partpool")]
  s <- s[order(-s$fe_partpool), ]
  s <- s[, c("y_new", "ucl_partpool", "unit")]
  row.names(s) <- NULL
  s
}

#' Generate HTML report
#'
#' Generates HTML report.
#'
#' @export
#' @param countcheck_list List of data frames with columns
#'   \emph{y_new}, \emph{ucl_partpool}, \emph{unit}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name}, \emph{unit_url}
#' @return String with HTML code for report
html_report <- function(countcheck_list,
                        unit_df,
                        title = "Report",
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
  # stopifnot(
  #   # countcheck_list must be data frame (TODO later: also list of data frames, also headers)
  #   is.data.frame(countcheck_list),
  #   is.data.frame(unit_df)
  # )
  paste0(
    "<!DOCTYPE html>\n",
    "<html lang=\"", lang, "\">\n",
    html_head(title, charset, style),
    html_body(countcheck_list, unit_df, column_headers, home_url = home_url),
    "</html>\n"
  )
}

#' Generate HTML head
#'
#' Generates HTML head.
#'
#' @keywords internal
#' @return String with HTML code for head
html_head <- function(title,
                      charset,
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
    ".header {margin-top: 10px; padding-top: 0px; padding-bottom: 0px; margin-bottom: 0px; text-align: center;}\n",
    ".header h1 {margin: 0px; color: #808080; font-size: xx-large;}\n",
    ".header .home {margin: 0px; margin-bottom: 10px; font-size: small;}\n",
    ".content {font-size: small; padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px;}\n",
    ".content .table {margin-top: 10px; padding-top: 0px; padding-bottom: 0px; margin-bottom: 30px;}\n",
    ".content .table h2 {margin-top: 0px; margin-bottom: 10px; color: #808080; font-size: x-large; text-align: center;}\n",
    ".content .table table {border: thin #888888 solid; border-collapse: collapse; width: 1000px; margin-left: auto; margin-right: auto}\n",
    ".content .table th, td {padding-top: 2px; padding-bottom: 2px; padding-left: 3px; padding-right: 5px; border: 1px #888888 solid; vertical-align: top;}\n",
    ".content .table th {background-color: #FFFFFF}\n",
    ".footer {margin-top: 0px; padding-top: 0px; padding-bottom: 0px; margin-bottom: 30px; text-align: center; font-size: small;}\n",
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
#' @param countcheck_list List of data frame with columns
#'   \emph{y_new}, \emph{ucl_partpool}, \emph{unit}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name}, \emph{unit_url}
#' @return String with HTML code for body
html_body <- function(countcheck_list,
                      unit_df,
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
    table_list[i] <- html_table(countcheck_df, unit_df, caption, column_headers)
  }
  paste0(
    "<body>\n",
    "<div class=\"header\">\n",
    home_link,
    "<h1>Units Exceeding UCLs</h1>\n",
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
#'   \emph{y_new}, \emph{ucl_partpool}, \emph{unit}
#' @param unit_df Data frame with columns
#'   \emph{unit}, \emph{unit_group_name}, \emph{unit_name}, \emph{unit_url}
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
    colnames(unit_df) == c("unit", "unit_name", "unit_url", "unit_group_name")
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
    table_rows <- paste0(
      table_rows,
      "<tr>",
      "<td class=\"left group\">",
      unit_rec["unit_group_name"],
      "</td>",
      "<td class=\"right count\">", countcheck_rec["y_new"], "</td>",
      "<td class=\"right ucl\">", countcheck_rec["ucl_partpool"], "</td>",
      "<td class=\"right unit\">",
        "<a href=\"", unit_rec["unit_url"], "\">", countcheck_unit, "</a>",
      "</td>",
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
