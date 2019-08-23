#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  4 09:10:58 2018

@author: noahpurcell
"""

# get player ids
# running this against test csvs

# 1 get all the last names
# if the id isn't in the list of already existing ids, add it
# not sure how to tell on brothers

import pandas as pd
from collections import Counter

events17 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2017Data//events2017test.csv"
events18 = "//Users//noahpurcell//Desktop//IIAC_Scraping//2018Data//events2018test.csv"
events19 = "//Users//noahpurcell//Desktop//IIAC_Scraping//Test//events2019.csv"


def add_last_name(f):
    data = pd.read_csv(f)
    data["pitcher_last_name"] = data["pitcher"].apply(get_last_name)
    data.to_csv(f, encoding='utf-8', na_rep='NA', index=False)
    
def get_last_name(x):
    if pd.isnull(x):
        return "NA"
    elif x == "Could not find":
        return "NA"
    # Jordan Kaplan
    elif len(x.split()) == 2 and ("." not in x and "," not in x):
        return x.split()[1]
    # Kaplan, Jordan
    elif len(x.split()) == 2 and "," in x:
        return x.split()[0].strip(",")
    # J. Kaplan
    elif len(x.split()) == 2 and "." in x.split()[0] and Counter(x)['.'] == 1:
        return x.split()[1]
    elif len(x.split()) == 2 and "," in x.split()[0] and "." in x.split()[1]:
        return x.split()[0].strip(",")
    elif len(x.split()) == 2 and Counter(x)['.'] == 2:
        return x.split()[1]
    elif len(x.split()) == 1 and len(x.split(",")) == 2:
        return x.split(",")[0]
    elif len(x.split()) == 1:
        return x
    elif len(x.split()) == 3 and "," not in x and "." not in x:
        return " ".join(x.split()[1:])
    elif x == "Puckett Jr.":
        return x
    else:
        print(x)
        return x


# this is to fix a problem I noticed wherein when a runner only event occurs
# only the full name is correct not the last_name
def fix_batters(f):
    data = pd.read_csv(f)
    data["batter_last_name_test"] = data.apply(fix_batter_last, axis=1)
    data.to_csv(f, encoding='utf-8', na_rep='NA', index=False)

def fix_batter_last(row):
    last = str(row["batter_last_name"])
    full = str(row["batter"])
    if last in full:
        return last
    else:
        return get_last_name(row["batter"])



















