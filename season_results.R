# How well Brighton did in the Premier League - head to head and goals/xG

#import libraries
library(worldfootballR)
library(tidyverse)

#get the right year for the season- if the second half of year, use the next.
end_year <- if (as.numeric(format(Sys.Date(),"%m")) > 7) {
  as.numeric(format(Sys.Date(),"%Y")) + 1
} else {
  as.numeric(format(Sys.Date(),"%Y"))
}

#get the urls
current_prem_url <- fb_league_urls(country = "ENG", gender = "M", season_end_year = 2025) 
all_team_urls <- c(strsplit(fb_teams_urls(current_prem_url),"/n"))
bha_url <- all_team_urls[grepl("Brighton", all_team_urls, fixed = TRUE)][[1]]

#Get the results and clean up
bha_results <- fb_team_match_results(bha_url) %>% 
  filter(Comp == "Premier League" & Date < Sys.Date()) %>% #cup games don't have xG stats and mess up the home/away table
  mutate(GA = as.integer(GA)) %>% 
  mutate(GF = as.integer(GF)) %>% 
  select(Date, Opponent, Comp, Round, Venue, Result, GF, GA, xG, xGA) %>% 
  mutate(GD = GF-GA)

#Create the csv
write_csv(bha_results, file = "season_results.csv")

#Create the head to head table csv
bha_record <- select(.data = bha_results, Opponent, Venue, Result) %>% 
  pivot_wider(names_from = Venue, values_from = Result) %>% 
  replace_na(list(Away="TBD", Home = "TBD")) %>% 
  relocate(Home, .before = Away) %>% 
  arrange(Opponent)

write.csv(bha_record, file = "season_record.csv")