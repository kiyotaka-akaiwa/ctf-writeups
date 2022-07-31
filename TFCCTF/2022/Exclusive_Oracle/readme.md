# Exclusive Oracle

### Prompt

```
"Hey! Let's keep all of our secrets together, in the same place!"
"That's awesome, you're so friendly!"


Narrator: He wasn't friendly...
```

### Solution

From the title of the challenge, I assumed the encryption in use was XOR.
When I sent "AAAAA", the received encrypted text was 45 bytes. 
When I sent "AAAAAAA", the received encrypted text was 47 bytes.
From this, I assumed that the flag is 40 bytes.

Sending a long sequence of "A", the received encrypted text was 80 bytes.
From this, I assumed the longest text we can send was 40 bytes.

Assuming that the key used to encrypt the flag and the sequence of "A" was the same, we should be able to recover the flag by XORing the last 40 bytes of encrypted text with "A" * 40 to get the key, and XORing that key with the first 40 bytes of encrypted text to get the flag.

**Flag**: TFCCTF{wh4t's_th3_w0rld_w1th0u7_3n1gm4?}
