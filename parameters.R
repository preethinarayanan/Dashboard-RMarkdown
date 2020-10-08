

#### database connection string ####

Driver <- "{SQL Server Native Client 11.0}"
Server <- "dbserver02.arcadvantage.local"

# Driver <- "{ODBC Driver 17 for SQL Server}"
# Server <- "10.1.100.211"
Database <- "DISABILITY"
UID <- "Arrowhead"
PWD <- .Advocator_pass
Port <- 1433
#PWD <- 'Disabitlity_2018!'
  

#### Theme #### 

custom_theme <- hc_theme(
  colors = c('#5CACEE', 'green', 'red'),
  chart = list(
    backgroundColor = '#FAFAFA',
    plotBorderColor = "black"),
  xAxis = list(
    gridLineColor = "E5E5E5",
    labels = list(style = list(color = "#333333")),
    lineColor = "#E5E5E5",
    minorGridLineColor = "#E5E5E5",
    tickColor = "#E5E5E5",
    title = list(style = list(color = "#333333"))),
  yAxis = list(
    gridLineColor = "#E5E5E5",
    labels = list(style = list(color = "#333333")),
    lineColor = "#E5E5E5",
    minorGridLineColor = "#E5E5E5",
    tickColor = "#E5E5E5",
    tickWidth = 1,
    title = list(style = list(color = "#333333"))),
  title = list(style = list(color = '#333333', fontFamily = "Lato")),
  subtitle = list(style = list(color = '#666666', fontFamily = "Lato")),
  legend = list(
    itemStyle = list(color = "#333333"),
    itemHoverStyle = list(color = "#FFF"),
    itemHiddenStyle = list(color = "#606063")),
  credits = list(style = list(color = "#666")),
  itemHoverStyle = list(color = 'gray'))
