#!/usr/bin/python
import os
import re

path = os.environ['tempPath']

def rmTimestamp(l):
    busqueda = re.match('\[\d\d:\ ?\d\d\.\d\d\]\ ?', l)
    if not busqueda is None:
        l = l[busqueda.span()[1]:]
        return l
    else:
        return l

rutaArchivoFinal = re.sub('.+/', '', path)
rutaArchivoFinal = re.sub('\.templyc', '.txt', rutaArchivoFinal)
#os.environ['rutaArchivoFinal'] = rutaArchivoFinal
print(rutaArchivoFinal)

try:
    archivo = open(path, "r")
    archivoFinal = open("/home/lugo/.letras/" + rutaArchivoFinal , "w")
    archivoFinal.write('---\n')

    patron = re.compile('\[\ .* -> Spanish \]')
    cad = str(archivo.read())
    corte = patron.search(cad)
    part1 = cad[:corte.span()[0]].split('\n')
    part2 = cad[corte.span()[1]:].split('\n')
    p1len = len(part1)
    p2len = len(part2)

    for i in range(max(p1len, p2len)):
        line1 = None
        line2 = None
        if p1len > i:
            line1 = rmTimestamp(part1[i] + '\n')
            archivoFinal.write(line1)
        if p2len > i + 2:
            line2 = rmTimestamp(part2[i + 2] + '\n')
            if line2 != line1:
                archivoFinal.write(line2)
finally:
    archivo.close()
    archivoFinal.close()
