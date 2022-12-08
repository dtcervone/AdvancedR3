#' Calculate descriptive stats for each metabolite
#' @param data Lipidomics dataset
#' @return A data.frame/tibble
descriptive_stats <- function(data) {
  data %>%
    dplyr::group_by(metabolite) %>%
    dplyr::summarise(across(value, list(mean = mean, sd = sd))) %>%
    dplyr::mutate(across(where(is.numeric), round, digits = 1))
}
