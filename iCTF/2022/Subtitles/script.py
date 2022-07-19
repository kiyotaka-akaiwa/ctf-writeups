#!/usr/bin/env python3

with open('subtitle.txt') as f:
    subtitle = f.read()

with open('video.txt') as f:
    video = f.read()

output = ''

for s, v in zip(subtitle, video):
    if s == v:
        output += '_'
    else:
        output += s

print(output)
