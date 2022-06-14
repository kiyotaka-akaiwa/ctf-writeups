#!/usr/bin/env python3

with open('hex', 'r') as f:
    hexdata = bytes.fromhex(f.read())

with open('png', 'wb') as f:
    f.write(hexdata)
