---
  title: "Stakeholder version of Advocator Dashboard"
output: 
  flexdashboard::flex_dashboard:
  source_code: embed
vertical_layout: scroll
theme: yeti
editor_options: 
  chunk_output_type: console
---
  
  ``` {js}

$('.navbar-inverse').removeClass('navbar-inverse').addClass('navbar-default');

```


```{r data include=FALSE}

setwd(here::here())

source("libraries.R")

batchid_log <- readRDS("batchid_log.RDS")

main_dat <- readRDS("main_dat.RDS")

monthly_result <- readRDS("monthly_result.RDS")

result_hear <- readRDS("result_hear.RDS")

result_init <- readRDS("result_init.RDS")


# source("data.R")

```

<style>
  .colored {
    background-color: #FAFAFA;
  }
</style>
  
  
  
  Monitor {data-icon="fa-tv"}
=====================================
  
  
  
  Column {data-width=170}
-----------------------------------------------------------------------
  
  <!-- ### Successful batch?  -->
  
  <!-- ```{r} -->
  
  <!-- success <- batchid_log$sucessful[batchid_log$predicted_date == max(batchid_log$predicted_date)] -->
  
  <!-- if(success == TRUE){ -->
      <!--   c <- "#169e1b" -->
        <!-- } else { -->
            <!--   c <- "#ed2c13" -->
              <!-- } -->
  
  <!-- valueBox(success, color = c) -->
  
  <!-- ``` -->
  
  
  
  Column {data-width=100 }
-----------------------------------------------------------------------
  
  
  ### 
  
  ```{r}

# batchid_log <- readRDS("batchid_log.RDS")

pred_date <- max(batchid_log$predicted_date)

valueBox(pred_date, subtitle = 'Most Recent Predicted Date',  color = "aqua")

```




Column {data-width=170}
-----------------------------------------------------------------------
  
  
  ### 
  
  ```{r}

avg_auc <- round(mean(monthly_result$auc), 4) * 100

valueBox(value = paste0(sprintf("%s", avg_auc), "%"), subtitle = 'Overall AUC', color = "blue")

```


Column {data-width=170}
-----------------------------------------------------------------------
  
  
  ### 
  
  ```{r}

tot_id <- length(unique(main_dat$LegalCaseID))

valueBox(value = format(tot_id, big.mark="," , small.interval=3), subtitle = 'Total Cases', color = 'green')

```


Column {data-width=270}
-----------------------------------------------------------------------
  
  
  
  ### 
  
  ```{r}

tot_nonzero <- main_dat %>% 
  filter(net_init != 0 | net_hear != 0) %>% 
  nrow

valueBox(value = format(tot_nonzero, big.mark="," , small.interval=3), subtitle = 'Total Non-Zero Cases', color = 'red')

```

Column {data-width=170}
-----------------------------------------------------------------------
  
  
  ### 
  
  ```{r}

tot_net <- round(sum(main_dat$net_init, na.rm = TRUE) + sum(main_dat$net_hear, na.rm = TRUE))  

valueBox(value = paste0("$", sprintf("%s", format(tot_net, big.mark="," , small.interval=3))), subtitle = 'Total Revenue',  color = 'yellow')

```

Column {data-width=370}
-----------------------------------------------------------------------
  
  
  ### 
  
  ```{r}

att <- round((avg_auc/100 - 0.50) * tot_net)

valueBox(value = paste0("$", sprintf("%s", format(att, big.mark="," , small.interval=3))), subtitle = 'Total Attributable Revenue',  color = 'navy')

```


Column {data-width=270}
-----------------------------------------------------------------------
  
  
  
  ### 
  
  ```{r}

avg_att <- round(att / tot_nonzero)

valueBox(value = paste0("$", sprintf("%s", format(avg_att, big.mark="," , small.interval=3))), subtitle = 'Value per Case', color = 'teal')

```


Column {data-width=270}
-----------------------------------------------------------------------
  
  
  
  ### 
  
  ```{r}

main_dat2 <- main_dat %>% filter(net_init != 0 | net_hear != 0)

avg_net_wo_zeros <- round(mean(c(main_dat2$net_init, main_dat2$net_hear), na.rm = TRUE))

valueBox(value = paste0("$", sprintf("%s", format(avg_net_wo_zeros, big.mark="," , small.interval=3))), subtitle = 'Average Revenue with Zeros Removed' , color = 'lime') 

```


Column {data-width=270}
-----------------------------------------------------------------------
  
  
  
  ### 
  
  ```{r}

main_dat %<>% 
  mutate(zero_init_net = case_when(
    .$net_init == 0 | .$net_hear == 0 ~ 1,
    TRUE ~ 0))

prop_zeros <- round(sum(main_dat$zero_init_net)/nrow(main_dat), 4) * 100

valueBox(value = paste0(sprintf("%s", prop_zeros), "%"),subtitle = 'Proportion of Zero Net' , color = 'orange')

```


Column {data-width=170}
-----------------------------------------------------------------------
  
  
  ### 
  
  ```{r}

avg_net <- round(tot_net / tot_id)

valueBox(value = paste0("$", sprintf("%s", format(avg_net, big.mark="," , small.interval=3))), subtitle = 'Average Revenue' , color = 'purple')

```

```{r}

today_initial_date <- result_init %>% select(LegalCaseID, result_init , date_init, net_init) %>% 
  filter (result_init == 'Awarded' & net_init == 0 ) %>% 
  arrange(desc(date_init)) %>%
  mutate(today_initial_date = Sys.Date() - date_init) %>%  
  head(100)

today_date <- Sys.Date()                         

valueBox(value = paste0("$", sprintf("%s", format(avg_net, big.mark="," , small.interval=3))), subtitle = 'Average Revenue' , color = 'purple')

```

# make a table of delinquent accounts,,,' no of days transpired 

intitaial decision, date, 




# avg time to payment group by closure month 


