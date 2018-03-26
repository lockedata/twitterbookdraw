# from https://gist.github.com/thomasp85/0938c3ece34b9515d889f3b1f9c3fc9c
# I guess I could have adapted more but I was very lazy

deardata_url <- "https://images-na.ssl-images-amazon.com/images/I/51Hli3QtxcL._SX358_BO1,204,203,200_.jpg"

library(magick)
library(reshape2)
library(dplyr)
library(tidygraph)
library(particles)
library(animation)
# draw one follower
followers <- rtweet::get_followers("lockedata")
set.seed("20180401")
winner <- dplyr::sample_n(followers, size = 1) %>%
  rtweet::lookup_users()

plot_fun <- function(sim, winner) {
  df <- as_tibble(sim)
  par(bg = "#2165B6", family = "contrail", cex = 2)
  plot(c(min(df$x), max(df$x)),
       c(min(df$y), max(df$y)),
       col = "#2165B6", axes = FALSE,
       xlim = c(-100, 317), ylim = c(-268, 100), xlab = NA, ylab = NA)
  legend(-25, 0, legend = paste0(winner$name, "\n(@",
                                winner$screen_name, ")!"),
         box.lwd = 0,box.col = "#2165B6",bg = "#2165B6",
         text.col = "white")
  points(df$x, df$y, col = df$color, pch = '.', axes = FALSE,
         xlim = c(-100, 317), ylim = c(-268, 100), xlab = NA, ylab = NA)
}

logo <- image_read(deardata_url) %>%
  image_scale('55%')

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
    evolve(120, function(sim) {
      sim <- record(sim)
      sim <- mutate(sim, include = batch < evolutions(sim) - 10)
      plot_fun(sim, winner)
      sim
    }),
  movie.name = 'deardata.gif',
  interval = 1/24, ani.width = 594, ani.height = 822
)


# now add chibi
chibi <- magick::image_read("assets/wizard_steph.png") %>%
  magick::image_resize("230x230")
gif <- magick::image_read('deardata.gif')
gif_with_chibi <- magick::image_composite(gif, chibi,
                                          offset = "+5+550")

magick::image_animate(gif_with_chibi, fps = 10) %>%
  magick::image_write(final_gif, "tada.gif")

file.remove("deardata.gif")
