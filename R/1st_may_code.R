library("particles")
library("tidygraph")
library("ggplot2")
library("gganimate")

# get all followers
set.seed(20180501)
follower_ids <- rtweet::get_followers("lockedata")
followers <- rtweet::lookup_users(follower_ids$user_id)
# draw a random winner
winner <- sample_n(followers, size = 1)$screen_name
# draw one random colour per follower
colors <- charlatan::ch_hex_color(n = nrow(followers))

# now simulate an aquarium of followers
sim <- create_lattice(nrow(followers)) %>%
  simulate(velocity_decay = 0.6, setup = petridish_genesis(vel_max = 0)) %>%
  wield(random_force) %>%
    evolve(10, function(sim) {
      sim <- record(sim)
      sim
    })

# convert to data.frame

transform_to_df <- function(sim, step, followers){
  df <- as_tibble(sim)
  df$step <- step
  df$name <- followers$screen_name
  df
}

sim_df <- purrr::map2_df(sim$history, 1:length(sim$history),
                         transform_to_df,
                         followers)

# change trajectory for the winner
sim_df$x[sim_df$name == winner] <- seq(sim_df$x[sim_df$name == winner][1], to = 0,
                                       length = length(unique(sim_df$step)))
sim_df$y[sim_df$name == winner] <- seq(sim_df$y[sim_df$name == winner][1], to = 0,
                                       length = length(unique(sim_df$step)))

# gif as in http://www.masalmon.eu/2017/02/18/complot/

plot_one_step <- function(df, colors, winner){
  p <- ggplot(df) +
    geom_text(aes(x, y, label = name,
                  col = name),
              size = 1) +
    geom_text(aes(x, y, label = name),
              col = "red", size = 1+df$step[1]/10,
              data = df[df$name == winner,]) +
    scale_color_manual(values = colors)+
    theme_void() +
    theme(legend.position = "none")
  outfil <- paste0("may_files/sim_", df$step[1], ".png")
  ggsave(outfil, p, width=5, height=5)

  outfil
}

logo <- magick::image_read("assets/logo.png")
logo <- magick::image_resize(logo, "200x200")

split(sim_df, sim_df$step) %>%
  purrr::map(plot_one_step, colors = colors, winner = winner) %>%
  purrr::map(magick::image_read)%>%
  magick::image_join()  %>%
  magick::image_composite(logo) %>%
  magick::image_animate(fps=1) %>%
  magick::image_write("bagoffollowers.gif")

