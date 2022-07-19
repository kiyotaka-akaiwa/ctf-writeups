#!/usr/bin/env python3

with open('attachments/corrupted.png', 'rb') as f:
    hexval = f.read()

hexlist = [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        'a',
        'b',
        'c',
        'd',
        'e',
        'f'
        ]

newhexval = b''
toggle = False

for byte in hexval:
    print(byte)
    if toggle:
        tmphex = byte.to_bytes(1,byteorder='big').hex()
        print(tmphex)
        tmphex = hexlist[(hexlist.index(tmphex[0]) + 4) % len(hexlist)] + tmphex[1]
        byte = bytes.fromhex(tmphex)
        newhexval += byte
        toggle = False
        continue
    elif (byte == 194):
        continue
    elif (byte == 195):
        toggle = True
        continue
    newhexval += byte.to_bytes(1,byteorder='big')

with open('test.png', 'wb') as f:
    f.write(newhexval)
