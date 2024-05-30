# aggregate further

aggregate_further <- function(data=NULL, hours=1){

  data <- data %>%
    group_by(id) %>%
    mutate(hour_group = (time - 1) %/% hours + 1) %>%
    group_by(id, hour_group) %>%
    summarise(
      treatment   = first(treatment),
      condition   = first(condition),
      activity    = mean(activity),
      heart_rate  = mean(heart_rate),
      temperature = mean(temperature),
      org_time    = min(org_time),
      phase       = first(phase),
      relsa       = mean(relsa) ) %>%
    ungroup() %>%
    group_by(id) %>%
    mutate(time = row_number()) %>%
    select(-hour_group) %>%
    as.data.frame()

  return(data)
}
