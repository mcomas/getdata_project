Code book
=========

The tidy dataset was obtained from data available in http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones the steps used to generate the dataset are available in scripts `download_extract.R` and `run_analysis.R` of repository [https://github.com/mcomas/getdata_project](https://github.com/mcomas/getdata_project). The final variable are:


 * `id`: subject identity variable
 * `activity`: activity performed by subject
 * `variable`: variable mesured to subject `id` while performing activity `activity`
 * `mean`: mean of measures of variable `variable` obtained by subject `id` performing activity `activity`

The name convention used in naming variable `variable` follow file `features_info.txt`.