#library(regclass)
library(readr)
#library(tidyverse)

df <- read_csv("gk_stats_2023.csv")

# For meaningful analysis, restrict to goalkeepers with at least 5 starts
df <- df %>% filter(Starts >= 5)

# Add Points, PPG, SoTA90, PSxG90, GAperxG
df <- df %>% mutate(Points = 3 * W + D,
                    PPG = Points / Starts,
                    SoTA90 = SoTA * 90 / Min,
                    PSxG90 = PSxG * 90 / Min,
                    PSxGD90 = PSxGD * 90 / Min,
                    GAperxG = GA / PSxG)

# Model using a measure of team defensive ability and a measure of goalkeeper shotstopping ability
ppg.basic <- lm(PPG ~ SoTA90 + SavePercent, data = df)  # Basic stats: SoTA90 and SavePercent
ppg.adv   <- lm(PPG ~ PSxG90 + GAperxG, data = df)      # Advanced stats: PSxG90 and GAperxG
ppg.adv2  <- lm(PPG ~ PSxG90 + PSxGD90, data = df)

# Models using defense only
ppg.basic.def <- lm(PPG ~ SoTA90, data = df)
ppg.adv.def   <- lm(PPG ~ PSxG90, data = df)



# See the contribution of various goalkeeper stats to defense
psxg.full <- lm(PSxG90 ~ I(LaunchCmp/LaunchAtt) + PassLaunchPercent + PassAvgLen + GKLaunchPercent + GKAvgLen + Thr + I(CrossStop/CrossAtt) + DefAvgDist, data = df)
psxg.aic  <- step(psxg.full, direction = "backward")