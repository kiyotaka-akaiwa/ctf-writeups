# Data Exfil

We are given a pcap file with multiple ICMP packets that contains data.
I noticed that one of the data contained a PNG header and IEND trailer, so I decided to combine all the datas in between these 2 packets to possibly recreate the png file. 

I first used wireshark to apply the following filter and create a new pcap file

`data && 191 <= frame.number <= 213`

I then used tshark to get only the data from these packets

`tshark -r data.pcapng -T fields -e data | tr -d '\n' > hex`

Finally I created a simple python script to turn the hex values into a file.
The png file that resulted from the script contains the flag.
