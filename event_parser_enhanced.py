#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jun 17 16:31:19 2018

@author: noahpurcell
"""

import pandas as pd
import os
from bs4 import BeautifulSoup

input_path = "//Users//noahpurcell//Desktop//IIAC_Scraping//2019Source"


event_code = {
              "unknown event": 0,  
              "no event": 1,
              "generic out": 2,
              "strikeout": 3,
              "stolen base": 4,
              "defensive indifference": 5,
              "caught stealing": 6,
              "pickoff error": 7,
              "pickoff": 8,
              "wild pitch": 9,
              "passed ball": 10,
              "balk": 11,
              "other advance": 12,
              "foul error": 13,
              "walk": 14,
              "intentional walk": 15,
              "hit by pitch": 16,
              "interference": 17,
              "error": 18,
              "fielder's choice":19,
              "single": 20,
              "double": 21,
              "triple": 22,
              "home run": 23,
              "missing play": 24}


def main():
    out = open("//Users//noahpurcell//Desktop//IIAC_Scraping//events2019.csv", "w")
    file_list = os.listdir(input_path)
    rows = list()
    error_files = 0
    good_files = 0
    
    with open(input_path + "//" + file_list[1]) as f:
        print(file_list[1])
        soup = BeautifulSoup(f, 'lxml')
        game_clean = get_events(soup)
        rows += (game_clean)

    file_num = 2
    for file in file_list[2:]:
        print(file_num)
        print(file)
        try:          
            with open(input_path + "//" + file) as f:
                soup = BeautifulSoup(f, 'lxml')
                game_clean = get_events(soup)
                rows += game_clean
            good_files += 1
        except:
            print("Error: " + file)
            error_files += 1
        file_num += 1
        
    print("good: ", good_files)
    print("bad", error_files)
    
    rows = pd.DataFrame(rows)
#    test_rows = rows[["event_text", "batter_dest", "first_runner", "first_runner_last_name", "runner_on_1st_dest",
#                     "second_runner", "second_runner_last_name", "runner_on_2nd_dest", "third_runner", "third_runner_last_name", "runner_on_3rd_dest"]]
    rows.to_csv(out, encoding='utf-8', index=False)
            
    out.close()
    
    return None


def get_events(game):
    event_template = {
                 # first four things identify the game
                "start": "", #done
                "date": "", #done
                "visiting_team" : "", #done
                "home_team": "", #done
                "inning" : "", #done
                "batting_team" : "", #done
                "top_or_bot": "",
                "outs" : 0, #done
                "balls" : "",
                "strikes" : "",
                "pitch_sequence" : "",
                "vis_score" : "", #done
                "home_score" : "", #done
                "batter_last_name": "", #done (should connecting the play-by-play name to the box score name fail)
                "batter" : "", #done (need to shore up substitutions, but I got full name woooooo)
#                "batter_hand" : "",
#                "res_batter" : "",
#                "res_batter_hand" : "",
                "pitcher" : "", # done
#                "pitcher_hand" : "",
#                "res_pitcher" : "",
#                "res_pitcher_hand" : "",
                "catcher" : "", #done
                "first_base" : "", #done
                "second_base" : "", #done
                "third_base" : "", #done
                "shortstop" : "", #done
                "left_field" : "", #done
                "center_field" : "", #done
                "right_field" : "", #done
                "designated_hitter": "", #done
                "first_runner" : "", #done
                "second_runner" : "", #done
                "third_runner" : "", #done
                "first_runner_last_name": "", #done
                "second_runner_last_name": "", #done
                "third_runner_last_name": "", #done
                "event_text" : "", #done
                "leadoff_flag" : 1, #done #first batter of inning
                "pinchhit_flag" : 0, #done
                "defensive_position" : "", #done
                "lineup_position" : "", #done
                "event_type" : "", #done
                "event_type_int": 0, #done
                "batter_event_flag" : 1, #done #1 or 0 whether event ended plate appearance
                "ab_flag" : 0, #done
                "hit_value" : "", #done
                "SH_flag" : 0, #done
                "SF_flag" : 0, #done
                "outs_on_play" : 0, #done
                "double_play_flag" : "", #done
                "triple_play_flag" : "", #done
                "RBI_on_play" : 0, #done
                "wild_pitch_flag" : 0, #done
                "passed_ball_flag" : 0, #done
                "fielded_by" : "", #done
                "batted_ball_type" : "", #done #Descriptor which is either F (fly ball), L(line drive), P (pop-up), or G (ground ball).
                "bunt_flag" : 0, 
                "foul_flag" : 0, #done
                "hit_location" : "", #done
                "num_errors" : 0, #done # limit 3 errors per play
                "1st_error_position" : "", #done
                "1st_error_type" : "", #done
                "2nd_error_position" : "", #done
                "2nd_error_type" : "", #done
                "3rd_error_position" : "", #done
                "3rd_error_type" : "", #done
                "batter_dest" : "", #done #if out then 0, not doing 5 unearned 6 team unearned whatever tf that means
                "runner_on_1st_dest" : "", #done 
                "runner_on_2nd_dest" : "", #done
                "runner_on_3rd_dest" : "", #done
#                "play_on_batter" : "",
#                "play_on_runner_on_1st" : "",
#                "play_on_runner_on_2nd" : "",
#                "play_on_runner_on_3rd" : "",
                "SB_for_runner_on_1st_flag" : 0, #done
                "SB_for_runner_on_2nd_flag" : 0, #done
                "SB_for_runner_on_3rd_flag" : 0, #done
                "CS_for_runner_on_1st_flag" : 0, #done
                "CS_for_runner_on_2nd_flag" : 0, #done
                "CS_for_runner_on_3rd_flag" : 0, #done
                "PO_for_runner_on_1st_flag" : 0,         #pickoff not putout :)
                "PO_for_runner_on_2nd_flag" : 0,
                "PO_for_runner_on_3rd_flag" : 0,
#                "Responsible_pitcher_for_runner_on_1st" : "",
#                "Responsible_pitcher_for_runner_on_2nd" : "",
#                "Responsible_pitcher_for_runner_on_3rd" : "",
                "New_Game_Flag" : 0, #done
                "End_Game_Flag" : 0,
                "Pinch-runner_on_1st" : 0, #done
                "Pinch-runner_on_2nd" : 0, #done
                "Pinch-runner_on_3rd" : 0, #done
                "Runner_removed_for_pinch-runner_on_1st" : "", #done
                "Runner_removed_for_pinch-runner_on_2nd" : "", #done
                "Runner_removed_for_pinch-runner_on_3rd" : "", #done
                "Batter_removed_for_pinch-hitter" : "", #done
                "Position_of_batter_removed_for_pinch-hitter" : "", #done
#                "Fielder_with_First_Putout_(0_if_none)" : "",
#                "Fielder_with_Second_Putout_(0_if_none)" : "",
#                "Fielder_with_Third_Putout_(0_if_none)" : "",
#                "Fielder_with_First_Assist_(0_if_none)" : "",
#                "Fielder_with_Second_Assist_(0_if_none)" : "",
#                "Fielder_with_Third_Assist_(0_if_none)" : "",
#                "Fielder_with_Fourth_Assist_(0_if_none)" : "",
#                "Fielder_with_Fifth_Assist_(0_if_none)" : "",
                "event_num" : "", #done #events are numbered consecutively
            }
    
# PROBLEMS
#
# add ball strike stuff for Coe games
# finish checking runners (but I think we are good)
# check out plays that say interference
    
# NOTES
#
#
    
    
    pa_ended = ['reached', 'struck', 'intentionally walked', 'grounded', 'flied', 'popped', 
                'walked', 'singled', 'doubled', 
                'tripled', 'homered', 'walked', 'lined', 
                'hit by pitch', 'fouled', "catcher's interference",
                "infield fly"]
    pa_not_ended = ["advanced", "stole", "scored", "caught stealing", "picked off"]
    runner_only = False
    details = game.find("aside", {"class": "game-details"}).find('dl').findAll("dd")
    matchup = game.find("h1", {"class": "text-center text-uppercase hide-on-medium-down"}).get_text().split("-vs-")
    event_template["date"] = details[0].get_text()
    event_template["start"] = details[1].get_text()
    event_template["visiting_team"] = matchup[0].split("(")[0].strip(" ").lower()
    event_template["home_team"] = matchup[1].split("(")[0].strip(" ").lower()

    # idea is to run a while loop with pitcher = starter until a substitution occurs
    # might be an if statement actually
#    pitchers = game.find("section", {"id":"box-score"}).findAll("section")[2]
#    visitor_pitcher = pitchers.findAll("tbody")[0].findAll("tr")[0].find("th").get_text().split("(")[0].strip().strip(" ")
#    home_pitcher = pitchers.findAll("tbody")[1].findAll("tr")[0].find("th").get_text().split("(")[0].strip().strip(" ")
    visitor_box = game.find("section", {"id":"box-score"}).findAll("section")[1].findAll("div", {"class":"large-6 mobile-12 columns"})[0].find("tbody")
    home_box = game.find("section", {"id":"box-score"}).findAll("section")[1].findAll("div", {"class":"large-6 mobile-12 columns"})[1].find("tbody")
    vis_players = list()
    home_players = list()
    for man in visitor_box.findAll("tr"):
        line = man.find("th").get_text()
        line = line.replace("\xa0", "")
        line = line.split()
        vis_players.append(" ".join(line[1:]))
    for man in home_box.findAll("tr"):
        line = man.find("th").get_text()
        line = line.replace("\xa0", "")
        line = line.split()
        home_players.append(" ".join(line[1:]))
        
    # start with starting lineup, then rely on play-by-play for subs
    vis_lineup = {"c": "",
                   "1b": "", 
                   "2b": "",
                   "3b": "",
                   "ss": "",
                   "lf": "",
                   "cf": "",
                   "rf": "",
                   "dh": "",
                   "p": ""}
    home_lineup = vis_lineup.copy()
    for man in visitor_box.findAll("tr"):
        line = man.find("th").get_text()
        if line[0:4] != "\xa0\xa0\xa0\xa0":
            line = line.split()
            #lineup[position] = player
            if "/" in line[0].lower():
                vis_lineup[line[0].lower().split("/")[0]] = " ".join(line[1:])
            else:
                vis_lineup[line[0].lower()] = " ".join(line[1:])
    for man in home_box.findAll("tr"):
        line = man.find("th").get_text()
        if line[0:4] != "\xa0\xa0\xa0\xa0":
            line = line.split()
            if "/" in line[0].lower():
                home_lineup[line[0].lower().split("/")[0]] = " ".join(line[1:])
            else:
                home_lineup[line[0].lower()] = " ".join(line[1:])
    
#    print("vis lineup:", vis_lineup)
#   print("home lineup:", home_lineup)
#    print(vis_players)
    vis_lineup_cntr = 0
    home_lineup_cntr = 0
    event_cntr = 0
    vis_score = 0
    home_score = 0
    play_list = list()
    hits_lst = ["single", "double", "triple", "home run"]
    innings = game.find('div', {'id': 'inning-all', 'class':'no-print ui-tabs-panel ui-widget-content ui-corner-bottom'})
    for half_inning in innings.findAll('div', {'class':'row pad'}):
        team_inn = half_inning.find("caption").get_text().split("-")
#        print(team_inn)
        bat_team = team_inn[0]
        inn = team_inn[-1].split("of")[1].strip(" ")
        inn = inn[:-2]
        top_or_bot = team_inn[1].split("of")[0].strip(" ").lower()
        event = event_template.copy() # want to update some things between innings
        event["batting_team"] = bat_team # inning stays
        event["inning"] = inn
        event["top_or_bot"] = top_or_bot
        event["outs"] = 0
        event["vis_score"] = vis_score
        event["home_score"] = home_score
        for play in half_inning.findAll('tr')[1:]:
            try:
#                print(event["event_num"])
                if half_inning == innings.findAll('div', {'class': 'row pad'})[-1] and play == half_inning.findAll('tr')[-1]:
                    event["End_Game_Flag"] = 1
                play_attrs = play.find('th').attrs
                if 'class' in play_attrs and play_attrs['class'] == ["text-italic"]:
                    text = play.find('th').get_text()
                    if text == "Slodzinski pinch ran for Ventrelle.":
                        continue
                    if "ejected" in text:
                        continue
#                    print("sub:" ,text)
                    # just ignoring anything that looks like this '/ for Carey'
                    if "/" in text:
                        continue
                    sub = text.strip(".").split()
                    if "pinch hit" in text:
                        event["pinchhit_flag"] = 1
                        current_bat_clause = text.split()
                        if top_or_bot == "top":
                            cur_bat = get_full_name(vis_players, " ".join(current_bat_clause[:-1]), "pinch")[0]
#                            print(cur_bat)
                            removed_bat = get_full_name(vis_players, text.split("for")[1].strip(" ."), "$")[0]
                        else:
                            cur_bat = get_full_name(home_players, " ".join(current_bat_clause[:-1]), "pinch")[0]
                            removed_bat = get_full_name(home_players, text.split("for")[1].strip(" ."), "$")[0]                 
                        event["Batter_removed_for_pinch-hitter"] = removed_bat
                        if top_or_bot == "top":
                            for dude in vis_lineup.values():
#                                print(dude)
                                if cur_bat == dude:
                                    event["pinchhit_flag"] = 0
                                    break
                            if event["pinchhit_flag"] == 1:
                                event["Position_of_batter_removed_for_pinch-hitter"] = list(vis_lineup.keys())[list(vis_lineup.values()).index(get_full_name(vis_players, removed_bat, "$")[0])]
                                vis_lineup[event["Position_of_batter_removed_for_pinch-hitter"]] = get_full_name(vis_players, cur_bat, "$")[0]
                        else:
                            for dude in home_lineup.values():
                                if cur_bat == dude:
                                    event["pinchhit_flag"] = 0
                                    break
                            if event["pinchhit_flag"] == 1:
                                event["Position_of_batter_removed_for_pinch-hitter"] = list(home_lineup.keys())[list(home_lineup.values()).index(get_full_name(home_players, removed_bat, "$")[0])]
                                home_lineup[event["Position_of_batter_removed_for_pinch-hitter"]] = get_full_name(home_players, cur_bat, "$")[0]
                    elif "pinch ran" in text:
#                        print("in this shit")
                        if top_or_bot == "top":
                            base, removed, cur_runner = get_pinch_ran_for_stuff(event["first_runner_last_name"], event["second_runner_last_name"], event["third_runner_last_name"], text, vis_players)
                        else:
                            base, removed, cur_runner = get_pinch_ran_for_stuff(event["first_runner_last_name"], event["second_runner_last_name"], event["third_runner_last_name"], text, home_players)
                        if base == 1:
                            event["Pinch-runner_on_1st"] = 1
                            event["Runner_removed_for_pinch-runner_on_1st"] = removed
                            event["first_runner"] = cur_runner
                        elif base == 2:
                            event["Pinch-runner_on_2nd"] = 1
                            event["Runner_removed_for_pinch-runner_on_2nd"] = removed
                            event["second_runner"] = cur_runner
                        elif base == 3:
                            event["Pinch-runner_on_3rd"] = 1
                            event["Runner_removed_for_pinch-runner_on_3rd"] = removed
                            event["third_runner"] = cur_runner  
                        if len(removed) > 2:
                            if top_or_bot == "top":
                                fullname_removed = get_full_name(vis_players, removed, "$")[0]
                                pos = list(vis_lineup.keys())[list(vis_lineup.values()).index(fullname_removed)]
                                fullname_current = get_full_name(vis_players, cur_runner, "$")[0]
                                vis_lineup[pos] = fullname_current
                            else:
                                fullname_removed = get_full_name(home_players, removed, "$")[0]
                                pos = list(home_lineup.keys())[list(home_lineup.values()).index(fullname_removed)]
                                fullname_current = get_full_name(home_players, cur_runner, "$")[0]
                                home_lineup[pos] = fullname_current                                    
                    # defensive substitutions here:
                    elif sub[1] == "to":
                        # defensive subs happen in top for home, bot for away
                        # making an exception for dh because of game 1
                        if top_or_bot == "top":                      
                            if " dh " in text:
                                vis_lineup[sub[2]] = get_full_name(vis_players, sub[0], "$")[0]
                            else:    
                                the_sub = get_full_name(home_players, sub[0], "$")[0]
                                if the_sub != "Could not find":
                                    home_lineup[sub[2]] = the_sub
                                else:
                                    the_sub = get_full_name(vis_players, sub[0], "$")[0]
                                    vis_lineup[sub[2]] = the_sub
                        else:
                            if " dh " in text:
                                home_lineup[sub[2]] = get_full_name(home_players, sub[0], "$")[0]
                            else:
                                the_sub = get_full_name(vis_players, sub[0], "$")[0]
                                if the_sub != "Could not find":
                                    vis_lineup[sub[2]] = the_sub
                                else:
                                    the_sub = get_full_name(home_players, sub[0], "$")[0]
                                    home_lineup[sub[2]] = the_sub
                    elif sub[2] == "to":
                        # defensive subs happen in top for home, bot for away
                        # making an exception for dh because of game 1
                        if top_or_bot == "top":                      
                            if " dh " in text:
                                vis_lineup[sub[3]] = get_full_name(vis_players, " ".join(sub[0:1]), "$")[0]
                            else:    
                                the_sub = get_full_name(home_players, " ".join(sub[0:1]), "$")[0]
                                if the_sub != "Could not find":
                                    home_lineup[sub[3]] = the_sub
                                else:
                                    the_sub = get_full_name(vis_players, " ".join(sub[0:1]), "$")[0]
                                    vis_lineup[sub[3]] = the_sub
                        else:
                            if " dh " in text:
                                home_lineup[sub[3]] = get_full_name(home_players, sub[0:1], "$")[0]
                            else:
                                the_sub = get_full_name(vis_players, " ".join(sub[0:1]), "$")[0]
                                if the_sub == "Nick Henrichs":
                                    the_sub = "Could not find"
                                if the_sub != "Could not find":
                                    vis_lineup[sub[3]] = the_sub
                                else:
                                    the_sub = get_full_name(home_players, " ".join(sub[0:1]), "$")[0]
                                    home_lineup[sub[3]] = the_sub
                        if text == "Imrich, T to cf.":
                            vis_lineup["lf"] = "Nasir Ricks"
                
    
                else:
                    #fielders (pitchers too)
                    if top_or_bot == "top":  #away    #rolling w/ separating home/away for now
                        event["pitcher"] = home_lineup["p"]
                        event["catcher"] = home_lineup["c"]      
                        event["first_base"] = home_lineup["1b"]
                        event["second_base"] = home_lineup["2b"]
                        event["third_base"] = home_lineup["3b"]
                        event["shortstop"] = home_lineup["ss"]
                        event["left_field"] = home_lineup["lf"]
                        event["center_field"] = home_lineup["cf"]
                        event["right_field"] = home_lineup["rf"]
                        event["designated_hitter"] = home_lineup["dh"]                    
                        play_text = play.find('th').get_text()
#                        print("vis:", play_text)
                        if "ejected" in play_text:
                            continue
                        event["event_text"] = play_text
                        event["outs_on_play"] = 3 if is_triple_play(play_text) else 2 if is_double_play(play_text) else 0
                        event["double_play_flag"] = is_double_play(play_text)
                        event["triple_play_flag"] = is_triple_play(play_text)
                        if ("out" in play_text or "popped up" in play_text) and not(is_double_play(play_text)): #
                            event["outs_on_play"] = 1
                        if "(" in play_text and ")" in play_text:
                            balls, strikes, pitch_seq = get_ball_strike(play_text)
                            event["balls"] = balls
                            event["strikes"] = strikes
                            event["pitch_sequence"] = pitch_seq
                        event["SH_flag"] = is_sac_hit(play_text)
                        event["SF_flag"] = is_sac_fly(play_text)
                        event["foul_flag"] = is_foul_ball(play_text)
    #     return min(num_errors, 3), pos_1, pos_2, pos_3, type_1, type_2, type_3
                        errors, posi1, posi2, posi3, typo1, typo2, typo3 = get_errors(play_text)
                        event["num_errors"] = errors
                        event["1st_error_position"] = posi1
                        event["2nd_error_position"] = posi2
                        event["3rd_error_position"] = posi3
                        event["1st_error_type"] = typo1
                        event["2nd_error_type"] = typo2
                        event["3rd_error_type"] = typo3
                        sb1, sb2, sb3 = stolen_base_flags(play_text)
                        event["SB_for_runner_on_1st_flag"] = sb1
                        event["SB_for_runner_on_2nd_flag"] = sb2
                        event["SB_for_runner_on_3rd_flag"] = sb3
                        cs1, cs2, cs3 = caught_stealing_flags(play_text)
                        event["CS_for_runner_on_1st_flag"] = cs1
                        event["CS_for_runner_on_2nd_flag"] = cs2
                        event["CS_for_runner_on_3rd_flag"] = cs3
                        event["PO_for_runner_on_1st_flag"] = picked_off_first(play_text)
                        event["PO_for_runner_on_2nd_flag"] = picked_off_second(play_text)
                        event["PO_for_runner_on_3rd_flag"] = picked_off_third(play_text)
                        event_cntr +=1
                        event["New_Game_Flag"] = 0 if event_cntr != 1 else 1
                        event["event_num"] = event_cntr
                        play_elements = play_text.split(";") #batter is usually first clause
                        # this is the batter 'clause' of the sentence
                        for verb in pa_not_ended:
                            if verb in play_elements[0]: #runner only event (passed ball, caught stealing, etc.)
                                if "reached" not in play_elements[0] and "singled" not in play_elements[0]:
                                    if "doubled" not in play_elements[0] and "tripled" not in play_elements[0]:
                                        event["batter_event_flag"] = 0 #defaults to 1
                                        if verb == "advanced":
                                            if "wild pitch" in play_text.lower():
                                                event["wild_pitch_flag"] = 1
                                            elif "passed ball" in play_text.lower():
                                                event["passed_ball_flag"] = 1
                                        runner_only = True
                                        break
                        if runner_only:
                            if play != half_inning.findAll('tr')[1:][-1]:
                                j = 1
                                next_play = half_inning.findAll('tr')[1:][half_inning.findAll('tr')[1:].index(play) + j]
                                next_play_text = next_play.find('th').get_text()
                                next_play_attrs = next_play.find('th').attrs
                                while 'class' in next_play_attrs and next_play_attrs['class'] == ["text-italic"] and "/" not in next_play_text:
                                    # just ignoring anything that looks like this '/ for Carey' with last criteria
                                    sub = next_play_text.split()
                                    if "pinch hit" in next_play_text:
                                        event["pinchhit_flag"] = 1
                                        current_bat_clause = next_play_text.split()
                                        if top_or_bot == "top":
                                            cur_bat = get_full_name(vis_players, " ".join(current_bat_clause[:-1]), "pinch")[0]
                                            removed_bat = get_full_name(vis_players, next_play_text.split("for")[1].strip(" ."), "$")[0]
                                        else:
                                            cur_bat = get_full_name(home_players, " ".join(current_bat_clause[:-1]), "pinch")[0]
                                            removed_bat = get_full_name(home_players, next_play_text.split("for")[1].strip(" ."), "$")[0]                 
                                        event["Batter_removed_for_pinch-hitter"] = removed_bat
                                        if top_or_bot == "top":
                                            for dude in vis_lineup.values():
                                                if cur_bat == dude:
                                                    event["pinchhit_flag"] = 0
                                                    break
                                            if event["pinchhit_flag"] == 1:
                                                event["Position_of_batter_removed_for_pinch-hitter"] = list(vis_lineup.keys())[list(vis_lineup.values()).index(get_full_name(vis_players, removed_bat, "$")[0])]
                                                vis_lineup[event["Position_of_batter_removed_for_pinch-hitter"]] = get_full_name(vis_players, cur_bat, "$")[0]
                                        else:
                                            for dude in home_lineup.values():
                                                if cur_bat == dude:
                                                    event["pinchhit_flag"] = 0
                                                    break
                                            if event["pinchhit_flag"] == 1:
                                                event["Position_of_batter_removed_for_pinch-hitter"] = list(home_lineup.keys())[list(home_lineup.values()).index(get_full_name(home_players, removed_bat, "$")[0])]
                                                home_lineup[event["Position_of_batter_removed_for_pinch-hitter"]] = get_full_name(home_players, cur_bat, "$")[0]
                                    elif "pinch ran" in next_play_text:
                                        base, removed, cur_runner = get_pinch_ran_for_stuff(event["first_runner_last_name"], event["second_runner_last_name"], event["third_runner_last_name"], next_play_text, vis_players)
                                        if base == 1:
                                            event["Pinch-runner_on_1st"] = 1
                                            event["Runner_removed_for_pinch-runner_on_1st"] = removed
                                            event["first_runner"] = cur_runner
                                        elif base == 2:
                                            event["Pinch-runner_on_2nd"] = 1
                                            event["Runner_removed_for_pinch-runner_on_2nd"] = removed
                                            event["second_runner"] = cur_runner
                                        elif base == 3:
                                            event["Pinch-runner_on_3rd"] = 1
                                            event["Runner_removed_for_pinch-runner_on_3rd"] = removed
                                            event["third_runner"] = cur_runner  
                                        if len(removed) > 2:
                                            if top_or_bot == "top":
                                                fullname = get_full_name(vis_players, removed, "$")[0]
                                                pos = list(vis_lineup.keys())[list(vis_lineup.values()).index(fullname)]
                                                vis_lineup[pos] = fullname
                                            else:
                                                fullname = get_full_name(home_players, removed, "$")[0]
                                                pos = list(home_lineup.keys())[list(home_lineup.values()).index(fullname)]
                                                home_lineup[pos] = fullname
                                    # defensive substitutions here:
                                    elif sub[1] == "to":
                                        # defensive subs happen in top for home, bot for away
                                        # making an exception for dh because of game 1
                                        if top_or_bot == "top":                      
                                            if " dh " in text:
                                                vis_lineup[sub[2]] = get_full_name(vis_players, sub[0], "$")[0]
                                            else:                            
                                                home_lineup[sub[2]] = get_full_name(home_players, sub[0], "$")[0]
                                        else:
                                            if " dh " in text:
                                                home_lineup[sub[2]] = get_full_name(home_players, sub[0], "$")[0]
                                            else:
                                                vis_lineup[sub[2]] = get_full_name(vis_players, sub[0], "$")[0]
                                    j += 1
                                    next_play = half_inning.findAll('tr')[1:][half_inning.findAll('tr')[1:].index(play) + j]
                                    next_play_text = next_play.find('th').get_text()
                                    next_play_attrs = next_play.find('th').attrs
                            else:  #if the play ends the inning
                                lineup_with_indents = list()
                                for player in visitor_box.findAll('tr'):
                                    player = player.find('th').get_text()
                                    lineup_with_indents.append(player)
                                lineup_with_indents += lineup_with_indents
                                for player in lineup_with_indents:
                                    if event["batter"] in player:
                                        current_batter = lineup_with_indents[lineup_with_indents.index(player) + 1]
                                        potential_current_batter = lineup_with_indents[lineup_with_indents.index(player) + 2]
                                        break
                                while potential_current_batter[:4] == "\xa0\xa0\xa0\xa0" or current_batter[0] == "p" or current_batter[:5] == "\xa0\xa0\xa0\xa0p":
                                    current_batter = potential_current_batter
                                    potential_current_batter = lineup_with_indents[lineup_with_indents.index(current_batter) + 1]
                                current_batter = current_batter.strip()
                                current_batter = " ".join(current_batter.split()[1:])
                                event["batter"] = current_batter
                                full = event["batter"]
                            # if we skip over loop, then a  batter event occurred right after
                            try:
                                next_play_elements = next_play_text.split(";")
                            except:
                                next_play_elements = [""]
                            # what happens if next play was also a runner only event
                            next_runner_only = False
                            for verb in pa_not_ended:
                                if verb in next_play_elements[0]: #runner only event (passed ball, caught stealing, etc.)
                                    if "reached" not in next_play_elements[0] and "singled" not in next_play_elements[0]:
                                        if "doubled" not in next_play_elements[0] and "tripled" not in next_play_elements[0]:
                                            event["batter_event_flag"] = 0 #defaults to 1
                                            next_runner_only = True
                                            break
                            while next_runner_only == True:
                                next_runner_only = False
                                j += 1
                                next_play = half_inning.findAll('tr')[1:][half_inning.findAll('tr')[1:].index(play) + j]
                                next_play_text = next_play.find('th').get_text()
                                for verb in pa_not_ended:
                                    if verb in next_play_elements[0]: #runner only event (passed ball, caught stealing, etc.)
                                        if "reached" not in next_play_elements[0] and "singled" not in next_play_elements[0]:
                                            if "doubled" not in next_play_elements[0] and "tripled" not in next_play_elements[0]:
                                                event["batter_event_flag"] = 0 #defaults to 1
                                                runner_only = True
                                next_play_elements = next_play_text.split(";")
                            if play != half_inning.findAll('tr')[1:][-1]:
                                for verb in pa_ended:
                                    if verb in next_play_elements[0]:
                                        full, last = get_full_name(vis_players, next_play_elements[0], verb)
                                        event["batter_last_name"] = last
                                        event["batter"] = full
                                        break
                            event["lineup_position"] = (vis_lineup_cntr % 9) + 1
                            event["defensive_position"] = list(vis_lineup.keys())[list(vis_lineup.values()).index(full)]
                            event["event_type"] = get_event_type(play_text)
                            event["event_type_int"] = event_code[event["event_type"]]
                            event["ab_flag"] = 1 if event["event_type_int"] in [2,3,13,18,19,20,21,22,23] and not(is_sac_fly(play_text)) and not(is_sac_hit(play_text)) else 0
                            event["hit_value"] = 0 if event["event_type"] not in hits_lst else hits_lst.index(event["event_type"])
                            event["RBI_on_play"] = 0
                            event["fielded_by"] = ""
                            event["hit_location"] = ""
                            event["fielded_by"] = ""
                            event["batted_ball_type"] = ""
                            event["batter_dest"] = ""
                            event["runner_on_1st_dest"] = ""
                            event["runner_on_2nd_dest"] = ""
                            event["runner_on_3rd_dest"] = ""
                            next_play_elements = [""]
                            next_play_text = ""
                            runner_outcomes = ["advanced", "stole", "caught stealing", "out", "scored"]
                            if event["first_runner_last_name"] != "":
                                event["runner_on_1st_dest"] = 1
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["first_runner_last_name"] in play_elements[0]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                        
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["first_runner_last_name"] in play_elements[1]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_1st_dest"] = ""
                            
                            if event["second_runner_last_name"] != "":
                                event["runner_on_2nd_dest"] = 2
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["second_runner_last_name"] in play_elements[0]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["second_runner_last_name"] in play_elements[1]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["second_runner_last_name"] in play_elements[2]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_2nd_dest"] = ""
                                
                            if event["third_runner_last_name"] != "":
                                event["runner_on_3rd_dest"] = 3
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["third_runner_last_name"] in play_elements[0]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["third_runner_last_name"] in play_elements[1]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["third_runner_last_name"] in play_elements[2]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:                                
                                        if outcome in play_elements[3] and event["third_runner_last_name"] in play_elements[3]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[3], get_full_name(vis_players, play_elements[3], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_3rd_dest"] = ""
                                
                        elif not(runner_only):
                            for verb in pa_ended:
                                if verb in play_elements[0]:
                                    full, last = get_full_name(vis_players, play_elements[0], verb)
                                    if full == "Could not find" and "out" in play_elements[0]:
                                        full, last = get_full_name(vis_players, play_elements[0], "out")
                                    event["batter_last_name"] = last
                                    event["batter"] = full
                                    event["lineup_position"] = (vis_lineup_cntr % 9) + 1
                                    vis_lineup_cntr += 1
                                    event["defensive_position"] = list(vis_lineup.keys())[list(vis_lineup.values()).index(full)]
                                    event["event_type"] = get_event_type(play_text)
                                    event["event_type_int"] = event_code[event["event_type"]]
                                    event["ab_flag"] = 1 if event["event_type_int"] in [2,3,13,18,19,20,21,22,23] and not(is_sac_fly(play_text)) and not(is_sac_hit(play_text)) else 0
                                    event["hit_value"] = 0 if event["event_type"] not in hits_lst else hits_lst.index(event["event_type"]) + 1
                                    event["RBI_on_play"] = rbis(play_text)
                                    event["fielded_by"] = get_fielded_by(play_elements[0])
                                    event["hit_location"] = get_hit_location(play_elements[0])
                                    # avoiding a function being called twice
                                    if event["hit_location"] == "":
                                        event["hit_location"] = event["fielded_by"]
                                    event["batted_ball_type"] = get_batted_ball_type(play_elements[0])
                                    event["batter_dest"] = get_batter_dest(play_elements[0], play_text)
                                    break             
                                
                            # explicit reset of these values
                            event["runner_on_1st_dest"] = ""
                            event["runner_on_2nd_dest"] = ""
                            event["runner_on_3rd_dest"] = ""                    
                            # this will be "runners" clause
                            runner_outcomes = ["advanced", "out", "scored", "stole", "caught stealing"]
                            if event["first_runner_last_name"] != "":
                                event["runner_on_1st_dest"] = 1
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["first_runner_last_name"] in play_elements[0]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                        
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["first_runner_last_name"] in play_elements[1]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_1st_dest"] = ""
                            
                            if event["second_runner_last_name"] != "":
                                event["runner_on_2nd_dest"] = 2
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["second_runner_last_name"] in play_elements[0]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["second_runner_last_name"] in play_elements[1]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["second_runner_last_name"] in play_elements[2]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_2nd_dest"] = ""
                                
                            if event["third_runner_last_name"] != "":
                                event["runner_on_3rd_dest"] = 3
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["third_runner_last_name"] in play_elements[0]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["third_runner_last_name"] in play_elements[1]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["third_runner_last_name"] in play_elements[2]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:                                
                                        if outcome in play_elements[3] and event["third_runner_last_name"] in play_elements[3]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[3], get_full_name(vis_players, play_elements[3], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_3rd_dest"] = ""
                                
                        # need to check for a runner only sentence (no semi-colons)
                        
                        # if event does not terminate at-bat set batter_event_flag to 0
                        # it is set to 1 by default
                        # we also need a check for when it just says 'out'
                        # 'out' could signal a batter out or a runner out
                        # it will say caught stealing or picked off if so
                        play_list.append(event)
                        event = event.copy() # info in same half inning needs to be kept
                        event["outs"] += event["outs_on_play"] # updating outs based on play
                        event["outs_on_play"] = 0  # but make sure to reset outs on play lol
    
                        # it's the score immediately before the play
                        vis_score = play.findAll("td")[0].get_text()
                        home_score = play.findAll("td")[1].get_text()
                        event["vis_score"] = vis_score
                        event["home_score"] = home_score
                        event["pinchhit_flag"] = 0 
                        event["leadoff_flag"] = 0 #once in else block, no longer leadoff man
                        event["Batter_removed_for_pinch-hitter"] = ""
                        event["Position_of_batter_removed_for_pinch-hitter"] = ""
                        event["third_runner"] = event["batter"] if event["batter_dest"] == 3 else event["first_runner"] if event["runner_on_1st_dest"] == 3 else event["second_runner"] if event["runner_on_2nd_dest"] == 3 else event["third_runner"] if event["runner_on_3rd_dest"] == 3 else ""
                        event["second_runner"] = event["batter"] if event["batter_dest"] == 2 else event["first_runner"] if event["runner_on_1st_dest"] == 2 else event["second_runner"] if event["runner_on_2nd_dest"] == 2 else ""
                        event["first_runner"] = event["batter"] if event["batter_dest"] == 1 else event["first_runner"] if event["runner_on_1st_dest"] == 1 else ""
                        event["third_runner_last_name"] = event["batter_last_name"] if event["batter_dest"] == 3 else event["first_runner_last_name"] if event["runner_on_1st_dest"] == 3 else event["second_runner_last_name"] if event["runner_on_2nd_dest"] == 3 else event["third_runner_last_name"] if event["runner_on_3rd_dest"] == 3 else ""
                        event["second_runner_last_name"] = event["batter_last_name"] if event["batter_dest"] == 2 else event["first_runner_last_name"] if event["runner_on_1st_dest"] == 2 else event["second_runner_last_name"] if event["runner_on_2nd_dest"] == 2 else ""
                        event["first_runner_last_name"] = event["batter_last_name"] if event["batter_dest"] == 1 else event["first_runner_last_name"] if event["runner_on_1st_dest"] == 1 else ""
                        event["Pinch-runner_on_1st"] = 0
                        event["Runner_removed_for_pinch-runner_on_1st"] = ""
                        event["Pinch-runner_on_2nd"] = 0
                        event["Runner_removed_for_pinch-runner_on_2nd"] = ""
                        event["Pinch-runner_on_3rd"] = 0
                        event["Runner_removed_for_pinch-runner_on_3rd"] = ""
                        event["batter_dest"] = ""
                        event["batter_event_flag"] = 1
                        event["passed_ball_flag"] = 0
                        event["wild_pitch_flag"] = 0
                        event["event_type"] = ""
                        event["balls"] = ""
                        event["strikes"] = ""
                        event["pitch_sequence"] = ""
                        runner_only = False
                    else: #home team
                        event["pitcher"] = vis_lineup["p"]
                        event["catcher"] = vis_lineup["c"]      
                        event["first_base"] = vis_lineup["1b"]
                        event["second_base"] = vis_lineup["2b"]
                        event["third_base"] = vis_lineup["3b"]
                        event["shortstop"] = vis_lineup["ss"]
                        event["left_field"] = vis_lineup["lf"]
                        event["center_field"] = vis_lineup["cf"]
                        event["right_field"] = vis_lineup["rf"]
                        event["designated_hitter"] = vis_lineup["dh"]
                        play_text = play.find('th').get_text()
                        if "ejected" in play_text:
                            continue
                        event["event_text"] = play_text
                        event["outs_on_play"] = 3 if is_triple_play(play_text) else 2 if is_double_play(play_text) else 0
                        event["double_play_flag"] = is_double_play(play_text)
                        event["triple_play_flag"] = is_triple_play(play_text)
                        if ("out" in play_text or "popped up" in play_text) and not(is_double_play(play_text)): #
                            event["outs_on_play"] = 1
                        if "(" in play_text and ")" in play_text:
                            balls, strikes, pitch_seq = get_ball_strike(play_text)
                            event["balls"] = balls
                            event["strikes"] = strikes
                            event["pitch_sequence"] = pitch_seq
                        event["SH_flag"] = is_sac_hit(play_text)
                        event["SF_flag"] = is_sac_fly(play_text)
                        event["foul_flag"] = is_foul_ball(play_text)
    #     return min(num_errors, 3), pos_1, pos_2, pos_3, type_1, type_2, type_3
                        errors, posi1, posi2, posi3, typo1, typo2, typo3 = get_errors(play_text)
                        event["num_errors"] = errors
                        event["1st_error_position"] = posi1
                        event["2nd_error_position"] = posi2
                        event["3rd_error_position"] = posi3
                        event["1st_error_type"] = typo1
                        event["2nd_error_type"] = typo2
                        event["3rd_error_type"] = typo3
                        sb1, sb2, sb3 = stolen_base_flags(play_text)
                        event["SB_for_runner_on_1st_flag"] = sb1
                        event["SB_for_runner_on_2nd_flag"] = sb2
                        event["SB_for_runner_on_3rd_flag"] = sb3
                        cs1, cs2, cs3 = caught_stealing_flags(play_text)
                        event["CS_for_runner_on_1st_flag"] = cs1
                        event["CS_for_runner_on_2nd_flag"] = cs2
                        event["CS_for_runner_on_3rd_flag"] = cs3
                        event_cntr +=1
                        event["event_num"] = event_cntr
                        play_elements = play_text.split(";") #batter is usually first clause
                        for verb in pa_not_ended:
                            if verb in play_elements[0]: #runner only event (passed ball, caught stealing, etc.)
                                if "reached" not in play_elements[0] and "singled" not in play_elements[0]:
                                    if "doubled" not in play_elements[0] and "tripled" not in play_elements[0]:
                                        event["batter_event_flag"] = 0 #defaults to 1
                                        if verb == "advanced":
                                            if "wild pitch" in play_text.lower():
                                                event["wild_pitch_flag"] = 1
                                            elif "passed ball" in play_text.lower():
                                                event["passed_ball_flag"] = 1
                                        runner_only = True
                                        break
                        if runner_only:
                            if play != half_inning.findAll('tr')[1:][-1]:
                                j = 1
                                next_play = half_inning.findAll('tr')[1:][half_inning.findAll('tr')[1:].index(play) + j]
                                next_play_text = next_play.find('th').get_text()
                                next_play_attrs = next_play.find('th').attrs
                                while 'class' in next_play_attrs and next_play_attrs['class'] == ["text-italic"] and "/" not in next_play_text:
                                    # just ignoring anything that looks like this '/ for Carey' with last criteria
                                    sub = next_play_text.split()
                                    if "pinch hit" in next_play_text:
                                        event["pinchhit_flag"] = 1
                                        current_bat_clause = next_play_text.split()
                                        if top_or_bot == "top":
                                            cur_bat = get_full_name(vis_players, " ".join(current_bat_clause[:-1]), "pinch")[0]
                                            removed_bat = get_full_name(vis_players, next_play_text.split("for")[1].strip(" ."), "$")[0]
                                        else:
                                            cur_bat = get_full_name(home_players, " ".join(current_bat_clause[:-1]), "pinch")[0]
                                            removed_bat = get_full_name(home_players, next_play_text.split("for")[1].strip(" ."), "$")[0]                 
                                        event["Batter_removed_for_pinch-hitter"] = removed_bat
                                        if top_or_bot == "top":
                                            for dude in vis_lineup.values():
                                                if cur_bat == dude:
                                                    event["pinchhit_flag"] = 0
                                                    break
                                            if event["pinchhit_flag"] == 1:
                                                event["Position_of_batter_removed_for_pinch-hitter"] = list(vis_lineup.keys())[list(vis_lineup.values()).index(get_full_name(vis_players, removed_bat, "$")[0])]
                                                vis_lineup[event["Position_of_batter_removed_for_pinch-hitter"]] = get_full_name(vis_players, cur_bat, "$")[0]
                                        else:
                                            for dude in home_lineup.values():
                                                if cur_bat == dude:
                                                    event["pinchhit_flag"] = 0
                                                    break
                                            if event["pinchhit_flag"] == 1:
                                                event["Position_of_batter_removed_for_pinch-hitter"] = list(home_lineup.keys())[list(home_lineup.values()).index(get_full_name(home_players, removed_bat, "$")[0])]
                                                home_lineup[event["Position_of_batter_removed_for_pinch-hitter"]] = get_full_name(home_players, cur_bat, "$")[0]
                                    elif "pinch ran" in next_play_text:
                                        base, removed, cur_runner = get_pinch_ran_for_stuff(event["first_runner_last_name"], event["second_runner_last_name"], event["third_runner_last_name"], next_play_text, home_players)
                                        if base == 1:
                                            event["Pinch-runner_on_1st"] = 1
                                            event["Runner_removed_for_pinch-runner_on_1st"] = removed
                                            event["first_runner"] = cur_runner
                                        elif base == 2:
                                            event["Pinch-runner_on_2nd"] = 1
                                            event["Runner_removed_for_pinch-runner_on_2nd"] = removed
                                            event["second_runner"] = cur_runner
                                        elif base == 3:
                                            event["Pinch-runner_on_3rd"] = 1
                                            event["Runner_removed_for_pinch-runner_on_3rd"] = removed
                                            event["third_runner"] = cur_runner  
                                        if len(removed) > 2:
                                            if top_or_bot == "top":
                                                fullname = get_full_name(vis_players, removed, "$")[0]
                                                pos = list(vis_lineup.keys())[list(vis_lineup.values()).index(fullname)]
                                                vis_lineup[pos] = fullname
                                            else:
                                                fullname = get_full_name(home_players, removed, "$")[0]
                                                pos = list(home_lineup.keys())[list(home_lineup.values()).index(fullname)]
                                                home_lineup[pos] = fullname                                    
                                    # defensive substitutions here:
                                    elif sub[1] == "to":
                                        # defensive subs happen in top for home, bot for away
                                        # making an exception for dh because of game 1
                                        if top_or_bot == "top":                      
                                            if " dh " in text:
                                                vis_lineup[sub[2]] = get_full_name(vis_players, sub[0], "$")[0]
                                            else:                            
                                                home_lineup[sub[2]] = get_full_name(home_players, sub[0], "$")[0]
                                        else:
                                            if " dh " in text:
                                                home_lineup[sub[2]] = get_full_name(home_players, sub[0], "$")[0]
                                            else:
                                                vis_lineup[sub[2]] = get_full_name(vis_players, sub[0], "$")[0]
                                    j += 1
                                    next_play = half_inning.findAll('tr')[1:][half_inning.findAll('tr')[1:].index(play) + j]
                                    next_play_text = next_play.find('th').get_text()
                                    next_play_attrs = next_play.find('th').attrs
                            else:  #if the play ends the inning
                                lineup_with_indents = list()
                                for player in home_box.findAll('tr'):
                                    player = player.find('th').get_text()
                                    lineup_with_indents.append(player)
                                for player in lineup_with_indents:
                                    if event["batter"] in player:
                                        current_batter = lineup_with_indents[lineup_with_indents.index(player) + 1]
                                        potential_current_batter = lineup_with_indents[lineup_with_indents.index(player) + 2]
                                        break
                                while potential_current_batter[:4] == "\xa0\xa0\xa0\xa0" or current_batter[0] == "p" or current_batter[:5] == "\xa0\xa0\xa0\xa0p":
                                    current_batter = potential_current_batter
                                    potential_current_batter = lineup_with_indents[lineup_with_indents.index(current_batter) + 1]
                                current_batter = current_batter.strip()
                                current_batter = " ".join(current_batter.split()[1:])
                                event["batter"] = current_batter
                            # if we skip over loop, the batter event occurred right after
                            try:
                                next_play_elements = next_play_text.split(";")
                            except:
                                next_play_elements = [""]
                            # what happens if next play is also a runner only event (could be several in a row)
                            next_runner_only = False
                            for verb in pa_not_ended:
                                if verb in next_play_elements[0]: #runner only event (passed ball, caught stealing, etc.)
                                    if "reached" not in next_play_elements[0] and "singled" not in next_play_elements[0]:
                                        if "doubled" not in next_play_elements[0] and "tripled" not in next_play_elements[0]:
                                            event["batter_event_flag"] = 0 #defaults to 1
                                            next_runner_only = True
                                            break
                            while next_runner_only == True:
                                next_runner_only = False
                                j += 1
                                next_play = half_inning.findAll('tr')[1:][half_inning.findAll('tr')[1:].index(play) + j]
                                next_play_text = next_play.find('th').get_text()
                                for verb in pa_not_ended:
                                    if verb in next_play_elements[0]: #runner only event (passed ball, caught stealing, etc.)
                                        if "reached" not in next_play_elements[0] and "singled" not in next_play_elements[0]:
                                            if "doubled" not in next_play_elements[0] and "tripled" not in next_play_elements[0]:
                                                event["batter_event_flag"] = 0 #defaults to 1
                                                runner_only = True
                                next_play_elements = next_play_text.split(";")
                            if play != half_inning.findAll('tr')[1:][-1]:
                                for verb in pa_ended:
                                    if verb in next_play_elements[0]:
                                        full, last = get_full_name(home_players, next_play_elements[0], verb)
                                        event["batter_last_name"] = last
                                        event["batter"] = full
                                        break
                            event["lineup_position"] = (home_lineup_cntr % 9) + 1
                            try:
                                event["defensive_position"] = list(home_lineup.keys())[list(home_lineup.values()).index(full)]
                            except:
                                print("", end="")
                            event["event_type"] = get_event_type(play_text)
                            event["event_type_int"] = event_code[event["event_type"]]
                            event["ab_flag"] = 1 if event["event_type_int"] in [2,3,13,18,19,20,21,22,23] and not(is_sac_fly(play_text)) and not(is_sac_hit(play_text)) else 0
                            event["hit_value"] = 0 if event["event_type"] not in hits_lst else hits_lst.index(event["event_type"])
                            event["RBI_on_play"] = 0
                            event["fielded_by"] = ""
                            event["hit_location"] = ""
                            event["fielded_by"] = ""
                            event["batted_ball_type"] = ""
                            event["batter_dest"] = ""
                            event["runner_on_1st_dest"] = ""
                            event["runner_on_2nd_dest"] = ""
                            event["runner_on_3rd_dest"] = ""
                            runner_outcomes = ["advanced", "stole", "caught stealing","out", "scored"]
                            if event["first_runner_last_name"] != "":
                                event["runner_on_1st_dest"] = 1
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["first_runner_last_name"] in play_elements[0]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                        
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["first_runner_last_name"] in play_elements[1]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_1st_dest"] = ""
                            
                            if event["second_runner_last_name"] != "":
                                event["runner_on_2nd_dest"] = 2
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["second_runner_last_name"] in play_elements[0]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["second_runner_last_name"] in play_elements[1]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["second_runner_last_name"] in play_elements[2]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_2nd_dest"] = ""
                                
                            if event["third_runner_last_name"] != "":
                                event["runner_on_3rd_dest"] = 3
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["third_runner_last_name"] in play_elements[0]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["third_runner_last_name"] in play_elements[1]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["third_runner_last_name"] in play_elements[2]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:                                
                                        if outcome in play_elements[3] and event["third_runner_last_name"] in play_elements[3]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[3], get_full_name(vis_players, play_elements[3], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_3rd_dest"] = ""
    
                        # this is the batter 'clause' of the sentence
                        elif not(runner_only):
                            for verb in pa_ended:
                                if verb in play_elements[0]:
                                    full, last = get_full_name(home_players, play_elements[0], verb)
                                    if full == "Could not find" and "out" in play_elements[0]:
                                        full, last = get_full_name(vis_players, play_elements[0], "out")
                                    event["batter_last_name"] = last
                                    event["batter"] = full
                                    event["lineup_position"] = (home_lineup_cntr % 9) + 1
                                    home_lineup_cntr +=1
                                    event["defensive_position"] = list(home_lineup.keys())[list(home_lineup.values()).index(full)]
                                    event["event_type"] = get_event_type(play_text)
                                    event["event_type_int"] = event_code[event["event_type"]]
                                    event["ab_flag"] = 1 if event["event_type_int"] in [2,3,13,18,19,20,21,22,23] and not(is_sac_fly(play_text)) and not(is_sac_hit(play_text)) else 0
                                    event["hit_value"] = 0 if event["event_type"] not in hits_lst else hits_lst.index(event["event_type"])
                                    event["RBI_on_play"] = rbis(play_text)
                                    event["fielded_by"] = get_fielded_by(play_elements[0])
                                    event["hit_location"] = get_hit_location(play_elements[0])
                                    # avoiding a function being called twice
                                    if event["hit_location"] == "":
                                        event["hit_location"] = event["fielded_by"]
                                    event["batted_ball_type"] = get_batted_ball_type(play_elements[0])
                                    event["batter_dest"] = get_batter_dest(play_elements[0], play_text)
                                    break
                        
                            #explicit reset of these values
                            event["runner_on_1st_dest"] = ""
                            event["runner_on_2nd_dest"] = ""
                            event["runner_on_3rd_dest"] = ""                    
                            # this will be "runners" clause
                            runner_outcomes = ["advanced", "out", "scored", "stole", "caught stealing"]
                            if event["first_runner_last_name"] != "":
                                event["runner_on_1st_dest"] = 1
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["first_runner_last_name"] in play_elements[0]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                        
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["first_runner_last_name"] in play_elements[1]:
                                            event["runner_on_1st_dest"] = get_runner_on_first_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_1st_dest"] = ""
                            
                            if event["second_runner_last_name"] != "":
                                event["runner_on_2nd_dest"] = 2
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["second_runner_last_name"] in play_elements[0]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["second_runner_last_name"] in play_elements[1]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["second_runner_last_name"] in play_elements[2]:
                                            event["runner_on_2nd_dest"] = get_runner_on_second_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_2nd_dest"] = ""
                                
                            if event["third_runner_last_name"] != "":
                                event["runner_on_3rd_dest"] = 3
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[0] and event["third_runner_last_name"] in play_elements[0]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[0], get_full_name(vis_players, play_elements[0], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[1] and event["third_runner_last_name"] in play_elements[1]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[1], get_full_name(vis_players, play_elements[1], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:
                                        if outcome in play_elements[2] and event["third_runner_last_name"] in play_elements[2]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[2], get_full_name(vis_players, play_elements[2], outcome)[1])
                                except:
                                    print("", end="")
                                try:
                                    for outcome in runner_outcomes:                                
                                        if outcome in play_elements[3] and event["third_runner_last_name"] in play_elements[3]:
                                            event["runner_on_3rd_dest"] = get_runner_on_third_dest(play_elements[3], get_full_name(vis_players, play_elements[3], outcome)[1])
                                except:
                                    print("", end="")
                            else:
                                event["runner_on_3rd_dest"] = ""
                        # need to check for a runner only sentence (no semi-colons)
                        
                        # if event does not terminate at-bat set batter_event_flag to 0
                        # it is set to 1 by default
                        # we also need a check for when it just says 'out'
                        # 'out' could signal a batter out or a runner out
                        # it will say caught stealing or picked off if so
                        play_list.append(event)
                        event = event.copy() # info in same half inning needs to be kept
                        event["outs"] += event["outs_on_play"] # updating outs based on play
                        event["outs_on_play"] = 0  # but make sure to reset outs on play lol
                        # it's the score immediately before the play
                        vis_score = play.findAll("td")[0].get_text()
                        home_score = play.findAll("td")[1].get_text()
                        event["vis_score"] = vis_score
                        event["home_score"] = home_score
                        event["pinchhit_flag"] = 0 
                        event["leadoff_flag"] = 0 #once in else block, no longer leadoff man
                        
                        event["Batter_removed_for_pinch-hitter"] = ""
                        event["Position_of_batter_removed_for_pinch-hitter"] = ""
                        event["third_runner"] = event["batter"] if event["batter_dest"] == 3 else event["first_runner"] if event["runner_on_1st_dest"] == 3 else event["second_runner"] if event["runner_on_2nd_dest"] == 3 else event["third_runner"] if event["runner_on_3rd_dest"] == 3 else ""
                        event["second_runner"] = event["batter"] if event["batter_dest"] == 2 else event["first_runner"] if event["runner_on_1st_dest"] == 2 else event["second_runner"] if event["runner_on_2nd_dest"] == 2 else ""
                        event["first_runner"] = event["batter"] if event["batter_dest"] == 1 else event["first_runner"] if event["runner_on_1st_dest"] == 1 else ""
                        event["third_runner_last_name"] = event["batter_last_name"] if event["batter_dest"] == 3 else event["first_runner_last_name"] if event["runner_on_1st_dest"] == 3 else event["second_runner_last_name"] if event["runner_on_2nd_dest"] == 3 else event["third_runner_last_name"] if event["runner_on_3rd_dest"] == 3 else ""
                        event["second_runner_last_name"] = event["batter_last_name"] if event["batter_dest"] == 2 else event["first_runner_last_name"] if event["runner_on_1st_dest"] == 2 else event["second_runner_last_name"] if event["runner_on_2nd_dest"] == 2 else ""
                        event["first_runner_last_name"] = event["batter_last_name"] if event["batter_dest"] == 1 else event["first_runner_last_name"] if event["runner_on_1st_dest"] == 1 else ""
                        event["Pinch-runner_on_1st"] = 0
                        event["Runner_removed_for_pinch-runner_on_1st"] = ""
                        event["Pinch-runner_on_2nd"] = 0
                        event["Runner_removed_for_pinch-runner_on_2nd"] = ""
                        event["Pinch-runner_on_3rd"] = 0
                        event["Runner_removed_for_pinch-runner_on_3rd"] = ""
                        event["batter_dest"] = ""
                        event["batter_event_flag"] = 1
                        event["passed_ball_flag"] = 0
                        event["wild_pitch_flag"] = 0
                        event["event_type"] = ""
                        event["balls"] = ""
                        event["strikes"] = ""
                        event["pitch_sequence"] = ""
                        runner_only = False
            except:
                temp = event_template.copy()
                for key, val in temp.items():
                    if key not in ["date", "start", "visiting_team", "home_team"]:
                        temp[key] = "NA"
                temp["home_score"] = event["home_score"]
                temp["vis_score"] = event["vis_score"]
                temp["event_text"] = event["event_text"]
#                if "out" in play_text:
#                    event["outs"] += 1
#                if "double play" in play_text:
#                    event["outs"] += 2
                temp["outs"] = event["outs"]
                temp["event_num"] = event["event_num"]
                play_list.append(temp)
                    
    return play_list


def get_full_name(player_list, clause, verb):
    name = clause.split(verb)[0].strip(" ")
    first_initial = ""
    if len(name.split(" ")) == 1:
        last_name = name.strip(".,;")
    else:
        last_name = name.split(", ")[0]
        try:
            first_initial = name.split(", ")[1]
        except:
            last_name = " ".join(name.split(" ")[1:])
            first_initial = name.split(" ")[0]
    full_name = "Could not find"
    for plyr in player_list:
        if name == plyr:
            full_name = name
        elif last_name in plyr:
            if len(name.split(" ")) > 1 and len(plyr.split()) > 1:
                if first_initial.strip(".") in plyr.split()[0]:
                    full_name = plyr
                else:
                    continue
            else:
                full_name = plyr
                break
    
    return full_name, last_name


        

# "stole": "stolen base" # save for pa_not ended
# caught stealing
# wild pitch
# passed ball
# foul error
# other advance
# pickoff
# pickoff error
# balk
# scored
# ejected hahaha
# "failed pickoff attempt"
#
#
#
# I'll use a similar function to get_event type (just the pa_not_ended version)
#
##    
#              "unknown event": 0,  
#              "no event": 1,
#              "generic out": 2,
#              "strikeout": 3,
#              "stolen base": 4,
#              "defensive indifference": 5,
#              "caught stealing": 6,
#              "pickoff error": 7,
#              "pickoff": 8,
#              "wild pitch": 9,
#              "passed ball": 10,
#              "balk": 11,
#              "other advance": 12,
#              "foul error": 13,
#              "walk": 14,
#              "intentional walk": 15,
#              "hit by pitch": 16,
#              "interference": 17,
#              "error": 18,
#              "fielder's choice":19,
#              "single": 20,
#              "double": 21,
#              "triple": 22,
#              "home run": 23,
#              "missing play": 24}


def get_event_type(the_play):
    event_type = {
                  "walked": "walk",
                  "grounded out": "generic out",
                  "flied out": "generic out",
                  "popped up": "generic out",
                  "lined out": "generic out",
                  "fouled out": "generic out",
                  "struck out": "strikeout",
                  "intentionally walked": "intentional walk", 
                  "hit by pitch": "hit by pitch", 
                  "singled": "single",
                  "doubled": "double",
                  "tripled": "triple",
                  "homered": "home run",
                  "home run": "home run",
                  "reached on error": "error",
                  "fielder's choice": "fielder's choice",
                  "indifference": "defensive indifference",
                  "catcher's interference": "interference", 
                  "infield fly": "generic out",
                  "popped out": "generic out",
                  "stole": "stolen base",
                  "defensive indifference": "defensive indifference",
                  "picked off": "pickoff",
                  "wild pitch": "wild pitch",
                  "passed ball": "passed ball",
                  "balk": "balk"
                  }
    
    the_play_lower = the_play.lower()
    
    for key in event_type:
        if key in the_play_lower:
            return event_type[key]
    
    if "double play" in the_play_lower:
        return "generic out"
    
    if is_caught_stealing(the_play_lower):
        return "caught stealing"
    
    if "advanced" in the_play_lower and "throwing error by p" in the_play_lower:
        return "pickoff error"
    
    if "foul" in the_play_lower and ("dropped" in the_play_lower or "error" in the_play_lower):
        return "foul error"
    
    if "error" in the_play_lower:
        return "error"
        
    if "advanced" in the_play_lower:
        return "other advance"
    
    return "unknown event"


def is_sac_hit(the_play):
    if "sac" in the_play.lower() and "flied" not in the_play:
        return 1
    return 0


def is_sac_fly(the_play):
    if "sac" in the_play.lower() and "flied" in the_play:
        return 1
    if "SF" in the_play.split("(")[0]:
        return 1
    return 0


def is_double_play(the_play):
    if "double play" in the_play:
        return 1
    return 0

def is_triple_play(the_play):
    if "triple play" in the_play:
        return 1
    return 0


def rbis(the_play):
    if "RBI" not in the_play:
        return 0
    try:
        return int(the_play[the_play.index("RBI") -2])
    except:
        return 1

def is_foul_ball(the_play):
    if "foul" in the_play.lower():
        return 1
    return 0

def is_bunt(the_play):
    if "bunt" in the_play.lower():
        return 1
    return 0


def get_hit_location(the_play):
    stops = [" (", ".", ","]
    if "down the" in the_play:
        place_part = the_play.split("down the")[1]
        place_end = len(place_part)
        for stop in stops:
            if stop in place_part:
                place_end = place_part.index(stop)
        return place_part[:place_end]
    if " through " in the_play:
        start = the_play.index("through")
        loc = ""
        i = 0
        char = the_play[start]
        while len(the_play) > start + i and char not in ",;.":
            char = the_play[start+i]
            loc += char
            i += 1
        return loc
    return ""


def get_fielded_by(the_play):
    fielded_by = ""
    # this first statement covers all errors even if the 'by' is in advanced
    # bc it's all in the first clause which is the batter
    # the first clause is what's being past into 'the_play'
    if "reached on" in the_play and "error" in the_play and "by" in the_play:
        i = the_play.index("by") + 2
        while i < len(the_play):
            fielded_by += the_play[i]
            i += 1
    elif "double play" in the_play:
        if " to " in the_play:
            pos_end = the_play.index(" to ")
            pos_start = the_play.index("double play") + len("double play") + 1
            fielded_by = the_play[pos_start:pos_end]
        elif "unassisted" in the_play:
            pos_end = the_play.index(" unassisted")
            pos_start = the_play.index("double play") + len("double play") + 1
            fielded_by = the_play[pos_start:pos_end]
#    elif "advanced" in the_play and "singled," in the_play or "doubled," in the_play or "tripled," in the_play:
#        i = the_play.index("by") + 2
#        while i < len(the_play):
#            fielded_by += the_play[i]
#            i += 1
#        fielded_by = fielded_by.strip(" ")
    elif " to " in the_play:
        if "struck out" in the_play:
            fielded_by = "c"
        else:
            stops = [" unassisted", " (", ".", ","]
            pos_part = the_play.split(" to ")[1]
            pos_end = len(pos_part)
            for stop in stops:
                if stop in pos_part:
                    pos_end = pos_part.index(stop)
                    break
            fielded_by = pos_part[:pos_end]
    return fielded_by


def get_batted_ball_type(the_play):
    verbs = ["flied", "popped", "lined", "grounded",  "fielder's choice", "infield fly", "dropped fly"]
    ball_types = ["F", "P", "L", "G", "P", "G", "G", "F"]
    
    for i in range(len(verbs)):
        if verbs[i] in the_play:
            return ball_types[i]
    
    return ""


def get_errors(the_play):
    pos_1, pos_2, pos_3 = "", "", ""
    type_1, type_2, type_3 = "", "", ""
    if "error" not in the_play:
        num_errors = 0
    else:
        if "error" in the_play:
            num_errors = 1
            if "error by" in the_play:
                pos_1 = the_play[the_play.index("error by ") + 9:the_play.index("error by ") + 9 +2].strip(" ,.;")
                type_1 = the_play[the_play.index("error by ") - 9:the_play.index("error by ")].strip()
                if "fielding" not in type_1 and "throwing" not in type_1:
                    type_1 = ""
                rest = the_play[the_play.index("error by")+8:]
                while "error by" in rest:
                    num_errors += 1
                    if num_errors == 2:
                        pos_2 = the_play[the_play.index("error by ") + 9:the_play.index("error by ") + 9 +2].strip(" ,.;")
                        type_2 = the_play[the_play.index("error by ") - 9:the_play.index("error by ")].strip()
                        if "fielding" not in type_2 and "throwing" not in type_2:
                            type_2 = ""
                    elif num_errors == 3:
                        pos_3 = the_play[the_play.index("error by ") + 9:the_play.index("error by ") + 9 +2].strip(" ,.;")
                        type_3 = the_play[the_play.index("error by ") - 9:the_play.index("error by ")].strip()
                        if "fielding" not in type_3 and "throwing" not in type_3:
                            type_3 = ""
                    rest = rest[rest.index("error by")+8:]
        if "fielding error by " in the_play:
            start = the_play.index("fielding error by ") +17
            pos = the_play[start:start+2]
            rest = the_play[start:]
            if "fielding error by " + pos in rest:
                num_errors -= 1
        if "dropped fly ball" in the_play:
            num_errors = 1
            if "by" in the_play:
                pos_1 = the_play[the_play.index("by") + 3: the_play.index("by") + 5]
                type_1 = "fielding"
    
    return min(num_errors, 3), pos_1, pos_2, pos_3, type_1, type_2, type_3


def stolen_base_flags(the_play):
    first, second, third = 0, 0, 0
    if "stole second" in the_play:
        first = 1
    if "stole third" in the_play:
        second = 1
    if "stole home" in the_play:
        third = 1
    return first, second, third


def caught_stealing_flags(the_play):
    first, second, third = 0, 0, 0
    if "caught stealing" in the_play:
        if "out at second" in the_play:
            first = 1
        if "out at third" in the_play:
            second = 1
        if "out at home" in the_play:
            third = 1
    elif "out at second c to ss" in the_play or "out at second c to 2b" in the_play:
        first =1
    elif "out at third c to 3b" in the_play or "out at third c to 3b" in the_play:
        second = 1
    
    return first, second, third

def is_caught_stealing(the_play):
    val = 0
    if "caught stealing" in the_play:
        if "out at second" in the_play:
            val = 1
        if "out at third" in the_play:
            val = 1
        if "out at home" in the_play:
            val = 1
    elif "out at second c to ss" in the_play or "out at second c to 2b" in the_play:
        val =1
    elif "out at third c to 3b" in the_play or "out at third c to 3b" in the_play:
        val = 1
    
    return val
        


def get_batter_dest(batter, whole_play):
    #passing in first clause (batter clause)
    #dest = "" #want to see errors at first
    if "out" in batter or "popped" in batter or "double play" in batter or "infield fly" in batter:
        dest = 0
    elif "dropped fly ball" in whole_play or "foul error" in whole_play:
        dest = ""
    else:
        first_list = ["singled", "walk", "reached", "intentionally walked", "hit by pitch", "interference"]
        for outcome in first_list:
            if outcome in batter:
                dest = 1
                break
        second_list = ["doubled", "advanced to second"]
        for outcome in second_list:
            if outcome in batter:
                dest = 2
                break
        third_list = ["tripled", "advanced to third"]
        for outcome in third_list:
            if outcome in batter:
                dest = 3
                break
        if "homered" in batter:
            dest = 4
        if ";" in whole_play and "scored" in batter:
            dest = 4
            
    return dest


def get_runner_on_first_dest(the_play, first_runner_last_name):
    # elements are being passed in only pertaining to that runner
    # this makes it okay to look for name in play and advanced in play
    # rather than name + advanced in play
    dest = 1
    if first_runner_last_name in the_play and "advanced to second" in the_play:
        dest = 2
    if first_runner_last_name in the_play and  "stole second" in the_play:
        dest = 2
    if first_runner_last_name in the_play and "advanced to third" in the_play:
        dest = 3
    if first_runner_last_name in the_play and "stole third" in the_play:
        dest = 3
    if first_runner_last_name in the_play and "out" in the_play:
        dest = 0
    if first_runner_last_name in the_play and "caught stealing" in the_play:
        dest = 0
    if first_runner_last_name in the_play and "scored" in the_play:
        dest = 4
    if first_runner_last_name in the_play and "stole home" in the_play:
        dest = 4

    return dest
        

def get_runner_on_second_dest(the_play, second_runner_last_name):
    #whole play being passed in once again
    dest = 2
    if second_runner_last_name in the_play and "advanced to third" in the_play:
        dest = 3
    if second_runner_last_name in the_play and "stole third" in the_play:
        dest = 3
    if second_runner_last_name in the_play and "out" in the_play:
        dest = 0
    if second_runner_last_name in the_play and "caught stealing" in the_play:
        dest = 0
    if second_runner_last_name in the_play and "scored" in the_play:
        dest = 4
    if second_runner_last_name in the_play and "stole home" in the_play:
        dest = 4
    
    return dest

def get_runner_on_third_dest(the_play, third_runner_last_name):
    dest = 3
    if third_runner_last_name in the_play and "out" in the_play:
        dest = 0
    if third_runner_last_name in the_play and "scored" in the_play:
        dest = 4
    if third_runner_last_name in the_play and "stole home" in the_play:
        dest = 4
    return dest

# leaving the runner where they were if the inning ends


def get_pinch_ran_for_stuff(r1, r2, r3, text, roster):
    #passing in 'last names' into r1, r2 r3 then comparing them to player who was run for
    plyrs = text.split(" pinch ran for ")
    for i in range(len(plyrs)):
        if len(plyrs[i].split(" ")) > 1:
            plyrs[i] = plyrs[i].strip(" ,;")
        else:
            plyrs[i] = plyrs[i].strip(" .,;")
    if text[-2:] == "..":
        plyrs[1] = plyrs[1][:-1]
    current = plyrs[0]
    to_be_removed = get_full_name(roster, plyrs[1].strip("."), "$")[1]
    if to_be_removed == r1:
        basa = 1
        removed = to_be_removed
    elif to_be_removed == r2:
        basa = 2
        removed = to_be_removed
    elif to_be_removed == r3:
        basa = 3
        removed = to_be_removed
    return basa, removed, current


def get_pinch_hit_stuff(text):
    plyrs = text.split(" pinch hit for ")
    return plyrs[0], plyrs[1]


def picked_off_first(the_play):
    if "picked off" in the_play and "p to 1b" in the_play:
        return 1
    return 0

def picked_off_second(the_play):
    if "picked off" in the_play and ("p to 2b" in the_play or "p to ss" in the_play):
        return 1
    return 0

def picked_off_third(the_play):
    if "picked off" in the_play and "p to 3b" in the_play:
        return 1
    return 0


def get_ball_strike(the_play):
    ball_strike_part = the_play.split("(")[1].split(")")[0]
    ball_strike_part = ball_strike_part.split()
    count = ball_strike_part[0]
    pitch_sequence = ""
    if len(ball_strike_part) > 1:
        pitch_sequence = ball_strike_part[1]
    count = count.split("-")
    ball = count[0]
    strike = count[1]
    return ball, strike, pitch_sequence
        
