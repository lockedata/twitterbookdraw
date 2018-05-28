show_june_winner <- function(winner){
  # background as blue rectangle
  background <-  magick::image_blank(600, 300, '#2165B6')


  img <- magick::image_draw(background)
    # add stars
  points(runif(n = 42, min = 0, max = 600),
          runif(n = 42, min = 0, max = 300),
          cex = runif(42, min = 2, max = 4),
          col = "#E8830C",
         pch = 8)

  # add ball thing
  rect(250, 250, 350, 150,
       border = "#E8830C", lwd = 5,
       col = "#E8830C")

  # add ball
  symbols(300, 150, circles = 50,
          fg = "#E8830C", inches = 1, add = TRUE,
          bg = "white", lwd = 2)

  dev.off()

  # wizard chibi
  chibi <- magick::image_read(system.file("assets/wizard_steph.png",
                                          package="twitterbookdraw")) %>%
    magick::image_resize("200x200")


  # add chibi to background
  img <- magick::image_composite(img, chibi, offset = "+10+50",
                                 operator = "Over")

}
