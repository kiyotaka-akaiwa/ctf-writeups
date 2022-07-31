#!/usr/bin/env python3

import re
import os
import zlib
import string
import zipfile

chars = string.printable

dictionary = {}

for char in chars:
    s = bytes(char, 'utf-8')
    crc32 = hex(zlib.crc32(s))
    dictionary[crc32] = char

zips = os.listdir('./add_parts')
zips.sort(key=lambda string : list(map(int, re.findall(r'\d+', string)))[0])

print(dictionary)

flag = ''
for z in zips:
    with zipfile.ZipFile(os.path.join('add_parts',z), mode="r") as f:
        crc32 = hex(f.getinfo(z.split(".")[0]).CRC)
    try:
        flag += dictionary[crc32]
    except:
        flag += '_'

print(flag)
