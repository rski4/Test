#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  2 17:18:22 2018

@author: noahpurcell
"""

### Verifying that teams from games17-18 are same teams as events17-18

games17 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2017Data//games2017.csv"
games18 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2018Data//games2018.csv"
events17 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2017Data//events2017.csv"
events18 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2018Data//events2018.csv"

import pandas as pd

def get_teams_from_games():
    data17 = pd.read_csv(games17)
    data18 = pd.read_csv(games18)
    data = pd.concat([data17,data18])
    vis_teams = set(data["visiting_team_long"])
    home_teams = set(data["home_team_long"])
    return vis_teams.union(home_teams)

def get_teams_from_events():
    data17 = pd.read_csv(events17)
    data18 = pd.read_csv(events18)
    data = pd.concat([data17,data18])
    vis_teams = set(data["visiting_team"])
    home_teams = set(data["home_team"])
    return vis_teams.union(home_teams)
