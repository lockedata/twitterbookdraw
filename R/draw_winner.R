#' Draw a random follower
#'
#' @param seed Random seed (numeric)
#'
#' @return Info about the winner as a dats.frame.
#' @export
#'
#' @examples
draw_winner <- function(seed = as.numeric(Sys.Date())){
  set.seed(seed)
  rtweet::get_followers("lockedata") %>%
    dplyr::sample_n(size = 1)%>%
    .$user_id %>%
    rtweet::lookup_users()
}
