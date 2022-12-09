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

#' Covert pivot code to function
#'
#' @param data data with string columns
#' @param values_fn account for several cholesterols
#'
#' @return one row for each participant (i.e. decrease row #, increase cols)
metabolites_to_wider <- function(data, values_fn = mean) {
  data %>%
    mutate(metabolite = snakecase::to_snake_case(metabolite)) %>%
    tidyr::pivot_wider(
      names_from = metabolite,
      values_from = value,
      values_fn = values_fn,
      names_prefix = "metabolite_"
    )
}

#' Transformation recipe to pre-process the data
#'
#' @param data Lipidomics dataset
#' @param metabolite_variable Column of the metabolite variable
#'
#' @return
create_recipe_spec <- function(data, metabolite_variable) {
  recipes::recipe(data) %>%
    recipes::update_role({{ metabolite_variable }}, age, gender, new_role = "predictor") %>%
    recipes::update_role(class, new_role = "outcome") %>%
    recipes::step_normalize(tidyselect::starts_with("metabolite_"))
}

#' Create a workflow object of the model and transformations
#'
#' @param model_specs the model specs
#' @param recipe_specs the recipe specs
#'
#' @return A workflow object
#'
create_model_workflow <- function(model_specs, recipe_specs) {
  workflows::workflow() %>%
    workflows::add_model(model_specs) %>%
    workflows::add_recipe(recipe_specs)
}

#' Create a tidy output of model results
#'
#' @param workflow_fitted_model The model workflow object that's been fitted
#'
#' @return A data frame
#'
tidy_model_output <- function (workflow_fitted_model) {
  workflow_fitted_model %>%
    workflows::extract_fit_parsnip() %>%
    broom::tidy(exponentiate = TRUE)
}
