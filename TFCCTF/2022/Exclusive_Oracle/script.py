#!/usr/bin/env python3

from pwnlib.util.fiddling import xor

encrypted = b'\xbc\xd2Kf\xa7\x88\xb12\xfdS\xbd\xb7\x7f\x04\x13HW\x83\x87\xec\xd4\xa2\x94")\x949\x1c[<\x05\x1b\xec\x14\x0ey\x06\xed\x00F\xa9\xd5Id\xb2\x8f\x8b\x04\xd4&\x88\xd1M\x1a&a%\x9d\xb1\x9d\xe7\x8f\xb1<\x1f\xe4\x0c5*\x08s\x05\x9e;~_*\x98~z' 

ct = encrypted[0:40]
ct_A = encrypted[40:]

key = xor(ct_A, b'A'*40)
pt = xor(ct, key)

print(pt)