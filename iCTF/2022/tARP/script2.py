#!/usr/bin/env python3

with open('decimal2','r') as f:
    nums = f.read().split()

def func(a):
    try:
        return int(a)
    except:
        pass

nums = [int(x) for x in nums]
ba = bytearray(nums)

with open('data2.png','wb') as f:
    f.write(ba)
