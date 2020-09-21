
#### load memories ####

source("libraries.R")

source("functions.R")

source("parameters.R")

source("queries.R")


####  Read in data from DB ####

preds <- fun_query_select_simple(query_select_prediction)

batchid_log <- fun_query_select_simple(query_select_batchid)

execution_log <- fun_query_select_simple(query_select_execution)

first_preds <- fun_query_select_simple(query_select_min_preds)

last_preds <- fun_query_select_simple(query_select_max_preds)

result_init <- fun_query_select_simple(query_select_result_init)

result_hear <- fun_query_select_simple(query_select_result_hear)

saveRDS(result_hear, 'result_hear.RDS') 

saveRDS(result_init, 'result_init.RDS') 


#### Prepare data ####

batchid_log$predicted_date <- as.Date(batchid_log$data_as_of)

batchid_log %<>% arrange(predicted_date)

saveRDS(batchid_log, "batchid_log.RDS")

#### data for maintain tab #### 

first_preds$LegalCaseID %<>% trimws()

last_preds$LegalCaseID %<>% trimws()

main_dat <- first_preds %>% 
  left_join(last_preds) %>% 
  left_join(result_init) %>% 
  left_join(result_hear) %>% 
  filter((!is.na(result_init) | !is.na(result_hear)) & (!is.na(date_init) | !is.na(date_hear))) %>% 
  filter(pred_date_last < date_init | pred_date_last < date_hear) %>% 
  select(LegalCaseID, pred_init_first, pred_init_last, pred_hear_first, pred_hear_last, 
         result_init, result_hear, date_init, date_hear, net_init, net_hear)

main_dat %<>%
  mutate(pred_init_diff = .$pred_init_last - .$pred_init_first, 
         pred_hear_diff = .$pred_hear_last - .$pred_hear_first) %>% 
  mutate(pred_init_diff_bins = cut(.$pred_init_diff, breaks = seq(-1,1, .1)), 
         pred_hear_diff_bins = cut(.$pred_hear_diff, breaks = seq(-1,1, .1))) %>% 
  mutate(pred_init_first_bins = cut(.$pred_init_first, breaks = seq(0, 1, .1)), 
         pred_init_last_bins = cut(.$pred_init_last, breaks = seq(0, 1, .1)), 
         pred_hear_first_bins = cut(.$pred_hear_first, breaks = seq(0, 1, .1)), 
         pred_hear_last_bins = cut(.$pred_hear_last, breaks = seq(0, 1, .1))) %>% 
  mutate(result_init_flag = case_when(
    .$result_init == "Awarded" ~ 1, 
    .$result_init == "Denied" ~ 0),
    result_hear_flag = case_when(
      .$result_hear == "Awarded" ~ 1, 
      .$result_hear == "Denied" ~ 0
    )
  )


#### computing AUC & Flat File #### 

main_dat$month_init <- zoo::as.yearmon(main_dat$date_init)

monthly_result <- main_dat %>% 
  group_by(month_init) %>% 
  filter(!is.na(date_init)) %>% 
  summarise(avg_last_preds = mean(pred_init_last, na.rm = T), 
            avg_first_preds = mean(pred_init_first, na.rm = T),
            avg_result_init = mean(result_init_flag, na.rm = T), 
            total_lc_count = n(), 
            total_win_count = sum(result_init_flag), 
            total_net_init = sum(net_init, na.rm = T), 
            total_net_hear = sum(net_hear, na.rm = T)) 


# split data into date_init to calculate AUC for each month

data <- main_dat %>% 
  filter(!is.na(month_init)) %>% 
  group_by(month_init) %>% 
  nest()

data$monthly_auc <- map(data$data, ComputeAUC) %>% unlist() %>% as.vector()

data %<>% select(month_init, monthly_auc) %>% as.data.frame()

# join monthly auc and monthly result 

monthly_result %<>% 
  left_join(data, by = "month_init") %>% 
  rename(auc = monthly_auc)

monthly_result %<>% 
  mutate(avg_last_preds = round(avg_last_preds, 3), 
         avg_first_preds = round(avg_first_preds, 3), 
         avg_result_init = round(avg_result_init), 
         auc = round(auc, 3))

saveRDS(monthly_result, "monthly_result.RDS")

#### save RDS #### 

saveRDS(main_dat, "main_dat.RDS")





