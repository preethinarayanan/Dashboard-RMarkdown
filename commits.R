library(httr)
library(jsonlite)
url_jira_ini<-"https://jira.host/jira/rest/auth/1/session "
url_jira<-"https://jira.host/jira/rest/api/2/long_name "
credentials<-"username:password"
credentials <- base64_enc(credentials)
header_auth <- paste0("Basic ",credentials)
GET(url_jira,
    add_headers(Authorization = header_auth),
    set_cookies( atlassian.xsrf.token = "long_cookie_1",
                 JSESSIONID = "long_cookie_2"),
    authenticate(user = "pnarayanan@arrowheadgrp.com",password = "Parknight1!",type="basic"),use_proxy("proxy.host",8080,username="myusername",password="mypassword", auth="basic"),verbose(),accept_json())


library("httr")
library("jsonlite")

my_UN <- ("pnarayanan@arrowheadgrp.com")
my_PW <- ("Parknight1!")

alldata <-  {
  
  req <- GET("https://bitbucket.org/",
             path = "rest/api/2/search?jql=your jql query",
             authenticate(user = my_UN,password = my_PW,type="basic"),
             verbose()
  )
  
  api_request_content <- httr::content(req, as = "text")
  api_request_content_flat <- jsonlite::fromJSON(api_request_content)
  as.data.frame(api_request_content_flat$issues, flatten=T)
}

library(tidyverse)
library(sprintr)

# find the Story Point field identifier for your environment
find_story_point_mapping()

# find the ID of the board of interest
get_boards() %>% head(1) %>% pull(id) -> my_board

# pull up details on a board
get_board_details(board_id = my_board)

# identify the sprint of interest
get_all_sprints(board_id = my_board) %>% arrange(desc(endDate)) %>% 
  head(1) %>% pull(id) -> my_sprint

# get a sprint report
sprint_report <- get_sprint_report(sprint_id = my_sprint)
# the report has quite a bit of info, for raw story point totals
sprint_report$points_sum

# pull up details on a specific issue
get_issue(issue_key = "XXX-1234")
# or see all the fields on that issue
get_issue("XXX-1234", full_response = TRUE)

# find all the epics associated with a board
get_epics(board_id = my_board)

# the main personal motivation of this package
sprint_report_detail <- get_sprint_report_detail(board_id = my_board, sprint_id = my_sprint)
# do ggplot stuff!
