# countcheck

## Detecting Count Anomalies Using Bayesian Hierarchical Models

Prototype (R package).

* Dertermines upper control limits for count data
* Reasonable results also in cases with few or no observed events
* HTML reports

Model and code are based on examples in 
[Gelman et al. (2014)](https://www.stat.columbia.edu/~gelman/book/) and
[McElreath (2020)](https://xcelab.net/rm/statistical-rethinking/).

This prototype is related to a previous 
[simulation study](https://jmeydam.github.io/count-anomalies/simulation_study.html).

The distributions and parameters in the simulation study were chosen
so that the generated data is comparable to certain data of interest.
The prototype is meant to be used for roughly the same kind of data. 
Please refer to this
[report](https://jmeydam.github.io/count-anomalies/simulation_study.html) 
for details.

The package documentation can be accessed via the 
[package website](https://jmeydam.github.io/countcheck/).

## Installation

Install the following R packages and their dependencies:

* actuar
* extraDistr
* cmdstanr ([instructions](https://mc-stan.org/cmdstanr/articles/cmdstanr.html), also for installing CmdStan)


The prototype can then be installed from GitHub with:
```
devtools::install_github("https://github.com/jmeydam/countcheck.git", 
                         build_vignettes = FALSE)
```

## Example

We simulate count data for 1000 observational units, assuming a certain known
data-generating process.

The data-generating process is free of anomalies, and all counts exceeding 
their respective upper control limits (UCLs) are false positives. Other things 
being equal it is desirable to have as few false positives as possible.

Using a Bayesian hierarchical model with partial pooling, 18 new counts exceed
their respective upper control limits, vs. 68 when using a no-pooling 
model. (4 counts exceed the UCLs based on the true value of the parameter 
_theta_, which is known in this case.)

```
> library(countcheck)

> d <- countcheck(random_seed = 200807)

> # Counts exceeding UCLs
> # *********************
> # ucl_true_theta:
> sum(d$y_new - d$ucl_true_theta > 0)
[1] 4
> # ucl_nopool:
> sum(d$y_new - d$ucl_nopool > 0)
[1] 68
> # ucl_complpool:
> sum(d$y_new - d$ucl_complpool > 0)
[1] 74
> # ucl_partpool:
> sum(d$y_new - d$ucl_partpool > 0)
[1] 18
```

### Alternatively:

Using the dataset provided in the package, the same result (here without the 
true_theta values) can be obtained with:

```
> e <- simdat
> d1 <- countcheck(unit = e$unit,
+                  n = e$n,
+                  y = e$y,
+                  n_new = e$n_new,
+                  y_new = e$y_new,
+                  random_seed = 200807)
```

In a realistic scenario it is not possible to assess performance by
comparison with "true" values. The true values of _theta_ are generally 
not known, and the probability distributions assumed for the Bayesian 
hierarchical model (the no-pooling model) may in fact be inappropriate.

On the other hand, in a realistic scenario it is often possible to assess 
performance by investigating individual cases.

## HTML Report

Select data from data frame d (example above) for the report:

```
> countcheck_df <- select_for_report(d)
```

We also need a data frame with unit master data.
Here, we just generate some data:

```
> units_tmp <- sort(unique(countcheck_df$unit))
> unit_df <- data.frame(
+   unit = units_tmp,
+   unit_name = paste("Unit",
+                     units_tmp),
+   unit_url = paste0("http://domain/units/",
+                     units_tmp,
+                     ".html"),
+   unit_group_name = paste("Group",
+                           rep(1:5,
+                               length.out = length(units_tmp)))
+ )
```

Generate report as R string:

```
> report <- html_report(
+   countcheck_list = list(
+     list(df = countcheck_df, caption = "KPI 1")
+   ),
+   unit_df = unit_df,
+   title = "Report",
+   table_width_px = 500,
+   column_headers = c(
+     group = "Group",
+     count = "Count",
+     ucl = "UCL",
+     unit = "Unit",
+     name = "Name"),
+   charset = "utf-8",
+   lang = "en",
+   home_url = "https://github.com/jmeydam/countcheck"
+ )
```

Save HTML report to disk:

```
> sink("report.html")
> cat(report)
> sink()
```

[View HTML report](https://jmeydam.github.io/countcheck/report.html)

<br/>
