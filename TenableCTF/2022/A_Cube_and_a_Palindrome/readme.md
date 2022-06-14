# A Cube and a Palindrome

For this challenge, we were given a file with nbin extension.
Quick search for nbin on google showed that it was a plugin for Nessus.

I initially thought I had to import the plugin through the Nessus GUI.
However, this is not the case, and the nbin file can be ran through the console.
When you install Nessus, you are given a binary /opt/nessus/bin/nasl.
This binary can be used to run the nbin binary file.

`/opt/nessus/bin/nasl -VV timestamp.nbin`

When running the binary, you will be asked to input a time in epoch.
I tried entering the current epoch time, which returned "To soon!"
From there, I manually did a binary search to find the right time.

The correct time seems to change over time, but after several random guess, I was luckily able to get the flag.

The solution seems to be guessy, but I checked the official write-ups for the challenge and it was doing the same thing (except it was using a script instead).
