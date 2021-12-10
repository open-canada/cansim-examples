require(magrittr); library(ggplot2); library(lubridate)
library(data.table); options(datatable.print.class=TRUE)
# https://cran.r-project.org/web/packages/cansim/index.html
library(cansim)

# Some Open Canada data

# Vital Statistics - Birth Database
# https://www150.statcan.gc.ca/n1/en/surveys/3231

# Vital Statistics - Death Database

# Leading causes of death, total population 
# Provisional weekly death counts, by selected grouped causes of death

# Table: 13-10-0810-01
# Release date: 2021-11-08

# https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310081001
# https://www150.statcan.gc.ca/n1/tbl/csv/13100810-eng.zip

dt <- get_cansim("13-10-0810-01")

setDT(dt)
dt[1]
dt
dt %>% names 

dt$GEO %>% unique() %>% sort
dt[, GEO := gsub(", place of occurrence", "", GEO)]

dt[, Date := ymd(Date)]
dt <- dt[ Date > ymd("2020-12-01") ]

dt$`Cause of death (ICD-10)` %>% unique() %>% sort


ggplot(dt) +
    geom_step(aes(Date, val_norm, col = `Cause of death (ICD-10)`)) +
    facet_grid(`Cause of death (ICD-10)` ~ GEO , scales = "free") +
    theme(legend.position = "bottom") +
    labs(
        title = "Vital Statistics", y = "Deaths/week", x = NULL,
        caption = "Statistics Canada: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310081001"
    )


# switch facet axes 
ggplot(dt) +
    geom_step(aes(Date, val_norm, col = `Cause of death (ICD-10)`)) +
    facet_grid(GEO ~ `Cause of death (ICD-10)`, scales = "free") +
    theme(legend.position = "bottom") +
    labs(
        title = "Vital Statistics", y = "Deaths/week", x = NULL,
        caption = "Statistics Canada: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310081001"
    )
