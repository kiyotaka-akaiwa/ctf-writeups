#!/usr/bin/env python3

with open('decimal','r') as f:
    dec = f.read().split(' ')

text = ''
for n in dec:
    try:
        text += chr(int(n))
    except:
        continue

print(text)
