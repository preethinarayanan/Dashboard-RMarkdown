
#### Connection to DB ####

fun_myconn <- function(statement_execute = NULL, statement_get_query = NULL, 
                       statement_exist_table = NULL, statement_remove_table = NULL,
                       statement_exist_remove = NULL){
  # connect to DB
  myconn <- DBI::dbConnect(odbc::odbc(),
                           Driver   = Driver,
                           Server   = Server,
                           Database = Database,
                           UID      = UID,
                           PWD      = PWD,
                           Port     = Port)
  # run query 
  if(!is.null(statement_execute)){
    db_table <- DBI::dbExecute(myconn, statement_execute)
    return(db_table)
  }
  if(!is.null(statement_get_query)){
    db_table <- DBI::dbGetQuery(myconn, statement_get_query)
    return(db_table)
  }
  if(!is.null(statement_exist_table)){
    DBI::dbExistsTable(myconn, statement_exist_table)
  }
  if(!is.null(statement_remove_table)){
    DBI::dbRemoveTable(myconn, statement_remove_table)
  }
  if(!is.null(statement_exist_remove)){
    if(DBI::dbExistsTable(myconn, statement_exist_remove))
      DBI::dbRemoveTable(myconn, statement_exist_remove)
  }
  # Disconnect and remove connection 
  DBI::dbDisconnect(myconn)
  rm(myconn)
}


#### select query function ####

fun_query_select <- function(select_query, where_query){ 
  
  query_text <- paste0(select_query, "\n ", where_query)
  
  query_text <- paste(strwrap(query_text, width = 100000, simplify = TRUE), collapse = " ")
  
  data <- fun_myconn(statement_get_query = query_text)
  
  return(data)
}


fun_query_select_simple <- function(select_query){
  
  data <- fun_myconn(statement_get_query = select_query)
  
  return(data)
}


#### Function for summary plot with min, max, median, mean, sd series ####

#' SummaryPlot
#' 
#' @description This function produce a summary plot with 5 lines group by min, median, max, mean, and sd values
#'
#' @param df a dataframe 
#' @param min_var a character string of minimum value column 
#' @param median_var a character string of median value column
#' @param max_var a character string of max value column
#' @param mean_var a character string of mean value column
#' @param sd_var a character string of sd value column
#'
#' @return
#' @export
#'
#' @examples
#' 

SummaryPlot <- function(df, min_var, median_var, max_var, mean_var, sd_var, y_axis_name){
  
  x <- c("Min", "Median", "Max", "Mean", "SD")
  y <- sprintf("{point.%s}", c("min", "median", "max", "mean", "sd"))
  
  tltip <- tooltip_table(x,y)
  
  df %<>% 
    select(min = min_var, median = median_var, max = max_var, 
           mean = mean_var, sd = sd_var, predicted_date)
  
  highchart() %>%
    hc_add_series(df, hcaes(x = predicted_date, y = min), type = "line", color ="blue", name = "Min") %>%
    hc_add_series(df, hcaes(x = predicted_date, y = median), type = "line", color = "red", name = "Median") %>% 
    hc_add_series(df, hcaes(x = predicted_date, y = max), type = "line", color = "yellow", name = "Max") %>%
    hc_add_series(df, hcaes(x = predicted_date, y = mean), type = "line", color = "green", name = "Mean") %>% 
    hc_add_series(df, hcaes(x = predicted_date, y = sd), type = "line", color = "orange", name = "Standard Deviation") %>% 
    hc_tooltip(useHTML = TRUE, pointFormat = tltip) %>%
    hc_yAxis(title = list(text = y_axis_name)) %>%
    hc_xAxis(type = 'datetime', labels = list(format = '{value:%b %d}'), title = list(text = "Predicted Date")) %>%
    hc_add_theme(custom_theme)
}


#### Function for group by row count ####

#' RowCountPlot
#'
#' @param df a dataframe
#' @param col_var1 a character string of a column from initial dataframe
#' @param col_var2 a character string of a column from hearing dataframe 
#' @param type what type of row count, e.g. "Static Reference" and "Train"
#'
#' @return
#' @export
#'
#' @examples

RowCountPlot <- function(df, col_var1, col_var2, type){
  
  df %<>% select(predicted_date, x1 = col_var1, x2 = col_var2)
  
  x <- c(paste("Initial:"), paste("Hearing:"))
  y <- sprintf("{point.%s}", c("x1", "x2"))
  
  tltip <- tooltip_table(x,y)
  
  highchart() %>%
    hc_add_series(df, hcaes(x = predicted_date, y = x1), type = "line", color = 'green', name = "Initial") %>%
    hc_add_series(df, hcaes(x = predicted_date, y = x2), type = "line", color = 'red', name = "Hearing") %>% 
    hc_tooltip(useHTML = TRUE, pointFormat = tltip) %>% 
    hc_title(text = paste("Initial & Hearing", type, "Row Count by Predicted Date")) %>% 
    hc_yAxis(title = list(text = paste(type, "Row Count"))) %>%
    hc_xAxis(type = 'datetime', labels = list(format = '{value:%b %d}'), title = list(text = "Predicted Date")) %>%
    hc_add_theme(custom_theme)
}

#### Function for single line row count ####

#' OneLinePlot
#'
#' @param df a dataframe 
#' @param col_var a character string of a column
#' @param line_type what type of line to generate in the plot?
#' @param type what type of value, e.g. "Test Row Count"
#'
#' @return
#' @export
#'
#' @examples

OneLinePlot <- function(df, col_var, line_type = "line", type){
  
  df %<>% select(predicted_date, y = col_var)
  
  x <- c(paste0(type, ":"))
  y <- sprintf("{point.%s}", c("y"))
  tltip <- tooltip_table(x,y)
  
  highchart() %>%
    hc_add_series(df, hcaes(x = predicted_date, y = y), type = line_type, color = "green") %>%
    hc_tooltip(useHTML = TRUE, pointFormat = tltip) %>% 
    hc_title(text = paste(type, "by Predicted Date")) %>% 
    hc_yAxis(title = list(text = type)) %>%
    hc_xAxis(type = 'datetime', labels = list(format = '{value:%b %d}'), title = list(text = "Predicted Date")) %>%
    hc_legend(enabled = FALSE) %>% 
    hc_add_theme(custom_theme)
}


#' WinPlot
#'
#' @param a_or_d "Awarded" or "Denied"  
#' @param level "Initial" level or "Hearing" level 
#'
#' @return
#' @export
#'
#' @examples
#' 
WinPlot <- function(a_or_d, level){
  
  if(level == "Initial"){
    preds <- main_dat %>% 
      filter(result_init == a_or_d) %>% 
      select(pred_f = pred_init_first, pred_f_bins = pred_init_first_bins, 
             pred_l = pred_init_last, pred_l_bins = pred_init_last_bins)
  }
  if(level == "Hearing"){
    preds <- main_dat %>% 
      filter(result_hear == a_or_d) %>% 
      select(pred_f = pred_hear_first, pred_f_bins = pred_hear_first_bins, 
             pred_l = pred_hear_last, pred_l_bins = pred_hear_last_bins)
  }
  
  bin1 <- preds %>% 
    group_by(pred_bins = pred_f_bins) %>% 
    summarise(lc_count_f = n())
  
  bin2 <- preds %>% 
    group_by(pred_bins = pred_l_bins) %>% 
    summarise(lc_count_l = n())
  
  preds <- full_join(bin1, bin2)
  
  x <- c(paste("First", level, "Pred Count:"), paste("Last", level, "Pred Count:"))
  y <- sprintf("{point.%s}", c("lc_count_f", "lc_count_l"))
  
  tltip <- tooltip_table(x,y)
  
  highchart() %>% 
    hc_add_series(preds, hcaes(x = pred_bins, y = lc_count_f), type = "line", color = "violet", name = paste("First", level, "Pred")) %>% 
    hc_add_series(preds, hcaes(x = pred_bins, y = lc_count_l), type = "line", color = "black", name = paste("Last", level, "Pred")) %>% 
    hc_tooltip(useHTML = TRUE, pointFormat = tltip) %>% 
    hc_title(text = paste("Legalcase Count by First and Last", level, "Prediction Values in", level, a_or_d, "Only")) %>%
    hc_yAxis(title = list(text = "LegalcaseID Count")) %>%
    hc_xAxis(title = list(text = paste(level, "Prediction Proportion")), categories = preds$pred_bins) %>% 
    hc_add_theme(custom_theme)
}


#### Functions for dataflow ####


ComputeAUC <- function(df){
  
  test_roc <- pROC::roc(response = df$result_init_flag, predictor = df$pred_init_last)
  
  test_auc <- as.data.frame(pROC::auc(test_roc))
  
  test_auc <- as.vector(test_auc$`pROC::auc(test_roc)`)
  
  return(test_auc)
}

