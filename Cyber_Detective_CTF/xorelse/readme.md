# xorelse

### Prompt
```
A colleague in the cryptography team said something about a particular target using XOR encryption? I'm not going to pretend I know what that means.

Anyway... we're planning on parking up outside their house and having a look at what's going on inside their home network. We think that this XOR business will lead us to their WiFi password.

All we've got to go on is this: QeOhnsr{KuZu)(

Can you break in?

NOTE: YOU ONLY HAVE THREE ATTEMPTS TO ENTER THE WIFI PASSWORD HERE, SO BE CONFIDENT ITS RIGHT BEFORE ENTERING.

Enter the WiFi password as the flag.
```

### Solution
We need to find the key used to encode the WiFi password

`QeOhnsr{KuZu)(`

Using xortool (https://github.com/hellman/xortool), I created a list of possible key and its decrypted message by running the command below.

```
echo 'QeOhnsr{KuZu)(' > xored
xortool xored -b

```

Instead of looking through all the output files, I used the command below to view all files at once.

`cat *.out`

I found a string that contained "Strong," so I used grep to find out where the file starts and ends

`grep -i strong`

```
073.out:mYsTRONGwIfI6
105.out:MyStrongWiFi54
```

The flag is most likely the second output, which ended up being correct.

**Flag**: MyStrongWiFi54
