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
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity),
           position = "dodge")

ggplot(data = mpg, mapping = aes(x = manufacturer, y = hwy, fill = manufacturer)) + 
         geom_boxplot() 

nz <- map_data("nz")
us <- map_data("state")
ggplot(us, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

bar <- ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut),
           show.legend = FALSE,
           width = 1  ) +  
  theme(aspect.ratio = 1) +  
  labs(x = NULL, y = NULL)

bar + coord_flip()

bar + coord_polar()

stacked.diamond.bar <- (ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity),
           position = "fill"))



stacked.diamond.bar

## Chapter 3 dplyr

library(nycflights13)
library(tidyverse)

jan1 <- filter(flights, month == 1, day == 1)
nov.dec <- filter(flights, month %in% c(11,12))
View(nov.dec)

## filter exercises

## Find all flights that had an arrival delay of two or more hours

(two.hr.delay <- filter(flights, arr_delay >= 120))

## Flew to Houston

(dest.houston <- filter(flights, dest %in% c("IAH", "HOU")))
View(dest.houston)

## Operated by United, American or Delta
(carriers <- distinct(flights, carrier))

uad <- filter(flights, carrier %in% c("UA", "AA", "DL"))
View(uad)

## Arrived more than two hours late, but didn't leave late

dep.on.time.two.hour.late <- filter(flights, dep_delay <= 0 & arr_delay >= 120)
View(dep.on.time.two.hour.late)

## Were delayed by at least an hour but made up over 30 minutes in flight

making.good.time <- filter(flights, dep_delay >= 60 & arr_delay < dep_delay - 30)

## Departed between midnight and 6am (inclusive)

red.eye <- filter(flights, (dep_time <= 600 & dep_time >= 0) | dep_time == 2400)
View(red.eye)
btw.red.eye <- filter(flights, between(dep_time, 0, 600) | dep_time == 2400)
View(btw.red.eye)

count(filter(flights, is.na(dep_time)))

## arrange() - used to order rows

arrange(flights, year, month, day, dep_time)

arrange(flights, desc(arr_delay))

## missing (NA) values are always sorted at the end

## Use is.na to sort NAs to the top
arrange(flights, desc(is.na(dep_time)))

## most delayed flights
arrange(flights, desc(dep_delay))

## earliest to leave
arrange(flights, dep_delay)

## fastest flights

fastest <- arrange(flights, desc(distance/air_time))
View(fastest)

longest <- arrange(flights, desc(distance))
View(longest)

flights.sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
View(flights.sml)

flights.sml <-  mutate(flights.sml, n(),
                       gain = arr_delay - dep_delay,
                       speed = distance / air_time * 60,
                       hours = air_time / 60,
                       gain.per.hour = gain / hours
                       )

## transmute only keeps the new variables.
View(flights)
since.mid <- mutate(flights, time.since.midnight = (dep_time %/% 100 * 60) + dep_time %% 100)
View(since.mid)
since.mid <- mutate(since.mid, time.since.midnight = if_else(time.since.midnight == 1440, 0, time.since.midnight))
