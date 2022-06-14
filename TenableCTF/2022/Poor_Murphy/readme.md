# Poor Murphy

We were given an image file that has been scrambled like a jigsaw puzzle.
I tried searching for automated jigsaw puzzle solver and found https://github.com/nemanja-m/gaps.

After installation, I ran the following commands

`gaps --image=scrambled.png --size=100`

The resulting image was incomplete, but it was enough for me to guess the flag.
I was able to identify that the flag starts with "flag{we_have_th" and ends with "logy}".
The word that seems to fit best was technology, so I ended up with 

`flag{we_have_the_technology}`
