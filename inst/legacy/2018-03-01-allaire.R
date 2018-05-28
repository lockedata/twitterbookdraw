library("magrittr")

followers <-rtweet::get_followers("lockedata")

set.seed(Sys.Date())
winner <- dplyr::sample_n(followers, size = 1) %>%
  rtweet::lookup_users()

rectangle <- magick::image_blank(1000, 500, color = "#2165B6")
book <- magick::image_read("assets/allaire.jpg") %>%
  magick::image_resize("300x300")
chibi <- magick::image_read("assets/wizard_steph.png") %>%
  magick::image_resize("400x400")

win <- magick::image_composite(rectangle, book,
                        offset = "+500+150") %>%
  magick::image_composite(chibi, offset = "+50+10") %>%
  magick::image_annotate(paste0(" The winner of this fantastic book\n is ",
                                winner$name, " (@",
                                winner$screen_name, ")!"),
                         location = "+400+70",
                         boxcolor = "white",
                         color = "#E8830C",
                         font = "contrail",
                         size = 30)
win <- magick::image_draw(win)
graphics::polygon(x = c(400, 400, 350),
                  y = c(80, 100, 120),
                  col = "white", border = "white")
grDevices::dev.off()

magick::image_write(win, "tada.png")
