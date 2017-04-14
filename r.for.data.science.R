## R For Data Science

## Chapter 1 - Data Visualization with ggplot2

library(tidyverse)

ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, shape = class))

ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +  
    geom_point(mapping = aes(x = displ, y = hwy)) +  
    facet_grid(drv ~ cyl)

ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) +  facet_grid(drv ~ .)
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) +  facet_grid(. ~ cyl)

# left
ggplot(data = mpg) +  
    geom_point(mapping = aes(x = displ, y = hwy))

# right
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +  
    geom_point(position = "jitter" , mapping = aes(color = class)) +
    geom_smooth(se=FALSE)

# statistical transformations

diamonds
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) +
    geom_histogram(mapping = aes(x = price), binwidth = 500)

ggplot(data = diamonds) +
    geom_freqpoly(mapping = aes(x = price), binwidth = 250)

ggplot(data = mpg, mapping = aes(x = year, y = cty)) +
    geom_line() +
    geom_point(mapping = aes(x = year, y = displ))

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_jitter()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(position = "jitter") +
    geom_smooth(se = FALSE, mapping = aes(group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(position = "jitter", mapping = aes(color = drv)) +
    geom_smooth() +
    facet_wrap(~ cyl, nrow = 2)

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop.., group = 1)
  )

ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth)
  )
    
ggplot(data = diamonds) +
  geom_col(mapping = aes(x = cut, y = depth))
