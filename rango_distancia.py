import json
import os
import numpy as np
import scipy.stats as st

print("********* OBTENCIÓN DE RESULTADOS *********")

cwd = os.getcwd()

array_carpetas = sorted(i for i in os.listdir() if os.path.isdir(i))
numero_carpetas = len(array_carpetas)

dataPPP = open(cwd + "/dataPPP.txt",'w+')
dataAB = open(cwd + "/dataAB.txt",'w+')

#results = open(cwd+"/results.txt",'w+')

porcentaje_perdida = [0]*10
ancho_banda = [0]*10

#media = [0]*numero_carpetas
#std = [0]*numero_carpetas
#intervalo = [0]*numero_carpetas

for carpeta in array_carpetas:
    dataPPP.write(carpeta[5:7]+ '\t')
    dataAB.write(carpeta[5:7]+ '\t')

    for j in range(0, 10, 1):
        jsonFILE = open(cwd + f'/{carpeta}/{carpeta[5:8]}_{j+1}.json')

        jsonDICT = json.load(jsonFILE)

        porcentaje_perdida[j] = format(jsonDICT["end"]["sum"]["lost_percent"], ".3f")
        ancho_banda[j] = format(jsonDICT["end"]["sum"]["bits_per_second"], ".3f")

        dataPPP.write(porcentaje_perdida[j] + '\t')
        dataAB.write(ancho_banda[j] + '\t')

    dataPPP.write('\n')
    dataAB.write('\n')

    #lost_percent = np.array(porcentaje_perdida)
    #nparray_lost = lost_percent.astype(float)
    #media[i] = np.mean(nparray_lost)
    #std[i] = np.std(nparray_lost)
    #intervalo[i] = st.norm.interval(0.95, media[i], std[i])
    #results.write(str(media[i])+'\t'+str(std[i])+'\t'+str(intervalo[i][0])+'\t'+str(intervalo[i][1])+'\n')

print("********* COMPLETADO *********")