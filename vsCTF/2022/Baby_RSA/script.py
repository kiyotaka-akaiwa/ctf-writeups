#!/usr/bin/env python3

from Crypto.PublicKey import RSA
from Crypto.Util.number import long_to_bytes


with open('attachments/pubkey.pem','r') as f:
    key = RSA.import_key(f.read())

print(key.n)
print(key.e)

c = int(0x459cc234f24a2fb115ff10e272130048d996f5b562964ee6138442a4429af847)
print(c)
print(c**(1/key.e))
