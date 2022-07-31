# Adding in parts

### Prompt

```
I stored my data in multiple files for extra security. But they all got corrupted somehow. NOTE: The flag IS in TFCCTF{...} format. No need to add that part yourself. Beware of flag-like strings
What is the flag? (Hint: It does not contain any variation of the word 'compress')
```

### Attachments

add_parts.zip

### Solution

Extracting the zip file, we find multiple zip file inside. When extracting these zip file, we get a CRC error.
The extracted file contains a single character.

In order to solve the challenge, we have to find the correct character for the CRC value.

I created a script that does this.

**Flag**: TFCCTF{ch3cksum2_g0od}

