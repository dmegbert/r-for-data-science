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

## add variable of minutes since midnight
since.mid <- mutate(flights, time.since.midnight = (dep_time %/% 100 * 60) + dep_time %% 100)
View(since.mid)
since.mid <- mutate(since.mid, time.since.midnight = if_else(time.since.midnight == 1440, 0, time.since.midnight))

air.time <- flights %>%
  mutate(airtime2 = (((arr_time %/% 100 * 60) + arr_time %% 100)) - 
           ((dep_time %/% 100 * 60) + dep_time %% 100),
         dif.airtime = air_time - airtime2) %>%
  select(arr_time, dep_time, airtime2, air_time, dif.airtime, everything())
View(air.time)

most.delayed <- flights %>%
  mutate(delayed.total = dep_delay + arr_delay,
         delayed.rank = min_rank(desc(delayed.total))) %>%
  arrange(delayed.rank)

View(most.delayed)

summ.by.day <- flights %>%
  group_by(year, month, day) %>%
  summarize(delay = mean(dep_delay, na.rm = TRUE))
View(summ.by.day)

delays <- flights %>%
  group_by(dest) %>%
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")

not_cancelled <- flights %>%  filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>%  
  group_by(tailnum) %>%  
  summarize(    
    delay = mean(arr_delay, na.rm = TRUE),    
    n = n()
    )

ggplot(delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

delays %>%  filter(n > 25) %>%  ggplot(mapping = aes(x = n, y = delay)) +    geom_point(alpha = 1/10)

## Batter's UP!!!

batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE), 
    ab = sum(AB, na.rm = TRUE)
  )

batters %>%  
  filter(ab > 100) %>%  
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'gam'

batters %>%
  filter(ab > 1000) %>%
  arrange(desc(ba))

batters %>%
  filter(ab > 275) %>%
  arrange(desc(ba))

## distance a plane flew
not_cancelled %>%
  count(tailnum, wt = distance) %>%
  ggplot(mapping = aes(x = tailnum, y = distance)) + 
  geom_histogram()

not_cancelled %>%
  ggplot(mapping = aes(x = tailnum, y = distance)) + 
  geom_bar()

## How many flights left before 5am?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

## What proportion of flights are delayed by more than an hour?

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60)) %>%
  arrange(desc(hour_perc))

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






