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
colors[followers$screen_name == winner] <- "white"

# convert to data.frame

transform_to_df <- function(sim, step, followers){
  df <- as_tibble(sim)
  df$step <- step
  df$name <- followers$screen_name
  df
}


# now simulate an aquarium of followers
first <- 50
second <- 50
max_it <- first + second
set.seed(1)
sim <- create_lattice(nrow(followers)) %>%
  simulate(velocity_decay = 0,
           setup = petridish_genesis(vel_min = 0),
           alpha_decay = 0) %>%
  evolve(first, function(sim) {
    sim <- record(sim)
    sim
  })%>%
  wield(y_force, y = -10,
        strength = .02) %>%
  evolve(second, function(sim) {
    sim <- record(sim)
    sim
  })

sim_df <- purrr::map2_df(sim$history, 1:length(sim$history),
                         transform_to_df,
                         followers)

# change trajectory for the winner
sim_df$x[sim_df$name == winner] <- seq(sim_df$x[sim_df$name == winner][1], to = 0,
                                       length = length(unique(sim_df$step)))
sim_df$y[sim_df$name == winner] <- seq(sim_df$y[sim_df$name == winner][1], to = 0,
                                       length = length(unique(sim_df$step)))

# gif as in http://www.masalmon.eu/2017/02/18/complot/

plot_one_step <- function(df, colors, winner, max_it){

  if(df$step == max_it){
    winner_size <- 20
  }else{
    winner_size <- 1
  }

  p <- ggplot(df) +
    geom_text(aes(x, y, label = name,
                  col = name),
              size = 1) +
    geom_text(aes(x, y, label = name),
              col = "#2165B6", size = winner_size,
              data = df[df$name == winner,]) +
    scale_color_manual(values = colors)+
    theme_void() +
    theme(legend.position = "none")+
    theme(text=element_text(family="Roboto", size=14)) +
    ylim(-11, 14)
  outfil <- paste0("may_files/sim_", df$step[1], ".png")
  ggsave(outfil, p, width=5, height=5)

}

logo <- magick::image_read("assets/logo.png")
logo <- magick::image_resize(logo, "400x400")

split(sim_df, sim_df$step) %>%
  purrr::walk(plot_one_step, colors = colors, winner = winner,
              max_it = max_it)

dir("may_files", full.names = TRUE) %>%
  purrr::map(magick::image_read) %>%
  magick::image_join()  %>%
  magick::image_composite(logo, offset = "5050") %>%
  magick::image_animate(fps=10) %>%
  magick::image_write("bagoffollowers.gif")

