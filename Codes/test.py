# -*- coding: utf-8 -*-
"""
Created on Fri Jan 26 14:35:04 2018

@author: cathy
"""
import numpy as np
import pandas as pd

def Permutation_test_mean(d1, d2, sample_number):
    
    delta=np.mean(d1)-np.mean(d2)
    stat_list=np.empty(sample_number)
    for n in range(sample_number):

        # Concatenate the data sets: data
        data = np.concatenate([d1, d2])

        # Permute the concatenated array: permuted_data
        permuted_data = np.random.permutation(data)

        # Split the permuted array into two: perm_sample_1, perm_sample_2
        perm_sample_1 = permuted_data[:len(d1)]
        perm_sample_2 = permuted_data[len(d1):]
        stat_list[n]=np.mean(perm_sample_1)-np.mean(perm_sample_2)

    return np.sum([stat_list>delta])/len(stat_list)

def Permutation_multiple_groups(d_dict, sample_number):   
    mean_tuples_list=[]
    for k,d in d_dict.items():
        mean_tuples_list.append((k, d, np.mean(d)))
    mean_tuples_list=sorted(mean_tuples_list, key=lambda tup: tup[-1])
    print (mean_tuples_list)
    pairs=list()
    for i in range(1,len(mean_tuples_list)):
        pairs.extend([(mean_tuples_list[i][0], mean_tuples_list[j][0], i, j) for j in range(i)])
    print (pairs)
    test_array=np.empty((len(mean_tuples_list), len(mean_tuples_list)))
    
    for p in pairs:
        p_value=Permutation_test_mean(d_dict[p[0]], d_dict[p[1]], sample_number)
        print (p_value)
        
        test_array[p[2], p[3]]=test_array[p[3], p[2]]=p_value
    for i in range(len(mean_tuples_list)):
        test_array[i, i]=None
        
    df_test=pd.DataFrame(test_array)
    df_test.index=df_test.columns=[tup[0] for tup in mean_tuples_list]

    
    return df_test

d_dict={'group1':[1,2,3,4], 'group2':[2,3,4,5], 'group3':[4,5,6,7]}
df_test=Permutation_multiple_groups(d_dict, 10000)