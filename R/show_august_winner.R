#' Show August winner with a gif
#'
#' @import ggplot2
#' @import gganimate
#'
#' @param winner as given by twitterbookdraw::draw_winner()
#' @param path where to save the gif?
#'
#' @export
#'
show_august_winner <- function(winner, path = "destruction.gif"){

  # adapted from https://r-spatial.github.io/sf/reference/geos_unary.html
  lims <- c(0, 10)
  # sample 10 points
  with(set.seed(42),
         points <- sf::st_multipoint(matrix(runif(n = 400, lims[1],
                                                  lims[2]),,2)))

   # get a square box that'll be the area of our animation
    box <- sf::st_polygon(list(rbind(c(lims[1], lims[1]),
                                 c(lims[2], lims[1]),
                                 c(lims[2], lims[2]),
                                 c(lims[1], lims[2]),
                                 c(lims[1], lims[1]))))

    # Get the Voronoi polygons of the points
    v <- sf::st_sfc(sf::st_voronoi(points, sf::st_sfc(box)))
    # Keep only the part of them inside the box
    voronoi <- sf::st_intersection(sf::st_cast(v), box)

    # Get a data.frame with the polygons
    df <- purrr::map2_df(voronoi, 1:length(voronoi),
                         get_df_from_polygon)



    df <- dplyr::group_by(df, tile) %>%
      dplyr::mutate(border = any(x %in% lims) |
                      any(y == lims[2]))

    # Define the second state with tiles fallen
    df2  <- df
    # a bit random but it does look ok!

    df2 <- dplyr::group_by(df2, tile) %>%
      dplyr::mutate(y = ifelse(!border,
                               -2 - min(y) + y,
                               y)) %>%
     dplyr::ungroup()

    df$frame <- 1
    df2$frame <- 2
    dfall <- dplyr::bind_rows(df, df2)

    p <- ggplot(dfall) +
      annotate("text", label = winner$name,
               x = 5, y = 5,
               size = 12, family = "Roboto",
               col = "#E8830C") +
      geom_polygon(aes(x = x, y = y, group = tile),
                   fill = "#2165B6", col = "white") +
      # Here comes the gganimate code
      transition_states(
        frame,
        transition_length = 1,
        state_length = 1,
        wrap = FALSE
      ) +
      ease_aes('exponential-in') +
      theme_void() +
      coord_cartesian(xlim = lims, ylim = lims)

    # create and save frames
      fs::dir_create("august_frames")
      p
      files <- animate(p,
                       renderer = file_renderer(dir = "august_frames",
                                                prefix = "plot2_") )

    # add first images
    purrr::walk(1:10, plot_one, df)

    images <- sort(as.character(
       fs::dir_ls("august_frames")))

   gifski::gifski(images,
                    gif_file = path,
                    delay = 0.1,
                    width = 480,
                    height = 480)

   # clean
     fs::dir_delete("august_frames")
}

get_df_from_polygon <- function(polygon, index){
  mat <- as.matrix(polygon)
  tibble::tibble(x = mat[,1],
                 y = mat[,2],
                 tile = index)
}

plot_one <- function(step, df){
  cols <- colorRampPalette(c("#2165B6", "white"))(10)
  ggplot(df)  +
    geom_polygon(aes(x = x, y = y, group = tile),
                 fill = "#2165B6", col = cols[step]) +
    theme_void()

  outfil <- file.path("august_frames",
                      sprintf("plot1_%02d.png", step))
  ggsave(outfil, width = 6.7, height = 6.7)
  magick::image_read(outfil) %>%
    magick::image_resize("480x480") %>%
    magick::image_write(outfil)
  outfil

}
