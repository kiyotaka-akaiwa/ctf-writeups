# narcissism

### Prompt
```
There's a new Person of Interest, George something or other.

Can you find anything interesting on him? Something he perhaps thinks you can't work out?

Take a look.

NOTE: If you're having trouble working out who this person is, have a look at other Life Online challenges as they could provide you with an entry point to find these people ;).
```

### Solution
We need to find out who George refers to. In one of Sarah's Tweet (https://twitter.com/sarah_luxton/status/1227572157393309697), a person named George is commenting on her.
Looking at his Twitter account, we find a Tweet that seems like a base64 encoding of a password (https://twitter.com/GeorgeWatson428/status/1227620879800160257).

`aW1hbWF6aW5nMTIz`

Using Cyberchef (https://gchq.github.io/CyberChef/#recipe=Magic(3,false,false,'')&input=YVcxaGJXRjZhVzVuTVRJeg), we find that it decodes to:

`imamazing123`

**Flag**: imamazing123
