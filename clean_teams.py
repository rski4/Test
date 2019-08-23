#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  2 23:35:18 2018

@author: noahpurcell
"""

### Get player ids
import pandas as pd
import numpy as np

#games17 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2017Data//games2017.csv"
#games18 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2018Data//games2018.csv"
#events17 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2017Data//events2017.csv"
#events18 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2018Data//events2018.csv"

events19 = "//Users//noahpurcell//Desktop//IIAC_Scraping//Test//events2019.csv"

teams_f = "//Users//noahpurcell//Desktop//IIAC_Scraping//Test//iiac_teams.csv"

out = "//Users//noahpurcell//Desktop//IIAC_Scraping//Test//events2019.csv"


def get_clean_teams():
    teams_dict = dict()
    
    with open(teams_f,'r') as f:
        for line in f:
            line = line.strip()
            line = line.split(",")
            if len(line) > 2:
                teams_dict['dubuque, univ. of'] = line[2]
            else:
                teams_dict[line[0]] = line[1]
    
    return teams_dict


def add_clean_teams(in_f, out_f):
    teams_ = get_clean_teams()
    data = pd.read_csv(in_f)
    data["visiting_team_clean"] = data.apply(teams_to_cols, args=("visiting_team",teams_), axis=1)
    data["home_team_clean"] = data.apply(teams_to_cols, args=("home_team",teams_), axis=1)
    
    data.to_csv(out_f, encoding='utf-8', index=False)    
    
    
    
def teams_to_cols(row, team, teams):
    if pd.isnull(row[team]):
        return np.nan
#    elif row[team] == "concordia":
#        if row["date"] in ("3/17/2017","3/19/2017","3/7/2018"):
#            name = teams[row[team]].split()[0]
#            name += " " + teams[row[team]].split("/")[1]
#            return name
#        elif row["date"] == "3/8/2018":
#            return "concordia university chicago"
#        elif row["date"] == "3/14/2018":
#            return teams[row[team]].split("/")[0]
#        else:
#            print(row["date"])
#            return row[team]
    if row[team] in teams.keys():
        return teams[row[team]]
    return row[team]
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    