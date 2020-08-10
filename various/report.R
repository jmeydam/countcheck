str(d2)

head(
  d2[d2$y_new - d2$ucl_partpool > 0,
     c("n", "y", "n_new", "y_new",
       "true_theta", "theta_partpool",
       "ucl_true_theta", "ucl_partpool", "fe_partpool")][
         order(-d2$fe_partpool[d2$y_new - d2$ucl_partpool > 0]), ],
  30
)

r <- d2[d2$y_new - d2$ucl_partpool > 0,
        c("unit", "n", "y", "n_new", "y_new",
          "ucl_partpool", "fe_partpool")]

r <- r[order(-r$fe_partpool), ]
r <- head(r, 30)
row.names(r) <- NULL
r

# r$diff_ucl_abs <- floor(r$y_new - r$ucl_partpool)
# r$diff_ucl_abs
# r$ratio_old_pc <- 100 * round(r$y / r$n, 4)
# r$ratio_old_pc
# r$ratio_new_pc <- 100 * round(r$y_new / r$n_new, 4)
# r$ratio_new_pc
# r$diff_ratio_pc <- r$ratio_new_pc - r$ratio_old_pc
# r$diff_ratio_pc

r$name_unit <- paste("Unit", r$unit)

r <- r[, c("y_new", "ucl_partpool", "name_unit")]
r

