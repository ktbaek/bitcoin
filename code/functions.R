simple_stats <- function(df, ...) {
  #' Function that calculates mean, se, and ci
  #' @param df Data frame with hourly price index
  #' @param ... Grouping variable(s)
  #' @return Data frame
  
  df %>% 
    group_by(...) %>%
    summarise(
      mean_dev = mean(rel_diff, na.rm = TRUE),
      se = sd(rel_diff, na.rm = TRUE) / sqrt(n())   # standard error
    ) %>%
    mutate(
      ci_lower = mean_dev - 1.96 * se,   # 95% CI
      ci_upper = mean_dev + 1.96 * se
    ) 
  
}

summarize_factor <- function(df, group, response = rel_diff) {
  #' Function that calculates mean, performs ANOVA, calculates effect size and extreme levels and values
  #' @param df Data frame with hourly price index
  #' @param group Grouping variable
  #' @param response Response variable
  #' @return Results data frame
  
  df2 <- df %>%
    mutate(.grp = as.factor({{ group }}),
           .resp = {{ response }}) 
  
  means_tbl <- df2 %>% 
    group_by(.grp) %>%
    summarise(
      mean_rel_pp = mean(.resp, na.rm = TRUE) * 100,  # % points
      n = n(),
      .groups = "drop"
    )
  
  highest_row  <- dplyr::slice_max(means_tbl, mean_rel_pp, n = 1)
  lowest_row <- dplyr::slice_min(means_tbl, mean_rel_pp, n = 1)
  max_diff_pp <- as.numeric(highest_row$mean_rel_pp - lowest_row$mean_rel_pp)
  
  # ANOVA
  fit <- aov(.resp ~ .grp, data = df2)
  
  p_value <- tidy(fit) %>%
    filter(term == ".grp") %>%
    pull(p.value) %>%
    .[1]
  
  eta2 <- eta_squared(fit, partial = FALSE)$Eta2
  
  tibble(
    factor           = rlang::as_label(enquo(group)),
    eta2             = eta2,
    p_value          = p_value,
    max_diff_pp      = max_diff_pp,
    highest_level    = as.character(highest_row$.grp),
    highest_mean_pp  = as.numeric(highest_row$mean_rel_pp),
    lowest_level     = as.character(lowest_row$.grp),
    lowest_mean_pp   = as.numeric(lowest_row$mean_rel_pp),
    N                = nrow(df2),
    k_levels         = dplyr::n_distinct(df2$.grp)
  )
}

prettify_result_table <- function(df) {
  #' Function that prettifies output from summarize_function()
  #' @param df Data frame with statistics parameters
  #' @return gt table

 df %>%
  transmute(
    Period = period,
    `Factor&ast;` = factor,
    `η²` = format(round(eta2, 3), scientific = FALSE, drop0trailing = TRUE),
    `p-value` = ifelse(p_value < 0.01, "&lt;0.01", format(signif(p_value, 2), scientific=FALSE, drop0trailing = TRUE)),
    `Max mean diff (pp)` = round(max_diff_pp, 2),
    `Highest level` = highest_level,
    `Highest mean (pp)` = round(highest_mean_pp, 2),
    `Lowest level` = lowest_level,
    `Lowest mean (pp)` = round(lowest_mean_pp, 2),
    `N (obs)` = N,
    `k (levels)` = k_levels
  ) %>% 
    kable()
 
  
}
