library(dplyr)
library(rvest)

## Standard Stats

# Retrieve table
url <- "https://fbref.com/en/comps/Big5/2023-2024/stats/squads/2023-2024-Big-5-European-Leagues-Stats"
table_list <- url %>%
  read_html() %>%
  html_table()
standard_stats <- as.data.frame(table_list[[1]])

# Cleanup
names(standard_stats) <- standard_stats[1,]  # replace headers
standard_stats <- standard_stats[!(standard_stats$Rk %in% c("Rk")),]  # delete rows where Rk = "Rk"
standard_stats <- standard_stats[, c(2,3,7,11,14,19,20)]  # keep squad, comp, matches, goals, non-penalty goals, expected goals, non-penalty expected goals
names(standard_stats)[names(standard_stats) == "Gls"] <- "G"
names(standard_stats)[names(standard_stats) == "G-PK"] <- "npG"


## Basic Stats

# Retrieve table
url <- "https://fbref.com/en/comps/Big5/2023-2024/keepers/squads/2023-2024-Big-5-European-Leagues-Stats"
table_list <- url %>%
  read_html() %>%
  html_table()
basic_stats <- as.data.frame(table_list[[1]])

# Cleanup
names(basic_stats) <- basic_stats[1,]  # replace headers
basic_stats <- basic_stats[!(basic_stats$Rk %in% c("Rk")),]  # delete rows where Rk = "Rk"
basic_stats <- basic_stats[, c(2,3,5,9,11,12,14,15,16,20)]  # keep squad, comp, matches, goals allowed, shots on target allowed, saves, wins, draws, losses, penalty goals allowed
names(basic_stats)[names(basic_stats) == "PKA"] <- "pGA"


## Advanced Stats

# Retrieve table
url <- "https://fbref.com/en/comps/Big5/2023-2024/keepersadv/squads/2023-2024-Big-5-European-Leagues-Stats"
table_list <- url %>%
  read_html() %>%
  html_table()
adv_stats <- as.data.frame(table_list[[1]])

# Cleanup
names(adv_stats) <- adv_stats[1,]  # replace headers
adv_stats <- adv_stats[!(adv_stats$Rk %in% "Rk"),]  # delete rows where Rk = "Rk"
adv_stats <- adv_stats[, c(2,3,10,11,15,16,18,20,21,22,23,24,25,26,28,30)]  # keep squad, comp, own goals, post-shot xG, launch completion, launch attempts, passes, launch percent on passes, length of passes, goal kicks, goal kick launch percent, goal kick average length, crosses, crosses stopped, outside penalty area actions, average distance of defensive actions
names(adv_stats)[names(adv_stats) == "Cmp"] <- "LaunchCmp"
names(adv_stats)[names(adv_stats) == "Att"] <- "LaunchAtt"
names(adv_stats)[names(adv_stats) == "Att (GK)"] <- "PassAtt"
names(adv_stats)[names(adv_stats) == "Launch%"] <- "PassLaunchPercent"
names(adv_stats)[names(adv_stats) == "AvgLen"] <- "PassAvgLen"
names(adv_stats)[names(adv_stats) == "Att.1"] <- "GK"
names(adv_stats)[names(adv_stats) == "Launch%.1"] <- "GKLaunchPercent"
names(adv_stats)[names(adv_stats) == "AvgLen.1"] <- "GKAvgLen"
names(adv_stats)[names(adv_stats) == "Opp"] <- "CrossAtt"
names(adv_stats)[names(adv_stats) == "Stp"] <- "CrossBlock"
names(adv_stats)[names(adv_stats) == "#OPA"] <- "DefOPA"
names(adv_stats)[names(adv_stats) == "AvgDist"] <- "DefAvgDist"


## Join
keeper_stats <- merge(basic_stats, adv_stats)
all_stats <- merge(standard_stats, keeper_stats)


## Export
write.csv(all_stats, "squad_stats_2023.csv")


## Cleanup
rm(url, table_list)