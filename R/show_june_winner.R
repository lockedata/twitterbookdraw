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
  winner_face <- magick::image_read(winner$profile_image_url) %>%
    magick::image_resize("150x150")
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
  background <-  magick::image_blank(400, 300, '#2165B6')


  img <- magick::image_draw(background)
  # add stars
  points(runif(n = 42, min = 0, max = 400),
         runif(n = 42, min = 0, max = 300),
         cex = runif(42, min = 2, max = 4),
         col = "white",
         pch = 8)

  # add ball thing
  rect(250, 250, 350, 150,
       border = "white", lwd = 5,
       col = "white")

  # add ball
  symbols(300, 150, circles = 50,
          fg = "white", inches = 1, add = TRUE,
          bg = "#B657A3", lwd = 2)

  dev.off()

  # wizard chibi
  chibi <- magick::image_read(system.file("assets/wizard_steph.png",
                                          package="twitterbookdraw")) %>%
    magick::image_resize("200x200")


  # add chibi to background
  img <- magick::image_composite(img, chibi, offset = "+10+50",
                                 operator = "Over")
  img <- magick::image_transparent(img, "#B657A3")
  img
}

june_colorized_frame <- function(opacity, winner_face, background){

  winner_face <- winner_face %>%
    magick::image_colorize(opacity = opacity,
                           color = "black")

  winner_face <- magick::image_blank(400, 300, "white") %>%
    magick::image_composite(winner_face, offset = "+220+80")

  magick::image_composite(winner_face, background)
}
