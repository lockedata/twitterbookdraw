#' Show July winner with a gif
#'
#' @import ggplot2
#' @import ggimage
#'
#' @param winner as given by twitterbookdraw::draw_winner()
#' @param path where to save the gif?
#'
#' @export
#'
show_july_winner <- function(winner, path = "july.gif"){

  chibi <- magick::image_read(system.file("assets/chibi_happy_steph.png",
                                          package="twitterbookdraw")) %>%
    magick::image_resize("500x500")

  box <- magick::image_read(system.file("assets/Box.png",
                                        package="twitterbookdraw")) %>%
    magick::image_resize("1500x1500")

  dir <- tempdir()
  # from https://github.com/lockedata/thirtyone/blob/master/make_lotto.R
  magick::image_read(system.file("assets/Balloon.png",
                                 package="twitterbookdraw")) %>%
    magick::image_annotate(glue::glue("@{winner$screen_name}"),
                           location = "+870+1900",
                           size = 70,
                           font = "roboto") %>%
    magick::image_write(file.path(dir, "Balloon.png"))

  magick::image_read(system.file("assets/Label.png",
                                 package="twitterbookdraw")) %>%
    magick::image_annotate(glue::glue("@{winner$screen_name}"),
                           location = "+870+1900",
                           size = 70,
                           font = "roboto") %>%
    magick::image_write(file.path(dir, "Label.png"))


  # initial state
  data1 <- data.frame(
    x = 0,
    y = 0,
    stringsAsFactors = FALSE
  )

  # then at the top
  data2 <- data.frame(
    x = 0,
    y = 150,
    stringsAsFactors = FALSE
  )

  # transition between the two
  data <- tweenr::tween_states(list(data1, data2), 3, 1, 'linear', 31)

  # then we sprinkle the tags
  data3 <- data.frame(
    x = 0,
    y = 50,
    stringsAsFactors = FALSE
  )
  data4 <- tweenr::tween_states(list(data2, data3), 3, 2, 'linear', 10)
  data$image <- file.path(dir, "Balloon.png")
  data4$image <- file.path(dir, "Label.png")
  data4$.frame <- data4$.frame + max(data$.frame)
  data <- rbind(data, data4)
  data$name <- glue::glue("@{winner$screen_name}")

  fs::dir_create("frames")
  purrr::walk(1:nrow(data), plot_one_step, data, chibi = chibi,
              box = box)

  frames <- fs::dir_ls("frames")
  gifski::gifski(c(frames, rep(frames[length(frames)], 15)),
                 gif_file = path,
                 delay = 0.5,
                 width = 1500,
                 height = 1200)
  fs::dir_delete("frames")


}

plot_one_step <- function(step, data, chibi = chibi,
                          box = box){

  data <- data[data$.frame == step,]
  p <- ggplot(data) +
    geom_image(aes(x, y, image = image),
               size = 0.5) +
    ylim(c(-50, 170)) +
    xlim(c(-110, 110)) +
    theme_void()

  outfil <- paste0("frames/frame_", stringr::str_pad(step, 2, pad = "0"), ".png")
  ggsave(outfil, p, width=5, height=5)
  magick::image_read(outfil) %>%
    magick::image_composite(chibi,
                            offset = "+100+900") %>%
    magick::image_composite(box,
                            offset = "+0+600")  %>%
    magick::image_crop("1500x1200+0+300")%>%
    magick::image_write(outfil)
}

