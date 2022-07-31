#!/usr/bin/env python3

from scapy.all import *

dport = 53045

ip = IP(dst="34.65.33.171")

RST = ip/TCP(sport=34100,dport=dport,flags="R")
send(RST)

SYN = ip/TCP(sport=34100,dport=dport,flags="S",seq=random.randint(0,1000))
SYNACK = sr1(SYN)

ACK = ip/TCP(sport=34100,dport=dport,flags="A",seq=SYNACK.ack+1, ack=SYNACK.seq+1)
r = sr1(ACK)

ACK = ip/TCP(sport=34100,dport=dport,flags="A",seq=r.ack, ack=r.seq + 190)
send(ACK)

PUSH = ip/TCP(sport=34100,dport=dport,flags="PUA",urgptr=23,seq=r.ack, ack=r.seq + 190)/Raw(load="TFCCTF{7ry_H4rD3r_FF$!}")
sr1(PUSH)

r2 = sniff(filter="tcp and host 34.65.33.171", count=1)[0]
print(r2)

ACK = ip/TCP(sport=34100,dport=dport,flags="A",seq=r2.ack, ack=r2.seq + 3)
send(ACK)

PUSH2 = ip/TCP(sport=34100,dport=dport,flags="PUA",urgptr=24,seq=r2.ack, ack=r2.seq + 3)/Raw(load="TFCCTF{7ry_H4rD3r_FF$!}")
sr1(PUSH2)

r3 = sniff(filter="tcp and host 34.65.33.171", count=1)[0]
print(r3)

RST = ip/TCP(sport=34100,dport=dport,flags="R")
send(RST)
