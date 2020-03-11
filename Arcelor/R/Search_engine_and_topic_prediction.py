# -*- coding: utf-8 -*-
"""
Created on Sat Sep 22 15:44:43 2018

@author: patrick guerin
"""

#!pip install httplib urllib base64
import http.client, urllib, base64
import requests
import json

def Search_engine_and_topic_prediction(query):
    
        
    ############ Search Engine, parse through all the documents
    
    
    headers = {
     
        'api-key': 'C8202CBFB5437B985D1792D0232B45C4',
    }
    
    
    
    r = requests.get('https://searchengine.search.windows.net/indexes/safeindex/docs?api-version=2017-11-11&search={}'.format(query),headers=headers)
    
    data = r.json()
    
    results = []
    for doc in range(min(5,len(data['value']))):
        results.append(data['value'][doc]['metadata_storage_name'])
    
    
    
    
    ################ Get the predicted content
    #that should interest the user according to the question
    
    
    headers = {
     
        'Ocp-Apim-Subscription-Key': 'ae8d3fa361e14be1aebbd56f730afe2d',
    }
    
    params = urllib.parse.urlencode({
        # Text to analyze
        'q': query,
        # Optional request parameters, set to default values
        'verbose': 'false',
    })
    
    
    r = requests.get('https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/b730d2e6-a813-4500-9bb3-1e589ad0c3bb?%s',headers=headers, params=params)
    data2 = r.json()
    
    
    # get the predicted category
    pred = data2['topScoringIntent']['intent']
   
    output = {}
    output['names'] = results
    output['topic'] = pred
    
    
    return pred,list(results)
    
Search_engine_and_topic_prediction('risk valve')
# =============================================================================
#json_data = json.dumps(output)     
#with open('data.json', 'w') as f:
#         json.dump(json_data, f)
# =============================================================================
    
   


######################### get the titles  of the documents
# =============================================================================
# 
# import os
# import re
# 
# os.chdir(r'C:\Users\p\Desktop\mittal-hackaton\textfiles')
# 
# 
# Titles = []
# i=1
# for element in os.listdir():
#     with open('{}'.format(element),'r',encoding="utf8") as file:
#         txt = file.read()
#         file.close
# 
#     begin = txt.index('Title/Description:')+len('Title/Description:')
#     end = txt.index(r'\n\n\n')
#     Titles.append(txt[begin:end])
#     i=+1
#     
#     Titles[3]='4BF-HOT BLAST VALVE-CHANGE STEM PACKING'
# 
# 
# ######################  
#   
# ''' 2nd (kind of) search engine using Luis to link question to titles)'''
# 
# headers = {
#  
#     'Ocp-Apim-Subscription-Key': 'ae8d3fa361e14be1aebbd56f730afe2d',
# }
# 
# params = urllib.parse.urlencode({
#     # Text to analyze
#     'q': '?',
#     # Optional request parameters, set to default values
#     'verbose': 'true',
# })
# 
# r = requests.get('https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/50f05d84-7464-4ace-b892-d46fd985b344?%s',headers=headers, params=params)
# data = r.json()
# 
# 
# # get the predicted category
# preds = []
# 
# for i in range(3):
#   
#     preds.append(data['intents'][i]['intent'])
# =============================================================================

############ END: preds contains the predicted doc while pred contains the predicted topic,
    # or how to build a cheap search engine with NLP!

# =============================================================================
# 
# ────────▓▓▓▓▓▓▓────────────▒▒▒▒▒▒
# ──────▓▓▒▒▒▒▒▒▒▓▓────────▒▒░░░░░░▒▒
# ────▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓────▒▒░░░░░░░░░▒▒▒
# ───▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒░░░░░░░░░░░░░░▒
# ──▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░▒
# ──▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░▒
# ─▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░▒
# ▓▓▒▒▒▒▒▒░░░░░░░░░░░▒▒░░▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒
# ▓▓▒▒▒▒▒▒▀▀▀▀▀███▄▄▒▒▒░░░▄▄▄██▀▀▀▀▀░░░░░░▒
# ▓▓▒▒▒▒▒▒▒▄▀████▀███▄▒░▄████▀████▄░░░░░░░▒
# ▓▓▒▒▒▒▒▒█──▀█████▀─▌▒░▐──▀█████▀─█░░░░░░▒
# ▓▓▒▒▒▒▒▒▒▀▄▄▄▄▄▄▄▄▀▒▒░░▀▄▄▄▄▄▄▄▄▀░░░░░░░▒
# ─▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░▒
# ──▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░▒
# ───▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▀▀░░░░░░░░░░░░░░▒
# ────▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░▒▒
# ─────▓▓▒▒▒▒▒▒▒▒▒▒▄▄▄▄▄▄▄▄▄░░░░░░░░▒▒
# ──────▓▓▒▒▒▒▒▒▒▄▀▀▀▀▀▀▀▀▀▀▀▄░░░░░▒▒
# ───────▓▓▒▒▒▒▒▀▒▒▒▒▒▒░░░░░░░▀░░░▒▒
# ────────▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒
# ──────────▓▓▒▒▒▒▒▒▒▒▒░░░░░░░░▒▒
# ───────────▓▓▒▒▒▒▒▒▒▒░░░░░░░▒▒
# ─────────────▓▓▒▒▒▒▒▒░░░░░▒▒
# ───────────────▓▓▒▒▒▒░░░░▒▒
# ────────────────▓▓▒▒▒░░░▒▒
# ──────────────────▓▓▒░▒▒
# ───────────────────▓▒░▒
# ────────────────────▓▒
# 
#     
# =============================================================================
