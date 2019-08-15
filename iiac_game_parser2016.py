#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  9 13:36:13 2018

@author: noahpurcell
"""

import os
import pandas as pd
from bs4 import BeautifulSoup
from iiac_game_parser_new import get_game_info


# NOTES

# don't want to read this file multiple times, so I resort to poor form with
# the global variable here
teams_lookup = dict()

def main(years):
    with open("//Users//noahpurcell//Desktop//IIAC_Scraping//iiac_teams.csv") as f:
        for line in f:
            line = line.split(",")
            teams_lookup[line[0]] = line[1]
    for year in years:
        get_year_games(year)


def get_year_games(year):
    path = "//Users//noahpurcell//Desktop//IIAC_Scraping//"
    in_path = path + str(year) + "Source//"
    out_path = path + str(year) + "Data//"
    rows = list()
    for file in os.listdir(in_path):
        if file == ".DS_Store":
            continue
        print(file)
        try:
            game_data = get_game_data(in_path+file)
            rows.append(game_data)
        except:
            with open(in_path+file) as f:
                soup = BeautifulSoup(f, 'lxml')
            game_data = get_game_info(soup)
            rows.append(game_data)
    
    data = pd.DataFrame(rows)
    data.to_csv(out_path + "games" + str(year) + ".csv", encoding='utf-8', na_rep='NA', index=False)


def get_game_data(game):
    game_template = {
             "date": "", #done
             "start": "", #done
             #"game_id": "", #done
             "game_number": "", #done # 1st or 2nd game of doubleheader
             "visiting_team": "", 
             "home_team": "", 
             "visiting_team_long": "", #done # as is in box score
             "home_team_long": "", # done # as is in box score 
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
            #"weather":"", #done
            "attendance":"", #done
            "notes":"", #done
            "play-by-play": "" #done # Y or N
            }
    
    game_info = game_template.copy()

    #game_info["game_id"] = game.strip(".html").replace(in_path, "")
    with open(game) as f:
        soup = BeautifulSoup(f, 'lxml')
        links = list()   # list of links on page
        for link in soup.findAll('a'):
            try:
                links.append(link.attrs['href'])
            except KeyError:
                print("No href in this a tag.")
        
        game_info["play-by-play"] = "Y" if "#GAME.PLY" in links else "N"
        
        #added for 2007
        # we want the GAME.NCA pre tag
        # cause it stacks lineups
        # it's either the first or second one
        if soup.find('a').attrs['href'] == "#GAME.BOX":
            box = soup.findAll('pre')[1].get_text()
        else:
            box = soup.find("pre").get_text()
    
    box = box.split("\n")
    box = [""] + box
    teams = box[2].strip()
    if len(teams.split(" vs ")) == 2:
        teams = teams.split(" vs ")
    else:
        teams = teams.split(" at ")
    if " (Game 1)" in teams[1]:
        teams[1] = teams[1].replace(" (Game 1)", "")
        game_info["game_number"] = 1
    elif " (Game 2)" in teams[1]:
        teams[1] = teams[1].replace(" (Game 2)", "")
        game_info["game_number"] = 2
    game_info["visiting_team_long"] = teams[0]
    game_info["home_team_long"] = teams[1]
    
    date_place = box[3].strip().split(" at ")
    game_info["date"] = date_place[0]
    game_info["site"] = date_place[1]
    # just gonna get the final scores from score by innings summary
#    print(date_place)
#    scores = box[5].strip()
#    print(scores)
#    vis_idx = scores.index(teams[0]) + len(teams[0]) + 1
#    home_idx = scores.index(teams[1]) + len(teams[1]) + 1
#    game_info["visitor_final_score"] = scores[vis_idx: vis_idx + 2].strip()
#    game_info["home_final_score"] = scores[home_idx: home_idx + 2].strip()
    
    vis_starting_lineup = list()
    home_starting_lineup = list()
    idx = 9  # where the lineup always starts
    
    # visitor lineup
    while box[idx][:6] != "Totals":  # stop at Totals
        # no one in any lineup has less than two dots separating name from stats
        # for 2003-2006
        player_pos = box[idx].split("..")
        # but in 2007 the do
        if len(player_pos) == 1:
            player_pos = box[idx].split(".")
        if player_pos[0][0] != " ":
            vis_starting_lineup.append(player_pos[0])
        idx += 1
    
    idx += 6 # skip down to home lineup
    
    # home lineup
    while box[idx][:6] != "Totals":  # stop at Totals
        player_pos = box[idx].split("..")
        if len(player_pos) == 1:
            player_pos = box[idx].split(".")
        if player_pos[0][0] != " ":
            home_starting_lineup.append(player_pos[0])
        idx += 1
            
#    while box[idx][:6] != "Totals":  # stop at Totals
#        line = box[idx].split("..")
#        if box[idx][0] != " ":
#            vis_starting_lineup.append(line[0])
#        for part in line:
#            # when home team has more players than visiting team
#            if " "*46 in part and " "*47 not in part:
#                plyr = part[part.index(" "*46) + 46:]
#                home_starting_lineup.append(plyr)
#            # when there are still home players and they aren't a sub
#            elif " "*7 in part and " "*8 not in part:
#                plyr = part[part.index(" "*7) + 7:]
#                home_starting_lineup.append(plyr)
#        idx += 1
    
    # figure out if there is a dh
    vis_dh, home_dh = False, False
    for vis_line, home_line in zip(vis_starting_lineup, home_starting_lineup):
        if "dh" in vis_line.split()[-1]:
            vis_dh = True
        if "dh" in home_line.split()[-1]:
            home_dh = True
    # at this point we have all of the players w/ their position
    # now we'll split player and position into proper column
    vis_i = 1
    home_i = 1
    for vis_line, home_line in zip(vis_starting_lineup, home_starting_lineup):
        vis_i, home_i = str(vis_i), str(home_i)
        # assuming no one is dhing for another position
        if vis_dh and vis_line.split()[-1] in ("p","p/dh"):
            # don't move the counter up this iteration
            # since pitcher is not really in the lineup
            vis_i = int(vis_i) - 1 
        else:
            game_info["visitor_position_"+vis_i] = vis_line.split()[-1]    
            game_info["visitor_batter_"+vis_i] = " ".join(vis_line.split()[:-1]) # the player
        
        if home_dh and home_line.split()[-1] in ("p","p/dh"):
            home_i = int(home_i) - 1
        else:
            game_info["home_position_"+home_i] = home_line.split()[-1]
            game_info["home_batter_"+home_i] = " ".join(home_line.split()[:-1])
        vis_i = int(vis_i) + 1
        home_i = int(home_i) + 1
    
    # using idx from above since it's always four lines after Totals line
    vis_score_summary = box[idx + 4]
    home_score_summary = box[idx + 5]
    vis_rhe = vis_score_summary.split("-")[-1].strip().split()
    home_rhe = home_score_summary.split("-")[-1].strip().split()
    game_info["visitor_final_score"] = vis_rhe[0] # added from 2002
    game_info["home_final_score"] = home_rhe[0] # added from 2002 
    game_info["visitor_hits"] = vis_rhe[1]
    game_info["home_hits"] = home_rhe[1]
    game_info["visitor_errors"] = vis_rhe[2]
    game_info["home_errors"] = home_rhe[2]
    
    vis_dash = vis_score_summary.rindex("-") - 1
    home_dash = home_score_summary.rindex("-") - 1
        
    vis_line_score = vis_score_summary[21:vis_dash].replace(" ", "")
    home_line_score = home_score_summary[21:home_dash].replace(" ", "")
    game_info["visitor_line_score"] = vis_line_score
    game_info["home_line_score"] = home_line_score
    game_info["number_of_innings"] = get_num_inns(vis_line_score)    
    
    # collect pitchers part of box score into a list
    pitchers = list()
    away_pitcher_found = False
    home_pitcher_found = False
    for line in box:
        if "IP  H  R ER BB SO AB BF" in line:
            if not(away_pitcher_found):
                away_pitcher_found = True
            else:
                home_pitcher_found = True
        if home_pitcher_found and line == "":
            break
        if away_pitcher_found:
            pitchers.append(line)
    # now get starting, finishing pitchers 
    dash_line_cntr = 0
    for i in range(len(pitchers)):
        if ("-" * 47) in pitchers[i]:
            if dash_line_cntr == 0: # first finding is vis starter
                vis_sp_idx = i + 1
                dash_line_cntr += 1
            else:
                home_sp_idx = i + 1
                
    game_info["visitor_starting_pitcher"] = " ".join(pitchers[vis_sp_idx].split()[:-8]).strip(".")
    game_info["home_starting_pitcher"] = " ".join(pitchers[home_sp_idx].split()[:-8]).strip(".")
    
    game_info["home_finishing_pitcher"] = " ".join(pitchers[-1].split()[:-8]).strip(".")
    game_info["visitor_finishing_pitcher"] = " ".join(pitchers[pitchers.index('') - 1].split()[:-8]).strip(".")
    
    #winning, losing pitchers and save    
    for line in reversed(box):
        if line[:5] == "Win -":
            line = line.split(".")
            game_info["winning_pitcher"] = line[0][6:]
            game_info["losing_pitcher"] = line[1].strip()[7:]
            save = line[2].strip()[7:]
            game_info["save"] = save if save != "None" else ""
#    pitchers = pitchers[2:pitchers.index('')] + pitchers[pitchers.index('') + 3:]
#    for i in range(len(pitchers)):
#        decision = pitchers[i].split()[-15]
#        if decision[i][0] == "W":
#            game_info["winning_pitcher"] = " ".join(pitchers[i].split()[:-15])
#        elif decision[i][0] == "L":
#            game_info["losing_pitcher"] = " ".join(pitchers[i].split()[:-15])
#        elif len(decision[i]) > 1 and decision[i][1] == "S":
#            game_info["save"] = " ".join(pitchers[i].split()[:-15])
            
    for line in reversed(box): # umpires are toward the end
        if line[:7] == "Umpires":
            start_line_idx = box.index(line) + 1 # start, time, attendance are on following line
            game_info["umpires"] = line.strip("Umpires - " )
            break
        
    start_line_idx = box.index(line) + 1
    start_line = box[start_line_idx]
    start_idx = start_line.index("Start: ") + 7
    time_str_idx = start_line.index("Time: ")
    time_end_idx = time_str_idx + 6
    att_str_idx = start_line.index("Attendance:")
    try:
        att_idx = att_str_idx + 12
    except:
        att_idx = -1
        
    game_info["start"] = start_line[start_idx:time_str_idx]
    game_info["time"] = start_line[time_end_idx:att_str_idx]
    game_info["attendance"] = start_line[att_idx:]
    
    for line in reversed(box):
        if "notes" in line.lower():
            idx = box.index(line) + 1 #get the line after "Game notes:"
            notes = box[idx] 
            idx += 1
            # and any lines after it which continue the notes
            while box[idx][:7].lower() != "weather" and box[idx][:5].lower() != "game:":
                notes += box[idx]
                idx += 1            
            game_info["notes"] = notes
            
# no weather in 2003 :(
#        if "weather" in line.lower():
#            # we have line with weather conditions
#            # split it on the dash
#            weather = line.split("-")[1]
#            game_info["weather"] = weather
    
    #tying teams from html to the base of names created
    #defaulting to the name as seen in html if it's an out of conference team
    #that wasn't seen in 2017-18
    vis_team = game_info["visiting_team_long"].lower()
    home_team = game_info["home_team_long"].lower()
    if vis_team in teams_lookup.keys():
        game_info["visiting_team"] = teams_lookup[vis_team]
    else:
        game_info["visiting_team"] = vis_team
    if home_team in teams_lookup.keys():
        game_info["home_team"] = teams_lookup[home_team]
    else:
        game_info["home_team"] = home_team
            
    return game_info
    


def get_num_inns(line_score):
    if "(" not in line_score:
        return len(line_score)
    paren_count = 0
    for char in line_score:
        if char == "(" or char == ")":
            paren_count += 1
    number_10_run_inns = paren_count / 2 #should always be integer
    #since 10 is two characters, need to subtract 1
    return len(line_score) - paren_count - number_10_run_inns

    
    