#' Prepare tweet text for the winner
#'
#' @param winner as given by twitterbookdraw::draw_winner()
#' @param book Book title
#' @param book_url Book url
#' @return
#' @export
#'
#' @examples
#' winner <- twitterbookdraw::draw_winner()
#' book <- 'An Introduction to Statistical Learning: with Applications in R'
#' book_url <- "http://geni.us/introtostatslearning"
#' twitterbookdraw::announce_winner(winner, book, book_url)
announce_winner <- function(winner, book, book_url){
  glue::glue('This month\'s winner is {winner$name} (@{winner$screen_name})! DM us to receive "{book}"!

             \n{book_url}

             \n#datascience')
}
