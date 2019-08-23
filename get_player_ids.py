#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct  6 15:42:07 2018

@author: noahpurcell
"""

import pandas as pd


events17 = "//Users//noahpurcell//Desktop//IIAC_Scraping//Test//events2017.csv"
events18 = "//Users//noahpurcell//Desktop//IIAC_Scraping//Test//events2018.csv"
events19 = "//Users//noahpurcell//Desktop//IIAC_Scraping//Test//events2019.csv"


def main():
    all_players = get_player_ids(events17)
    all_players += get_player_ids(events18)
    all_players += get_player_ids(events19)
    players_df = pd.DataFrame(all_players)
    players_df = players_df.drop_duplicates()
    players_df.to_csv("//Users//noahpurcell//Desktop//IIAC_Scraping//players.csv", encoding='utf-8', na_rep='NA', index=False)


def get_player_ids(f):
    batters, pitchers = list(), list()
    player_row = {
                    "team": "",
                    "playerID": "",
                    "full": ""}
    
    data = pd.read_csv(f)
    
#    data = all_data[["batter", "batter_last_name", "pitcher", "pitcher_last_name",
#                 "top_or_bot", "visiting_team_clean", "home_team_clean"]]
    
#    data["visiting_team_one_word"] = data["visiting_team_clean"].apply(get_one_word_team)
#    data["home_team_one_word"] = data["home_team_clean"].apply(get_one_word_team)

    for i in range(data.shape[0]):
        if pd.notnull(data.iloc[i]["batter"]) and pd.notnull(data.iloc[i]["batter_last_name"]):
            batter = player_row.copy()
            if data.iloc[i]["top_or_bot"] == "top":
                batter["team"] = data.iloc[i]["visiting_team_clean"]
            elif data.iloc[i]["top_or_bot"] == "bottom":
                batter["team"] = data.iloc[i]["home_team_clean"]
            if batter["team"]:
                batter["playerID"] = str("".join(batter["team"].split())) + str(data.iloc[i]["batter_last_name"])
                batter["full"] = data.iloc[i]["batter"]
            batters.append(batter)
        else:
            batters.append(player_row)
            
        if pd.notnull(data.iloc[i]["pitcher"]) and pd.notnull(data.iloc[i]["pitcher_last_name"]):
            pitcher = player_row.copy()
            if data.iloc[i]["top_or_bot"] == "bottom":
                pitcher["team"] = data.iloc[i]["visiting_team_clean"]
            elif data.iloc[i]["top_or_bot"] == "top":
                pitcher["team"] = data.iloc[i]["home_team_clean"]
            if pitcher["team"]:
                pitcher["playerID"] = str("".join(pitcher["team"].split())) + str(data.iloc[i]["pitcher_last_name"])
                pitcher["full"] = data.iloc[i]["pitcher"]
            pitchers.append(pitcher)
        else:
            pitchers.append(player_row)
    
    batters_df = pd.DataFrame(batters)
    pitchers_df = pd.DataFrame(pitchers)

    # change this statement to current year
    if f == events19:    
        data["batterID"] = batters_df["playerID"]
        data["pitcherID"] = pitchers_df["playerID"]
        data.to_csv("//Users//noahpurcell//Desktop//IIAC_Scraping//Test//events2019.csv", encoding='utf-8', na_rep='NA', index=False)
    
    players = batters + pitchers
    players = [players[i] for i in range(len(players)) if players[i] != player_row]
    
    return players
    
    
    

#def get_one_word_team(x):
#    if " " in x:
#        return "".join(x.split())
#    else:
#        return x