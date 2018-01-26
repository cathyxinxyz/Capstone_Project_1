# -*- coding: utf-8 -*-
"""
Created on Fri Jan 26 09:33:09 2018

@author: cathy
"""

import pandas as pd

dfs=list()
folder='c:/Users/cathy/Capstone_Project_1/master/Datasets/Food_atlas/'
filenames=['ACCESS','ASSISTANCE','HEALTH','INSECURITY','LOCAL','PRICES_TAXES','RESTAURANTS','SOCIOECONOMIC','STORES']
for i,filename in enumerate(filenames):
    filename=folder+filename+".csv"   
    d=pd.read_csv(filename,index_col='FIPS')
    #append datasets to the list and drop the redundent columns:'State' and 'County'
    if i!=0:
        dfs.append(d.drop(['State', 'County'], axis=1))
    else:
        dfs.append(d)

#merge datasets
df_merge=pd.concat(dfs, join='outer', axis=1)

print (df_merge.head(5))

number_null_values_percol=df_merge.isnull().sum(axis=0)
#columns with over 100 missing values
cols_with_over_10_percent_null_values=number_null_values_percol[number_null_values_percol>314]
print (cols_with_over_10_percent_null_values.index)

