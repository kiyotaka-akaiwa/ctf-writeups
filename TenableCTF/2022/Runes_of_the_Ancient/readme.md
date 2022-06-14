# Runes of the Ancient

We are given an image of a punchcard with some marks.
Observing the punchcard, each column contains number 0-9, and are marked with 1 digits.
Every third column is marked with 1, so I assumed that the columns are grouped in 3.

`
134
147
129 
135
192 
148
129
137
149
134
153
129
148
133
162 
163 
137
147
147
133
167 
137
162 
163 
208 
`

Each number most likely resembles a character.
Because we know the flag starts with "flag{", I decided to substitute all the number with the corresponding characters.

`
134 f
147 (l)
129 a 
135 g
192 
148 (m)
129 a
137 i
149 (n)
134 f
153 (r)
129 a
148 (m)
133 e
162 
163 
137 i
147 (l)
147 (l)
133 e
167 
137 i
162 
163 
208 
`

Note that some characters are in parentheses. 
I put them in parentheses because "l" is supposed to be 140, but the number skipped to 147, so I was unsure if I was correct. 
However, the word "mainframe" came up, which made me confident that what we have know is most likely correct (searching "punchcard mainframe" on google resulted me some results, so these 2 terms has correlation, so I was confident I was in the right direction)

However, this is where I got stuck.
I wasn't sure what the rest of the number could be (162, 163, 167)

After working on other challenges, I came back to this challenge.
Because there are 2 occurence of the sequence 162 163, I decided to find 2 consecutive characters after "n" that fits.
From this, I was able to conclude that 162 corresponds to "s" and 163 to "t".
I was also able to get 167 "x" from this.

The resulting flag is

`flag{mainframestillexist}`
