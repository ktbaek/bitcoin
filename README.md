Exploration of Bitcoin price patterns
================
Kristoffer T. Bæk
2025-09-17

# Summary

Dollar-cost averaging (DCA) is a common way to buy cryptocurrency where
you invest a fixed amount at fixed intervals, regardless of the price.
This raises the question if some times of the day, week, or month are
consistently better for buying. To find out, I analyzed hourly Bitcoin
price data from 2014–2023. I measured how far prices deviated from
rolling averages (1-day, 7-day, and 30-day windows) and tested calendar
effects using one-way ANOVA. In addition to testing statistical
significance, I calculated effect size
(![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}"))
to judge whether any detected patterns are practically meaningful. I
found that hour of day, and day of week only had negligible effects on
the price
(![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.001 and
![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.002, respectively). The effect of day of month was small
(![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.02) with slightly lower prices near the end of the month, but this
pattern was not consistent across years. Finally, I checked whether any
signals persisted in more recent sub-periods. In conclusion, across a
decade of data, calendar timing offered no obvious edge for DCA.

# Methods

## Data

The hourly bitcoin price index data was downloaded from
[Kaggle](https://www.kaggle.com/datasets/mczielinski/bitcoin-historical-data)
on 28 Aug 2025. (When I checked the link on 10 Sep 2025, it seems this
dataset had been replaced by a 1-minute price index dataset, which I
haven’t used). A snippet of the raw data is shown in the table below.

``` r
btc_index <- read_csv("data/BTCUSD_1h_Combined_Index.csv") 
```

| Open time           |     Open |     High |      Low |    Close |   Volume |
|:--------------------|---------:|---------:|---------:|---------:|---------:|
| 2025-08-27 11:00:00 | 110999.6 | 111384.0 | 110974.1 | 111331.0 |  8331162 |
| 2025-08-27 12:00:00 | 111331.0 | 111423.4 | 111020.5 | 111352.7 | 11723225 |
| 2025-08-27 13:00:00 | 111352.7 | 111906.4 | 111014.0 | 111556.1 | 42178340 |

I used the ‘Close’ price value for all analyses, and checked the time
series for continuity. Only the first and last day contains less than 24
data points indicating that the time series is continuous. I created
subsets of the dataset spanning the years 2014-2023, 2019-2023 and
2022-2023 containing 87,648, 43,824 and 17,520 time points,
respectively.

## Relative deviations

I calculated rolling means with window sizes of 24 hours, 7 days and 30
days. Then I calculated the hourly deviations from those averages as
absolute and relative values.

An example of the resulting data frame is shown below:

| time                |  close | length |  rollavg |      diff |  rel_diff |
|:--------------------|-------:|-------:|---------:|----------:|----------:|
| 2014-12-31 23:00:00 | 322.09 |      1 | 316.6521 |  5.437917 | 0.0171732 |
| 2014-12-31 23:00:00 | 322.09 |      7 | 311.0397 | 11.050298 | 0.0355270 |
| 2014-12-31 23:00:00 | 322.09 |     30 | 297.2398 | 24.850181 | 0.0836031 |

## Statistical analyses

For each calendar factor I fit a one-way ANOVA of relative deviation on
the factor (e.g., deviation ~ factor(hour)). I report
![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
(equivalent to ANOVA
![R^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;R%5E%7B2%7D "R^{2}"))
as the primary effect size and the model *p*-value for context.
Interpretation emphasizes effect sizes and economic magnitudes
(highest–lowest mean difference in percentage points), not just
statistical detectability.

# Results

To detect any repeating daily, weekly or monthly patterns in the BTC
price index, I calculated three different rolling means with varying
window-sizes (24 hours, 7 days and 30 days, **Figure 1**), and analyzed
how much the hourly price deviates from the mean by calculating the
relative deviation. For the first part of the analysis, I looked at the
ten year period from 2014 to 2023. The idea was to use the data from
2024-2025 as a hold-out to test any predictions that might result from
the 2014-2023 analyses.

<figure>
<img src="README_files/figure-gfm/Figure-1-1.png"
alt="Figure 1: BTC rate and rolling means. Hourly prices and rolling means with window sizes of 1, 7, and 30 days, respectively. For illustration, only one month of 2025 is shown." />
<figcaption aria-hidden="true"><strong>Figure 1: BTC rate and rolling
means.</strong> Hourly prices and rolling means with window sizes of 1,
7, and 30 days, respectively. For illustration, only one month of 2025
is shown.</figcaption>
</figure>

## Hour of day

First, I wanted to see if certain hours of day consistently offer
cheaper prices. Using the 24-hour rolling mean, I compared deviations by
hour (**Figure 2**). We can see that means with 95% confidence intervals
overlap heavily across all hours. ANOVA detected tiny but statistically
significant differences (*p* = 0.000044), but the effect size was
negligible
(![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.00068), meaning that hour of day explains less than 0.1% of the
variance in deviations. In conclusion, hour of day has no meaningful
effect on price deviations, and therefore no value for timing recurring
buys.

<figure>
<img src="README_files/figure-gfm/Figure-2-1.png"
alt="Figure 2: Mean relative deviation by hour of day (with 95% CI). The mean relative deviations (black circle) for each hour of the day and the 95% CI intervals (vertical bars) are indicated. Times in UTC." />
<figcaption aria-hidden="true"><strong>Figure 2: Mean relative deviation
by hour of day (with 95% CI)</strong>. The mean relative deviations
(black circle) for each hour of the day and the 95% CI intervals
(vertical bars) are indicated. Times in UTC.</figcaption>
</figure>

## Day of week pattern

Then I did the same analysis for weekdays but used the 7-day rolling
mean to calculate the relative deviations. We can see a large overlap
when plotting means with 95% CIs (**Figure 3**). As for the hour of day
analysis, I performed a one-way ANOVA test and calculated the effect
size. First, I only looked at time 00:00 UTC for each day. ANOVA
detected no statistically significant (*p* = 0.42) difference between
days of the week. To test if any statistically significant differences
would be detected if I used another time of day, I calculated the
*p*-value and the effect size
(![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}"))
for each hour of the day. I found that if I use hour 13:00 UTC, the
*p*-value falls below the 0.05 threshold with an effect size of
(![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.0035) meaning that the day of week explains 0.4% of the variance in
deviations. However, this is a single marginal signal among 24 parallel
tests, and the apparent weekday pattern varies heavily across years
(**Figure 4**). Taken together, this indicates that weekday effects are
essentially irrelevant for timing recurring buys.

<figure>
<img src="README_files/figure-gfm/Figure-3-1.png"
alt="Figure 3: Mean relative deviation by day of week (with 95% CI). The mean relative deviations for each day of the week at 00:00 UTC (black circle) and the 95% CI intervals (vertical bars) are indicated." />
<figcaption aria-hidden="true"><strong>Figure 3: Mean relative deviation
by day of week (with 95% CI)</strong>. The mean relative deviations for
each day of the week at 00:00 UTC (black circle) and the 95% CI
intervals (vertical bars) are indicated.</figcaption>
</figure>

<figure>
<img src="README_files/figure-gfm/Figure-4-1.png"
alt="Figure 4: Mean relative deviation by day of week (with 95% CI) for each seperate year. The mean relative deviations for each day of the week at 00:00 UTC (black circle) and the 95% CI intervals (vertical bars) are indicated." />
<figcaption aria-hidden="true"><strong>Figure 4: Mean relative deviation
by day of week (with 95% CI) for each seperate year</strong>. The mean
relative deviations for each day of the week at 00:00 UTC (black circle)
and the 95% CI intervals (vertical bars) are indicated.</figcaption>
</figure>

## Day of month pattern

Lastly, I tested whether time of month had an impact using deviations
from the 30-day rolling mean. Plotting means with 95% CIs shows some
separation across days (**Figure 5**). As before, I performed a one-way
ANOVA test and calculated the effect size. At 00:00 UTC, ANOVA detected
a statistically significant difference (*p* = 0.000031) with an effect
size of
(![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.019), meaning day of month explains 1.9% of the variance. Repeating
the test across all hours of the day again yielded statistically
significant results (*p* \< 0.05), with effect sizes ranging from
![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.019 and
![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")
= 0.021. However, the apparent pattern shifts substantially from year to
year (**Figure 6**), all in all suggesting that any month-end effect is
weak and unstable.

<figure>
<img src="README_files/figure-gfm/Figure-5-1.png"
alt="Figure 5: Mean relative deviation by day of month (with 95% CI). The mean relative deviations for each day of the month at 00:00 UTC (black circle) and the 95% CI intervals (vertical bars) are indicated." />
<figcaption aria-hidden="true"><strong>Figure 5: Mean relative deviation
by day of month (with 95% CI)</strong>. The mean relative deviations for
each day of the month at 00:00 UTC (black circle) and the 95% CI
intervals (vertical bars) are indicated.</figcaption>
</figure>

<figure>
<img src="README_files/figure-gfm/Figure-6-1.png"
alt="Figure 6: Mean relative deviation by day of month (with 95% CI) for each seperate year. The mean relative deviations for each day of the month at 00:00 UTC (black circle) and the 95% CI intervals (vertical bars) are indicated." />
<figcaption aria-hidden="true"><strong>Figure 6: Mean relative deviation
by day of month (with 95% CI) for each seperate year</strong>. The mean
relative deviations for each day of the month at 00:00 UTC (black
circle) and the 95% CI intervals (vertical bars) are
indicated.</figcaption>
</figure>

## Shorter time periods

To test stability, I recomputed the hour/weekday/month summaries over
2014–2023, 2019–2023, and 2022–2023. Each window repeats the same
methodology. The results shown in the table below emphasize the earlier
conclusions. Hour and weekday remain negligible in every window. The
day-of-month effect that is weakly present over 2014–2023 does not
replicate in 2022–2023 (large *p*, low
![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}")),
indicating that any apparent month-end dip is regime-dependent rather
than a durable pattern.

| Period    | Factor                   | η²    | p-value | Max mean diff (pp) | Highest level | Highest mean (pp) | Lowest level | Lowest mean (pp) | N (obs) | k (levels) |
|:----------|:-------------------------|:------|:--------|-------------------:|:--------------|------------------:|:-------------|-----------------:|--------:|-----------:|
| 2014-2023 | Hour of day              | 0.001 | \<0.01  |               0.11 | 22            |              0.06 | 10           |            -0.05 |   87648 |         24 |
| 2014-2023 | Day of week (00:00 UTC)  | 0.002 | 0.42    |               0.38 | Thu           |              0.16 | Fri          |            -0.23 |    3652 |          7 |
| 2014-2023 | Day of month (00:00 UTC) | 0.019 | \<0.01  |               2.94 | 8             |              1.44 | 25           |            -1.50 |    3652 |         31 |
| 2019-2023 | Hour of day              | 0.001 | \<0.01  |               0.12 | 22            |              0.07 | 11           |            -0.04 |   43824 |         24 |
| 2019-2023 | Day of week (00:00 UTC)  | 0.005 | 0.18    |               0.65 | Thu           |              0.42 | Fri          |            -0.24 |    1826 |          7 |
| 2019-2023 | Day of month (00:00 UTC) | 0.027 | 0.012   |               3.31 | 8             |              1.61 | 25           |            -1.70 |    1826 |         31 |
| 2022-2023 | Hour of day              | 0.001 | 0.99    |               0.07 | 22            |              0.03 | 19           |            -0.04 |   17520 |         24 |
| 2022-2023 | Day of week (00:00 UTC)  | 0.012 | 0.17    |               0.71 | Thu           |              0.46 | Mon          |            -0.24 |     730 |          7 |
| 2022-2023 | Day of month (00:00 UTC) | 0.041 | 0.48    |               3.48 | 5             |              1.83 | 12           |            -1.65 |     730 |         31 |

# Conclusion

For a calendar rule to improve DCA, it needs both consistency
(non-trivial
![\eta^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ceta%5E%7B2%7D "\eta^{2}"))
and economic size (highest–lowest mean differences that matter after
noise and costs). Over 2014–2023, calendar effects in Bitcoin price
deviations are either negligible (hour, weekday) or small and unstable
(day of month). In recent years (2022–2023) they largely disappear. For
recurring purchases, this evidence does not favor DCA timed by calendar
rules.
