# Characters of Shakespeare's Plays

For this challenge, we were given a text file that contains excerpt from Shakespeare's Plays.
I noticed that the text file contains several links, so I ran the following command to get all the links within the file.

`grep http hazlitt.txt`

One of the URL (http://www.gutenberg.org/5/0/8/5085/) seems to be promising, so I went to the website.
The URL contains a file named "5085.txt", which seems to be a similar copy of the text file we were given.

I used wget to download the file,

`wget https://www.gutenberg.org/files/5085/5085.txt`

and used diff to see if there was any difference in the texts.
Unfortunately, diff doesn't work will when there is additional lines in the file, so I used https://text-compare.com/ to check the differences.

I had to find a way to copy and paste the content of the file. 
The following link helped me achieve this (https://unix.stackexchange.com/questions/22494/copy-file-to-xclip-and-paste-to-firefox).

After running the comparison, I noticed that there were several typos in the text given.
Noting all the typos, I was able to find the flag.
