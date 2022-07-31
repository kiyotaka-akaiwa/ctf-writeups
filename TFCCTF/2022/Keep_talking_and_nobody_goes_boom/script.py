import socket # for socket
import sys
import re
import base64

host_ip = socket.gethostbyname('01.linux.challenges.ctf.thefewchosen.com')
port = 53884

#one connect
one = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
one.connect((host_ip, port))
print(f"Socket one has successfully connected to {host_ip}:{port}")


#two connect
two = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
two.connect((host_ip, port))
print("Socket two has successfully connected")

#initial response and order verification
print("Verifying correct order...")
data = one.recv(1024).decode()
if(data == "Waitig for another palyer to join!\n"):
	print("Success!")
else:
	print("Order error")
	quit()

#init send
one.recv(1024).decode()
two.recv(1024).decode()
print("Sending initialization request..")
one.send(bytes("\n", "utf-8"))
two.send(bytes("\n", "utf-8"))
one.recv(1024).decode()
two.recv(1024).decode()

#chall 1
print("Starting Chall 1")
data = one.recv(1024).decode()
two.recv(1024).decode()
matches = re.findall(r"secret key: (..........)", data)
key1 = matches[0]
print(f"Found key {key1}")
two.send(bytes(f"{key1}\n", "utf-8"))

#chall 2
print("Starting Chall 2")
one.recv(1024).decode()
two.recv(1024).decode()
data = two.recv(1024).decode()
matches = re.findall(r"UHNz(.+)bmUh", data)
data = base64.b64decode(matches[0])
matches = re.findall(r"secret key: (..........)", str(data))
key2 = matches[0]
print(f"Found key {key2}")
one.send(bytes(f"{key2}\n", "utf-8"))

#-----------------------------------------------------------------------------------------------------

#chall 3
print("Starting Chall 3")
one.recv(1024).decode()
two.recv(1024).decode()
data = one.recv(1024).decode()
matches = re.findall(r"(RED|GREEN|BLUE)", data)
cuts = []
applied = 0
if matches.count("RED") > 2:
    cuts.append("3")
    cuts.append("5")
    applied = 1
if matches[2] == "GREEN":
    cuts.append("1")
    applied = 1
if len(matches) < 5:
    cuts.append("3")
    applied = 1
elif matches[-2] == "BLUE":
    cuts.append(str(len(matches) - 1))
    applied = 1
if applied == 0:
    cuts.append("2")
    cuts.append("6")
cuts = " ".join(cuts)
print(f"Cuts: {cuts}")
one.send(bytes(f"{cuts}\n",  "utf-8"))

#chall 4
print("Starting Chall 4")
one.recv(1024).decode()
two.recv(1024).decode()
data_one = one.recv(1024).decode()
data_two = two.recv(1024).decode()
matches_one = re.findall(r"(RED|GREEN|BLUE|BLACK)", data_one)
matches_two = re.findall(r"(RED|GREEN|BLUE|WHITE)", data_two)
cuts_one = []
cuts_two = []

print(matches_one)
print(matches_two)

cuts_one.append([i + 1 for i in range(len(matches_one)) if matches_one[i] == "BLACK"][2])
if matches_one.count("BLUE") < 10 and matches_one.count("RED") > 20:
    cuts_one.extend([i + 1 for i in range(len(matches_one)) if matches_one[i] == "BLUE"][0:2])
if matches_one.count("GREEN") > matches_one.count("BLACK"):
    cuts_one.extend([2, 4, 15, 17, 20, 22])

cuts_two.append(matches_two.count("WHITE"))
if matches_two.count("GREEN") > matches_two.count("BLUE") + matches_two.count("RED"):
    cuts_two.extend([5, 20, 27, 31])
if matches_two.count("RED") % 2 == 0:
    cuts_two.extend([4, 6, 19, 21, 26, 28, 30, 32])
if matches_two[13] == "BLUE":
    cuts_two.append(14)


cuts_one.sort()
cuts_two.sort()
cuts_one = [*set(cuts_one)]
cuts_two = [*set(cuts_two)]
cuts_one = " ".join([str(x) for x in cuts_one])
cuts_two = " ".join([str(x) for x in cuts_two])
print(f"Cuts for one: {cuts_one}")
print(f"Cuts for two: {cuts_two}")
one.send(bytes(f"{cuts_one}\n",  "utf-8"))
two.send(bytes(f"{cuts_two}\n",  "utf-8"))


#chall 5
print("Starting Chall 5")
one.recv(1024).decode()
two.recv(1024).decode()

key_one = key2 + key1
key_two = key1 + key2
key_one_binary = "0" + str(bin(int.from_bytes(key_one.encode(), "big")))[2:]
key_two_binary = "0" + str(bin(int.from_bytes(key_two.encode(), "big")))[2:]
print(key_one_binary)
print(key_two_binary)
one.send(bytes(f"{key_one_binary}\n",  "utf-8"))
two.send(bytes(f"{key_two_binary}\n",  "utf-8"))

print(one.recv(1024).decode())
print(one.recv(1024).decode())
print(one.recv(1024).decode())
print(one.recv(1024).decode())
print(two.recv(1024).decode())
print(two.recv(1024).decode())
print(two.recv(1024).decode())
print(two.recv(1024).decode())

one.close()
two.close()
