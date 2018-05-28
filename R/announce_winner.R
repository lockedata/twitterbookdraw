#' Prepare tweet text for the winner
#'
#' @param winner as given by twitterbookdraw::draw_winner()
#' @param book Book title
#' @return
#' @export
#'
#' @examples
#' winner <- twitterbookdraw::draw_winner()
#' book <- 'An Introduction to Statistical Learning: with Applications in R'
#' twitterbookdraw::announce_winner(winner, book)
announce_winner <- function(winner, book){
  glue::glue('This month\'s winner is {winner$name} (@{winner$screen_name})! DM us to receive "{book}"!')
}
