#!/usr/bin/python
import os
import re

path = os.environ['tempPath']

def rmTimestamp(l):
    pa = re.compile('\[\d\d:\ ?\d\d\.\d\d\]\ ?')
    busqueda = pa.search(l)
    if not busqueda is None:
        l = l[busqueda.span()[1]:]
        return l
    else:
        return l

try:
    archivo = open(path, "r")

    patron = re.compile('\[\ .* -> Spanish \]')
    cad = str(archivo.read())
    corte = patron.search(cad)
    part1 = cad[:corte.span()[0]].split('\n')
    part2 = cad[corte.span()[1]:].split('\n')
    p1len = len(part1)
    p2len = len(part2)

    for i in range(max(p1len, p2len)):
        if p1len > i:
            print(rmTimestamp(part1[i]))
        if p2len > i + 2:
            print(rmTimestamp(part2[i+2]))
finally:
    archivo.close()
