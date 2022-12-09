#' Calculate descriptive stats for each metabolite
#' @param data Lipidomics dataset
#' @return A data.frame/tibble
descriptive_stats <- function(data) {
  data %>%
    dplyr::group_by(metabolite) %>%
    dplyr::summarise(across(value, list(mean = mean, sd = sd, iqr = IQR))) %>%
    dplyr::mutate(across(where(is.numeric), round, digits = 1))
}
## This should be in the R/functions.R file.
#' Plot for basic count data.
#'
#' @param data The lipidomics dataset.
#'
#' @return A ggplot2 graph.
#'
plot_count_stats <- function(data) {
  data %>%
    dplyr::distinct(code, gender, class) %>%
    ggplot2::ggplot(ggplot2::aes(x = class, fill = gender)) +
    ggplot2::geom_bar(position = "dodge")
}

#' Plot for basic distribution of metabolite data.
#'
#' @param data The lipidomics dataset.
#'
#' @return A ggplot2 graph.
#'
plot_distributions <- function(data) {
  data %>%
    ggplot2::ggplot(ggplot2::aes(x = value)) +
    ggplot2::geom_histogram() +
    ggplot2::facet_wrap(ggplot2::vars(metabolite), scales = "free")
}

#' Curly curly to apply snakecase across columns of our choice
#'
#' @param data data with string columns
#' @param cols columns to convert into snakecase
#'
#' @return data frame in snakecase

column_values_to_snakecase <- function(data, cols) {
  data %>%
    dplyr::mutate(dplyr::across({{ cols }}, snakecase::to_snake_case))
}
