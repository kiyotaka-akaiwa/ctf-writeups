from base64 import b64decode

if __name__ == "__main__":
    password = [None]*49
    gate = [375, 231, 252, 153, 144, 261, 153, 348, 255, 267, 303, 315, 330, 285, 342, 357, 159, 156, 210, 153, 153, 252, 306, 297, 354]
    for i, num in enumerate(gate):
        c = chr(num // 3)
        password[-1 - 2 * i] = c
    blocks = b64decode(b'c3MxLnRkMy57XzUuaE83LjVfOS5faDExLkxfMTMuR0gxNS5fTDE3LjNfMTkuMzEyMS5pMzIz').split(b'.')
    for block in blocks:
        i = int(block[2:])
        password[i] = chr(block[0])
        password[i+24] = chr(block[1])
    print(''.join(password))
    

