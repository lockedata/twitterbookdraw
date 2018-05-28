#' Create a gif for the June winner
#'
#' @param winner as given by twitterbookdraw::draw_winner()
#' @param path where to save the gif?
#'
#' @return
#' @export
#'
#' @examples
show_june_winner <- function(winner, path = "june.gif"){
  # get winner's avatar
  winner_face <- magick::image_read(winner$profile_image_url) %>%
    magick::image_resize("150x150")

  # create a sequence of varying opacities
  # and for each opacity create a frame
  # then join and animate frames
  frames <- purrr::map(c(seq(from = 100, to = 50, by = -5),
                         seq(from = 50, to = 100, by = 5),
                         seq(from = 100, to = 50, by = -5),
               rep(0, 5)),
             june_colorized_frame,
             winner_face = winner_face,
             background = june_background())

  frames %>%
    magick::image_join() %>%
    magick::image_animate() %>%
    magick::image_write(path)

}

june_background <- function(){
  # create a blue rectangle as background
  background <-  magick::image_blank(400, 300, '#2165B6')

  # activate it as a plot background
  img <- magick::image_draw(background)
  # add stars using base plot!
  points(runif(n = 42, min = 0, max = 400),
         runif(n = 42, min = 0, max = 300),
         cex = runif(42, min = 2, max = 4),
         col = "white",
         pch = 8)

  # add ball support using base plot as well
  rect(250, 250, 350, 150,
       border = "white", lwd = 5,
       col = "white")

  # add crystal ball, its background is a random color
  symbols(300, 150, circles = 50,
          fg = "white", inches = 1, add = TRUE,
          bg = "#B657A3", lwd = 2)

  dev.off()

  # get and resize wizard chibi
  chibi <- magick::image_read(system.file("assets/wizard_steph.png",
                                          package="twitterbookdraw")) %>%
    magick::image_resize("200x200")


  # add chibi on background
  img <- magick::image_composite(img, chibi, offset = "+10+50",
                                 operator = "Over")

  # make the crystal ball transparent by replacing its color
  # by transparency. the hole is done!
  img <- magick::image_transparent(img, "#B657A3")

  # return face-in-hole photo prop
  img
}

june_colorized_frame <- function(opacity, winner_face, background){

  # add opacity veil in front of the winner's avatar
  winner_face <- winner_face %>%
    magick::image_colorize(opacity = opacity,
                           color = "black")

  # put the winner's avatar on a white rectangle
  # which will help put the avatar right behind the hole
  winner_face <- magick::image_blank(400, 300, "white") %>%
    magick::image_composite(winner_face, offset = "+220+80")

  # put the carefully placed and veiled winner's avatar
  # behind the photo prop
  magick::image_composite(winner_face, background)
}
