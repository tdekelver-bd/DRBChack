# -*- coding: utf-8 -*-
"""
Created on Wed Mar 11 11:58:20 2020

@author: patrick guerin
"""

import json
import requests
from pprint import pprint

def DBRCSearchEngine(query):
    endpoint = 'https://dbrc-search.search.windows.net/'
    api_version = '?api-version=2019-05-06'
    headers = {'Content-Type': 'application/json', 'api-key': 'F23EE95ACA17323C0C7457B61CDDC113'}
    searchstring = '&search='+query
    url= endpoint + "indexes/azureblob-index/docs" + api_version + searchstring
    response  = requests.get(url, headers=headers)
    index_list = response.json()
    
    output = []
    for doc in index_list['value']:
        output.append(doc['metadata_storage_name'])
    return output

