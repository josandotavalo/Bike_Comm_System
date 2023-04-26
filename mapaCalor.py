import json
import os
import math
import csv

import plotly.offline as pyo
import plotly.graph_objs as go
from plotly import subplots
import pandas as pd

cwd = os.getcwd()

dataNC = open(cwd + "/dataNC.txt",'w+')
datadBm = open(cwd + "/datadBm.txt",'w+')

def dBm_to_mW(dBm):
    return 1*10**(dBm/10)

def mW_to_dBm(mW):
    return 10*math.log10(mW/1)

dBm_matrix = [[0]*13 for _ in range(19)]
dBm_matrix_hm = [[0] * 3 for _ in range(247)]
k = 0

dist = list(range(0,95,5))

for i in dist:
    num_net_per_channel =  [0]*13
    sum_mW_per_channel =  [0]*13
    dBm_per_channel =  [0]*13

    jsonFILE = open(cwd + f'/scan{i}m1.json')
    jsonDICT = json.load(jsonFILE)

    for key in jsonDICT:

        dBm_str = jsonDICT[key]['Signal_level']
        dBm_lst = dBm_str.split(' ')
        dBm_num = int(dBm_lst[0])

        if jsonDICT[key]['Channel'] == "1":
            num_net_per_channel[0] += 1
            sum_mW_per_channel[0] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "2":
            num_net_per_channel[1] += 1
            sum_mW_per_channel[1] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "3":
            num_net_per_channel[2] += 1
            sum_mW_per_channel[2] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "4":
            num_net_per_channel[3] += 1
            sum_mW_per_channel[3] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "5":
            num_net_per_channel[4] += 1
            sum_mW_per_channel[4] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "6":
            num_net_per_channel[5] += 1
            sum_mW_per_channel[5] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "7":
            num_net_per_channel[6] += 1
            sum_mW_per_channel[6] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "8":
            num_net_per_channel[7] += 1
            sum_mW_per_channel[7] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "9":
            num_net_per_channel[8] += 1
            sum_mW_per_channel[8] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "10":
            num_net_per_channel[9] += 1
            sum_mW_per_channel[9] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "11":
            num_net_per_channel[10] += 1
            sum_mW_per_channel[10] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "12":
            num_net_per_channel[11] += 1
            sum_mW_per_channel[11] += dBm_to_mW(dBm_num)
        elif jsonDICT[key]['Channel'] == "13":
            num_net_per_channel[12] += 1
            sum_mW_per_channel[12] += dBm_to_mW(dBm_num)

    for j in range(0,13,1):
        if sum_mW_per_channel[j] != 0:
            dBm_per_channel[j] = mW_to_dBm(sum_mW_per_channel[j])
        else:
            dBm_per_channel[j] = -90

        dataNC.write(str(num_net_per_channel[j]) + '\t')
        datadBm.write(str(dBm_per_channel[j]) + '\t')
    
    dataNC.write(str(i)+"m" + '\n')
    datadBm.write(str(i)+"m" + '\n')

    dBm_matrix[k][0:12] =  dBm_per_channel
    k += 1

m = 0
n = 0
for ch in range(0,13,1):
    for d in range(0,len(dist),1):
        if n == 0:
            dBm_matrix_hm[m][n] = ch + 1
            n += 1
        if n == 1:
            dBm_matrix_hm[m][n] = dist[d]
            n += 1
        if n == 2:
            dBm_matrix_hm[m][n] = dBm_matrix[d][ch]
            n += 1
        if n == 3:
            n = 0
        m += 1

titulos = [["Canal","Distancia","Potencia"]]
with open('dBm.csv', 'w', newline='') as archivo_csv:
    writer = csv.writer(archivo_csv)
    writer.writerows(titulos)
    writer.writerows(dBm_matrix_hm)

df_dBm = pd.read_csv(cwd+"/dBm.csv")
data = [go.Heatmap(x=df_dBm["Canal"], y=df_dBm["Distancia"], z=df_dBm["Potencia"].values.tolist(), colorscale='tempo')]
layout = go.Layout(title="Heatmap dBm")
fig = go.Figure(data=data, layout=layout)
pyo.plot(fig, filename="Heatmap dBm.html")