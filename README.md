# countcheck

## Detecting Count Anomalies Using Bayesian Hierarchical Models

Prototype (R package).

* Dertermines upper control limits for count data
* Reasonable results also in cases with few or no observed events
* HTML reports

Model and code are based on an examples in McElreath [2020] and
Gelman et al. [2014].

## Example 1

Count data for 1000 observational units are simulated, assuming a "normal"
data-generating process.

Since the data-generating process is free of anomalies, all counts exceeding 
their respective upper control limits (UCLs) are false positives. Other things 
being equal it is desirable to have as few false positives as possible.

Using a Bayesian hierarchical model with partial pooling, 18 new counts exceed
their respective upper control limits, vs. 68 when using a no-pooling 
model. (4 counts exceed the UCLs based on the true value of the parameter 
_theta_, which is known in this case.)

```
> devtools::install_github("https://github.com/jmeydam/countcheck.git")
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

> d[d$y_new - d$ucl_partpool > 0,
+   c("n", "y", "n_new", "y_new",
+     "true_theta", "theta_partpool",
+     "ucl_true_theta", "ucl_partpool", "fe_partpool")]

       n  y n_new y_new true_theta theta_partpool ucl_true_theta ucl_partpool fe_partpool
109   24  0    12     3 0.05812885    0.024064468            3.5          2.5  0.93044617
228   54  1    27     4 0.11591158    0.028294979            8.5          3.5  0.57204926
364   95  5    48     8 0.10194831    0.050662061           12.5          7.5  0.32063281
374  100  2    50     6 0.07644745    0.026322423           10.5          5.5  0.43583497
399  110  1    55     5 0.01644587    0.016758025            4.5          4.5  0.52080752
462  136  2    68     8 0.04883827    0.020448365            9.5          5.5  2.12009955
501  157  9    79    12 0.08478296    0.055070260           14.5         11.5  0.23971648
529  171  5    86     9 0.05595134    0.032107721           11.5          8.5  0.30089574
598  210  1   105     5 0.03900614    0.009357919           10.5          4.5  0.50441236
613  219  2   110     6 0.01705977    0.013253719            6.5          5.5  0.41409957
635  239 12   120    14 0.06846729    0.049781645           17.5         13.5  0.20457133
698  289  9   145    16 0.04752106    0.033010537           15.5         11.5  2.05684808
751  336  3   168     7 0.01771915    0.011654992            8.5          6.5  0.35732168
805  410 39   205    33 0.15066465    0.089235197           48.5         31.5  0.35070845
894  612 26   306    25 0.05070100    0.042802879           27.5         24.5  0.13815697
935  802 54   401    51 0.09019851    0.066301597           54.5         42.5  1.64848403
967 1040 26   520    25 0.03408030    0.025742256           30.5         24.5  0.13666114
974 1124 73   562    55 0.07536090    0.064331540           62.5         54.5  0.08315529

```
