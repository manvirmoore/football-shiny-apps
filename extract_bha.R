library("worldfootballR")

current_prem <- fb_league_urls(country = "ENG", gender = "M", season_end_year = 2025) #make this dynamic

bha <- fb_teams_urls("https://fbref.com/en/comps/9/Premier-League-Stats")[7] #how to find the right index

bha_players <- fb_player_urls(bha)

bha_player_stats <- fb_player_season_stats(bha_players[1], stat_type = "standard", national = FALSE, time_pause = 3) # make this a loop