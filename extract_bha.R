#' Code to prep a shiny app. this code should get the stats of each current 
#' Brighton player, to be selected via a shiny slicer.

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
current_prem <- fb_league_urls(country = "ENG", gender = "M", season_end_year = 2025) #make this dynamic
all_team_urls <- c(strsplit(fb_teams_urls(current_prem),"/n"))
bha_url <- all_team_urls[grepl("Brighton",all_team_urls, fixed = TRUE)]
bha_url <- bha_url[[1]]

#create a table of players
bha_players <- strsplit(fb_player_urls(bha_url), "/n")

player1_stats <- fb_player_season_stats(bha_players[[1]], stat_type = "standard", national = FALSE, time_pause = 3) # make this a loop
# this give a list of past seasons and teams too. need to convert all of this into tibbles i think. we want them all appended with the player name on the left. 
#add also the record against each team hone and awat this season