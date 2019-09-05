#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 10 15:28:49 2018

@author: noahpurcell
"""


import os
from bs4 import BeautifulSoup
import pandas as pd
#from random import randint
#import codecs
#from lxml import html


# global variables
#input_path = 'C:\Users\Chelsea\Dropbox\WebScrapeTutorial\IIAC_Scrape\html_files'
#output_path = 'C:\Users\Chelsea\Dropbox\WebScrapeTutorial\IIAC_Scrape'
#input_path = "//Users//noahpurcell//Desktop//IIAC_Scraping//2017Source//\\03f187a4-019c-45c1-b02e-a642099fd00f.html"
#output_path = "//Users//noahpurcell//Desktop//IIAC_Scraping//2017Data"


def main(input_path, f):
    out = open(f, "w")
    file_list = os.listdir(input_path)
    rows = list()
    error_files = 0
    
    with open(input_path + "//" + file_list[1]) as f:
        soup = BeautifulSoup(f, 'lxml')
        game_clean = get_game_info(soup)
        rows.append(game_clean)

    for file in file_list[2:]:
        print(file)
        try:          
            with open(input_path + "//" + file) as f:
                soup = BeautifulSoup(f, 'lxml')
                game_clean = get_game_info(soup)
                rows.append(game_clean)
        except:
            print("Error: " + file)
            error_files += 1
        
        if error_files > 10:
            break
    
    rows = pd.DataFrame(rows)
    rows.to_csv(out, encoding="utf-8", index=False)
            
    out.close()
    



def get_game_info(game):
    teams = {
         "buena vista": "BVU",
         "buena vista university": "BVU",
         "coe": "COE",
         "coe college": "COE",
         "cornell": "COR",
         "cornell college": "COR",
         "central": "CEN",
         "central college": "CEN",
         "university of dubuque": "DBQ",
         "dubuque": "DBQ",
         "luther": "LUT",
         "luther college": "LUT",
         "loras": "LOR",
         "loras college": "LOR",
         "nebraska wesleyan u.": "NWU",
         "nebraska wesleyan": "NWU",
         "nebraska wesleyan university": "NWU",
         "simpson": "SIM",
         "simpson college": "SIM",
         "wartburg": "WAR",
         "wartburg college": "WAR"
         }


    game_template = {
                 # "game_id": "", #wait until I have all games to assign
                 "date": "", #done
                 # "game_number":"", #wait until I have all games to assign
                 "start": "", #done
                 "visiting_team": "", #done
                 "home_team": "", #done
                 "visiting_team_long": "", #done
                 "home_team_long": "",#done
                 "site": "", #done
                 "visitor_starting_pitcher": "", #done
                 "home_starting_pitcher": "", #done
                 "umpires": "", #done
                 "time": "",  #done
                 "number_of_innings": "", #done
                 "visitor_line_score": "", #done
                 "home_line_score": "", #done
                 "visitor_final_score": "", #done
                 "home_final_score": "", #done
                 "visitor_hits": "", #done
                 "home_hits": "", #done
                 "visitor_errors": "", #done
                 "home_errors": "", #done
                 "winning_pitcher": "", #done
                 "losing_pitcher": "", #done
                 "save": "", #done
                 "visitor_batter_1": "", #done
                 "visitor_position_1": "", #done
                 "visitor_batter_2": "", #done
                 "visitor_position_2": "", #done
                "visitor_batter_3": "", #done
                "visitor_position_3": "", #done
                "visitor_batter_4": "", #done
                "visitor_position_4":"", #done
                "visitor_batter_5":"", #done
                "visitor_position_5":"", #done
                "visitor_batter_6":"", #done
                "visitor_position_6":"", #done
                "visitor_batter_7":"", #done
                "visitor_position_7":"", #done
                "visitor_batter_8":"", #done
                "visitor_position_8":"", #done
                "visitor_batter_9": "", #done
                "visitor_position_9":"", #done
                "home_batter_1": "", #done
                "home_position_1": "", #done
                "home_batter_2": "", #done
                "home_position_2": "", #done
                "home_batter_3": "", #done
                "home_position_3": "", #done
                "home_batter_4": "", #done
                "home_position_4": "", #done
                "home_batter_5": "", #done
                "home_position_5": "", #done
                "home_batter_6": "", #done
                "home_position_6": "", #done
                "home_batter_7": "", #done
                "home_position_7": "", #done
                "home_batter_8": "", #done
                "home_position_8": "", #done
                "home_batter_9": "", #done
                "home_position_9": "", #done
                "visitor_finishing_pitcher":"", #done
                "home_finishing_pitcher":"", #done
                "weather":"", #done
                "notes":"" #done
                }

    # game is a bs object
    game_row = game_template
    matchup = game.find("h1", {"class": "text-center text-uppercase hide-on-medium-down"}).get_text()
    matchup = matchup.split("-vs-")
    visitors = matchup[0].split("(")[0].strip(" ").lower()
    homers = matchup[1].split("(")[0].strip(" ").lower()
    game_row["visiting_team_long"] = visitors
    game_row["home_team_long"] = homers
    try:
        game_row["visiting_team"] = teams[visitors]
        game_row["home_team"] = teams[homers]
    except KeyError as e:
        print("Non-league Game")
    line_score = game.find("figure", {'class': "info-graphic logos-on-side relative"})
    game_row["number_of_innings"] = line_score.findAll("tr")[0].findAll("th")[-4].get_text()
    vis_line_score = line_score.findAll("tr")[1].get_text().split("\n")[5:-4]
    home_line_score = line_score.findAll("tr")[2].get_text().split("\n")[5:-4]
    for i in range(len(vis_line_score)):
        vis_line_score[i] = vis_line_score[i].strip()
        if len(vis_line_score[i]) == 2:
            vis_line_score[i] = "(" + vis_line_score[i] + ")"
    for i in range(len(home_line_score)):
        home_line_score[i] = home_line_score[i].strip()
        if len(home_line_score[i]) == 2:
            home_line_score[i] = "(" + home_line_score[i] + ")"
    
    game_row["visitor_line_score"] = "".join(vis_line_score)
    game_row["home_line_score"] = "".join(home_line_score)
    
    game_row["visitor_final_score"] = line_score.findAll("tr")[1].get_text().split("\n")[-4]
    game_row["home_final_score"] = line_score.findAll("tr")[2].get_text().split("\n")[-4]
    game_row["visitor_hits"] = line_score.findAll("tr")[1].get_text().split("\n")[-3]
    game_row["home_hits"] = line_score.findAll("tr")[2].get_text().split("\n")[-3]
    game_row["visitor_errors"] = line_score.findAll("tr")[1].get_text().split("\n")[-2]
    game_row["home_errors"] = line_score.findAll("tr")[2].get_text().split("\n")[-2]
    notable_pitchers = line_score.find("dl").get_text().split("\n")
    try:
        while "" in notable_pitchers:
            notable_pitchers.remove("")
        game_row["winning_pitcher"] = notable_pitchers[0][2:-6]
        game_row["losing_pitcher"] = notable_pitchers[1][2:-6]
    except:
        print("Can't find winning and losing pitchers.")
    if len(notable_pitchers) == 3:
        game_row["save"] = notable_pitchers[2][2:-4]
    details = game.find("aside").find("dl")
    dims,data = list(), list()
    for dt in details.findAll("dt"):
        dims.append(dt.get_text().lower())
    for dd in details.findAll("dd"):
        data.append(dd.get_text())
    for var, val in zip(dims,data):
        game_row[var] = val
    visitor_box = game.find("section", {"id":"box-score"}).findAll("section")[1].findAll("div", {"class":"large-6 mobile-12 columns"})[0].find("tbody")
    home_box = game.find("section", {"id":"box-score"}).findAll("section")[1].findAll("div", {"class":"large-6 mobile-12 columns"})[1].find("tbody")
    i = 1
    line_starts = ["l","1","c","r","d","3","2","s","c","p"]
    for player in visitor_box.findAll("tr"):
        line = player.find("th").get_text()
        batter = "visitor_batter_"
        position = "visitor_position_"
        if line[0].lower() in line_starts and i < 10:
            game_row[position+str(i)] = line.split(" ")[0]
            game_row[batter+str(i)] = " ".join(line.split(" ")[1:])
            i += 1
    i = 1
    for player in home_box.findAll("tr"):
        line = player.find("th").get_text()
        batter = "home_batter_"
        position = "home_position_"
        if line[0].lower() in line_starts and i < 10:
            game_row[position+str(i)] = line.split(" ")[0]
            game_row[batter+str(i)] = " ".join(line.split(" ")[1:])
            i += 1
    pitchers = game.find("section", {"id":"box-score"}).findAll("section")[2]
    
    game_row["visitor_starting_pitcher"] = pitchers.findAll("tbody")[0].findAll("tr")[0].find("th").get_text().split("(")[0].strip().strip(" ")
    game_row["home_starting_pitcher"] = pitchers.findAll("tbody")[1].findAll("tr")[0].find("th").get_text().split("(")[0].strip().strip(" ")
    game_row["visitor_finishing_pitcher"] = pitchers.findAll("tbody")[0].findAll("tr")[-1].find("th").get_text().split("(")[0].strip().strip(" ")
    game_row["home_finishing_pitcher"] = pitchers.findAll("tbody")[1].findAll("tr")[-1].find("th").get_text().split("(")[0].strip().strip(" ")

    if "(" in game_row["visitor_line_score"] or "(" in game_row["home_line_score"]:
        print(game_row)

    return game_row













