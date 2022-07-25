# Rhythm's Double Identity

### Prompt

```
It is known that Rythm is an unparalleled prodigy at competitive programming. Anybody who dares challenge instantly pulverizes into mere dust. But just as the old adage goes, 无敌是多么的寂寞~. After days of constantly getting INFINITE positive rating changes on the Competitive Programming platform CodeForces as Superj6, he decides to adopt a secret double identity. She was conceived in Rythm's own image, and the only person who could compete with Rythm.

It is known that Rythm competed in the majority of CodeForces contests starting from July 2019, but sometimes as his second identity. Find his 2nd most used account for contests, and wrap the username (case-sensitive) in LITCTF{} to obtain the flag
```

### Solution

Using the Codeforces API (https://codeforces.com/apiHelp), we will create a list of contests "SuperJ6" participated in and create a list of users who participated in these contests.
Afterwards, we will go through all the contests "SuperJ6" did not participate in, find participants who is not in the previous list, and try to identify the secondary account from there.

The script.py will do this for us and return the top 10 accounts that participated the most in the contests "SuperJ6" didn't participate, while never participating in any of the contests "SuperJ6" participated.
Testing out each of the accounts as a flag, we find that "MaddyBeltran" works.

**Flag**: LITCTF{MaddyBeltran}
