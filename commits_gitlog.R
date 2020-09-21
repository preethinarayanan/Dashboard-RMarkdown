#' Title
#'
#' @param repo_name 
#'
#' @return
#' @export
#'
#' @examples
git_summary <- function(repo_name){
  
  setwd(repo_name)
  
  # system("git pull")
  term_out <- system('git log --pretty=format:"%cn committed %h on %cd')
  
  
  writeLines(text = term_out,con = "path/to/central/file/location.txt")
}



for(i in my_list of repos){
  git_summary(i)
}


my_plot_function <- function(filepath){
  
  readLines("path/to/central/file/location.txt")

  # do 
  # fancy
  # plotting
  # here
  
}

