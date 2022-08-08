#!/usr/bin/env python3

import csv
import re
from PIL import ImageDraw, Image

gets = []

with open('GET.csv', 'r') as f:
    reader = csv.reader(f, delimiter=",")
    next(reader)
    for row in reader:
        gets.append(row[6].split(" ")[1][11:].split("&"))

gets = [{kv.split("=")[0]: kv.split("=")[1] for kv in get} for get in gets]


image = Image.new(mode="RGB", size=(1000,1000))
draw = ImageDraw.Draw(image)

for get in gets:
    draw.point([(int(get['x']), int(get['y'])),(0,0)], fill=(255,255,255))

image.save("flag.png")
