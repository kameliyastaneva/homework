library(tidyverse)
library(readxl)
library(sf)
library(countrycode)
library(tmap)
library(tmaptools)
library(ggmap)

data <- read_csv("data/HDR21-22_Composite_indices_complete_time_series.csv", na="NA")

inequality_data <- data %>% 
  dplyr::select(contains("iso3"),
                contains("country"),
                contains("gii"))

inequality_diff <- inequality_data %>%
  mutate(diff_2010_2019 = (gii_2010 - gii_2019)) %>%
  dplyr::select(contains("iso3"),
                contains("country"),
                contains("diff"))

shape <- st_read("data/World_Countries/World_Countries__Generalized_.shp")

shape$ISO <- countrycode(shape$ISO, origin = "iso2c", destination = "iso3c")

inequality_map <- shape %>%
  left_join(.,
            inequality_diff,
            by = c("ISO" = "iso3"))

tmap_mode("plot")
tm_shape(inequality_map) +
tm_polygons("diff_2010_2019",
            style="pretty",
            palette = "-RdBu",
            midpoint = 0,
            title="Difference between inequality indices in 2010 and 2019")
