# countcheck

## Detecting Count Anomalies Using Bayesian Hierarchical Models

Prototype for using a Bayesian hierarchical model to dertermine
threshold values in anomaly detection problems. Dertermines upper control
limits for count data. Imports and exports data in CSV format. Generates
simple reports in HTML format. Includes example data from a simulation.

The implemented Bayesian hierarchical model partially pools information
and can be used to derive reasonable threshold values even in cases with few
or no observed events. No-pooling and complete-pooling models are also
implemented to facilitate the evaluation of comparative performance.

The models and the code are based on an examples in McElreath [2020]
and Gelman et al. [2014].
