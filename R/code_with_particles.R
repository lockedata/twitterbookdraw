# from https://gist.github.com/thomasp85/0938c3ece34b9515d889f3b1f9c3fc9c
# I guess I could have adapted more but I was very lazy

deardata_url <- "https://images-na.ssl-images-amazon.com/images/I/51Hli3QtxcL._SX358_BO1,204,203,200_.jpg"

library(reshape2)
library(dplyr)
library(tidygraph)
library(particles)
library(animation)
chibi <- magick::image_read("assets/wizard_steph.png") %>%
  magick::image_resize("200x200")
# draw one follower
followers <- rtweet::get_followers("lockedata")
set.seed("20180401")
winner <- dplyr::sample_n(followers, size = 1) %>%
  rtweet::lookup_users()

plot_fun <- function(sim, winner, chibi) {
  df <- as_tibble(sim)
  fig <- magick::image_graph(width = 417, height = 368, res = 96,
                             bg = "#2165B6")

  fig <- magick::image_annotate(fig, paste0(winner$name, "\n(@",
                                     winner$screen_name, ")!"),
                                location = "+70+0",
                                color = "black",
                                boxcolor = "transparent",
                                font = "contrail",
                                size = 30)

  # plot of the book
  plot(df$x, df$y, col = df$color, pch = '.', axes = FALSE,
       xlim = c(-100, 317), ylim = c(-268, 100), xlab = NA, ylab = NA)
  dev.off()
  # chibi
  out <- magick::image_composite(fig, chibi, offset = "+5+100")
  print(out)
}

logo <- magick::image_read(deardata_url) %>%
  magick::image_scale('55%')

logo_frame <- melt(as.matrix(as.raster(logo)), c('y', 'x'),
                   value.name = 'color', as.is = TRUE) %>%
  filter(!color == 'transparent') %>%
  mutate(color = as.character(color),
         y = -y,
         batch = as.integer(cut(-x + rnorm(n(), 0, 10), 50)),
         include = FALSE,
         y_drift = rnorm(n(), 300, 70),
         x_drift = rnorm(n(), 300, 90))

saveGIF(
  tbl_graph(logo_frame) %>%
    simulate(alpha_decay = 0, setup = predefined_genesis(x, y)) %>%
    wield(y_force, y = y_drift, include = include, strength = 0.02) %>%
    wield(x_force, x = x_drift, include = include, strength = 0.02) %>%
    wield(random_force, xmin = -.1, xmax = .1, ymin = -.1, ymax = .1,
          include = include) %>%
    evolve(10, function(sim) {
      sim <- record(sim)
      sim <- mutate(sim, include = batch < evolutions(sim) - 10)
      plot_fun(sim, winner, chibi)
      sim
    }),
  movie.name = 'deardata.gif',
  interval = 1/24, ani.width = 594, ani.height = 822
)
