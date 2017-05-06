R for Data Science Examples
================

Learning R through tidyverse
----------------------------

### R for Data Science

*by Garrett Grolemund and Hadley Wickham*

This book introduces data science tools and techniques using R and the tidyverse suite of R packages.

### Chapter 1

Chapter 1 focuses on introducing data visualizations through the ggplot2 package.

*Here's a visualization showing the relationship between hwy gas mileage and engine size that uses the mpg dataset and splits the plot into a grid (or facet) by the number of cylinders. Facets are useful to display categorical data*

``` r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(position = "jitter", mapping = aes(color = drv)) +
    geom_smooth() +
    facet_wrap(~ cyl, nrow = 2)
```

    ## `geom_smooth()` using method = 'loess'

![](README_files/figure-markdown_github/unnamed-chunk-1-1.png)

**Here's a chart using the stat\_summary function of ggplot2**

``` r
ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )
```

![](README_files/figure-markdown_github/unnamed-chunk-2-1.png)

**Bar chart**

``` r
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))
```

![](README_files/figure-markdown_github/unnamed-chunk-3-1.png)

**AND a box plot using coord\_flip to better read the x axis labels**

``` r
ggplot(data = mpg, mapping = aes(x = manufacturer, y = hwy)) + 
         geom_boxplot() + 
         coord_flip()
```

![](README_files/figure-markdown_github/unnamed-chunk-4-1.png)

### Chapter 3 - Data Transformations with dplyr

##### Not a lot to see with this one. Check out lines 114 - 200 in r.for.data.science file if you are interested.

### Here's a visualization showing the relationship between the number of cancelled flights and the median delay per day

``` r
## relationship between flight delay and cancellations:

flights <- as_tibble(flights)

a <- flights %>%
  mutate(total.delay = arr_delay + dep_delay) %>%
  group_by(year, month, day) %>%
  summarize(cancelled.flights = sum(is.na(dep_time)),
            median.delay = median(total.delay, na.rm = TRUE)
            )

ggplot(a) +
  geom_point(mapping = aes(x = median.delay, y = cancelled.flights, color = factor(month))) + 
  geom_smooth(mapping = aes(x = median.delay, y = cancelled.flights))
```

    ## `geom_smooth()` using method = 'loess'

![](README_files/figure-markdown_github/unnamed-chunk-5-1.png)
