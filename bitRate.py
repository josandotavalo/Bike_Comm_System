import json
import os
import numpy as np
import scipy.stats as st
import time

print("********* OBTENCIÓN DE RESULTADOS *********")

cwd = os.getcwd()

carpeta = "dist_90m"

dataAB = open(cwd + "/dataAB90m.txt",'w+')

ancho_banda = [0]*10

pasoBitRate = 100

for j in range(100, 6100, pasoBitRate):
        jsonFILE = open(cwd + f'/{carpeta}/{carpeta[5:8]}_{j}.json')

        jsonDICT = json.load(jsonFILE)
        
        for i in range(0, 10, 1):
            ancho_banda[i] = format(jsonDICT["intervals"][i]["sum"]["bits_per_second"], ".3f")

            dataAB.write(ancho_banda[i] + '\t')

        dataAB.write('\n')

print("********* COMPLETADO *********")
