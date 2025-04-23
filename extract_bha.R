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
current_prem_url <- fb_league_urls(country = "ENG", gender = "M", season_end_year = 2025) #make this dynamic
all_team_urls <- c(strsplit(fb_teams_urls(current_prem_url),"/n"))
bha_url <- all_team_urls[grepl("Brighton", all_team_urls, fixed = TRUE)][[1]]

stats_list <- c("player_name", "Season", "Squad", "Comp", "MP", "Gls", "Ast", "G+A" ) #fill this with the desired columns


#create a list of players
players <- strsplit(fb_player_urls(bha_url), "/n")
player_stats <- data.frame()

for (i in 1:length(players)) { 
player_stats <- rbind(player_stats, fb_player_season_stats(players[[i]], stat_type = "standard", national = FALSE, time_pause = 10)[stats_list])
} # make this a loop, limit the results

write_csv(player_stats, file = "player_stats.csv")

#add also the record against each team home and away this season

