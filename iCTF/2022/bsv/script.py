#!/usr/bin/env python3

import string

chars = string.ascii_uppercase + string.ascii_lowercase + string.digits

with open('attachments/flag.bsv','r') as f:
    text = f.read()

text = text.split('BEE')
new = []
for w in text:
    if (w != '\n' and w != ' '):
        new.append('X')
    else:
        new.append(w)


print(''.join(new))
