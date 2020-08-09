# countcheck

## Detecting Count Anomalies Using Bayesian Hierarchical Models

Prototype (R package).

* Dertermines upper control limits for count data
* Reasonable results also in cases with few or no observed events
* HTML reports

Model and code are based on examples in 
[McElreath (2020)](https://xcelab.net/rm/statistical-rethinking/) and
[Gelman et al. (2014)](https://www.stat.columbia.edu/~gelman/book/).

This prototype is related to a previous 
[simulation study](https://jmeydam.github.io/count-anomalies/simulation_study.html).

The distributions and parameters in the simulation study were chosen
so that the generated data is comparable to certain data of interest.
The prototype is only meant to be used for roughly the same 
kind of data. Please refer to the
[report](https://jmeydam.github.io/count-anomalies/simulation_study.html) 
for details.

The package documentation can be accessed via the 
[package website](https://jmeydam.github.io/countcheck/).

## Installation

First install dependencies:

* actuar
* extraDistr
* rstan ([instructions](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started))
* rethinking (>= 2.01)

The rethinking package needs to be installed from 
[GitHub](https://github.com/rmcelreath/rethinking).

This package can then be installed from GitHub with:
```
> devtools::install_github("https://github.com/jmeydam/countcheck.git", 
+                          build_vignettes = TRUE)
```

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

> d1[d1$y_new - d1$ucl_partpool > 0,
+    c("n", "y", "n_new", "y_new",
+      "true_theta", "theta_partpool",
+      "ucl_true_theta", "ucl_partpool", "fe_partpool")]

       n  y n_new y_new true_theta theta_partpool ucl_true_theta ucl_partpool fe_partpool
109   24  0    12     3         NA    0.024064468             NA          2.5  0.93044617
228   54  1    27     4         NA    0.028294979             NA          3.5  0.57204926
364   95  5    48     8         NA    0.050662061             NA          7.5  0.32063281
374  100  2    50     6         NA    0.026322423             NA          5.5  0.43583497
399  110  1    55     5         NA    0.016758025             NA          4.5  0.52080752
462  136  2    68     8         NA    0.020448365             NA          5.5  2.12009955
501  157  9    79    12         NA    0.055070260             NA         11.5  0.23971648
529  171  5    86     9         NA    0.032107721             NA          8.5  0.30089574
598  210  1   105     5         NA    0.009357919             NA          4.5  0.50441236
613  219  2   110     6         NA    0.013253719             NA          5.5  0.41409957
635  239 12   120    14         NA    0.049781645             NA         13.5  0.20457133
698  289  9   145    16         NA    0.033010537             NA         11.5  2.05684808
751  336  3   168     7         NA    0.011654992             NA          6.5  0.35732168
805  410 39   205    33         NA    0.089235197             NA         31.5  0.35070845
894  612 26   306    25         NA    0.042802879             NA         24.5  0.13815697
935  802 54   401    51         NA    0.066301597             NA         42.5  1.64848403
967 1040 26   520    25         NA    0.025742256             NA         24.5  0.13666114
974 1124 73   562    55         NA    0.064331540             NA         54.5  0.08315529
```
## Example 2

The count data in the first example were simulated with a known, "normal"
data-generating process. Some new count values of interest _y_new_ were 0.

In this example we change _y_new_ as follows:

`y_new = round(2 * ceiling(e$n_new * e$true_theta))`

This is essentially twice the expected value for _y_new_, given a new 
reference count value n_new (used as a measure of exposure) and a value 
for _theta_. We round the result up, and the lowest possible value in 
this example is 1.

Since we use a factor of 2, it is likely that the product will often
exceed the upper control limit (UCL).

Using a Bayesian hierarchical model with partial pooling, 332 new counts exceed
their respective upper control limits, vs. 489 when using a no-pooling 
model. 310 counts exceed the UCLs based on the true value of the parameter 
_theta_, which is known in this case.

```
> d2 <- countcheck(unit = e$unit,
+                  n = e$n,
+                  y = e$y,
+                  n_new = e$n_new,
+                  y_new = round(2 * ceiling(e$n_new * e$true_theta)),
+                  true_theta = e$true_theta,
+                  random_seed = 200807)

> # Counts exceeding UCLs
> # *********************
> # ucl_true_theta:
> sum(d2$y_new - d2$ucl_true_theta > 0)
[1] 310
> # ucl_nopool:
> sum(d2$y_new - d2$ucl_nopool > 0)
[1] 489
> # ucl_complpool:
> sum(d2$y_new - d2$ucl_complpool > 0)
[1] 343
> # ucl_partpool:
> sum(d2$y_new - d2$ucl_partpool > 0)
[1] 332

> head(
+   d2[d2$y_new - d2$ucl_partpool > 0,
+      c("n", "y", "n_new", "y_new",
+        "true_theta", "theta_partpool",
+        "ucl_true_theta", "ucl_partpool", "fe_partpool")]
+ )

  n y n_new y_new  true_theta theta_partpool ucl_true_theta ucl_partpool fe_partpool
1 1 0     1     2 0.049278162     0.03815631            1.5          1.5    2.559687
2 1 0     1     2 0.050456677     0.03806424            1.5          1.5    2.562781
3 1 0     1     2 0.118428974     0.03879413            1.5          1.5    2.538557
4 2 0     1     2 0.072886179     0.03742913            1.5          1.5    2.584432
5 2 0     1     2 0.004318677     0.03759384            0.5          1.5    2.578764
6 2 0     1     2 0.014761557     0.03784933            0.5          1.5    2.570046

> tail(
+   d2[d2$y_new - d2$ucl_partpool > 0,
+      c("n", "y", "n_new", "y_new",
+        "true_theta", "theta_partpool",
+        "ucl_true_theta", "ucl_partpool", "fe_partpool")]
+ )

        n   y n_new y_new  true_theta theta_partpool ucl_true_theta ucl_partpool fe_partpool
995  1952 150   976   176 0.089378272    0.076146467          115.5        100.5   8.7578432
996  2202   4  1101    10 0.003693479    0.002268037           10.5          7.5   1.5820539
997  2334  60  1167    70 0.029640283    0.025967249           52.5         47.5   4.0872775
998  2505  41  1253    38 0.014551266    0.016720363           31.5         35.5   0.5461873
999  3780 238  1890   250 0.065819145    0.062777478          158.5        151.5   9.0428098
1000 3909  63  1955    76 0.019160583    0.016331095           56.5         49.5   4.6899137
```

As analyzed in detail in the
[simulation study](https://jmeydam.github.io/count-anomalies/simulation_study.html),
if we gradually increase the factor from 1 to 8 we will find that the number
of cases exceeding the UCL is similar for the partial-pooling and true-theta 
UCLs, but initially substantially higher for the no-pooling UCLs, as was 
demonstrated here for a factor of 2. The no-pooling UCL performs poorly 
especially when the previously observed count _y_ was 0, leading to an UCL
of 0.5.

The general results are not affected when changing the seed value.

In a realistic scenario it is not possible to assess performance by
comparison with "true" values. The true values of _theta_ are generally 
not known, and the probability distributions assumed for the Bayesian 
hierarchical model (the no-pooling model) may in fact be inappropriate.

On the other hand, in a realistic scenario it is often possible to assess 
performance by investigating individual cases.
