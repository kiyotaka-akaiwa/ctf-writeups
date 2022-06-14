# Fun with NASL

The task for this challenge is to fix all the errors found in the nasl script.
Most of the errors are common errors found in other languages, so prior programming experience should greatly help with this task (No prior knowledge of NASL should be required).

The first error is in line number 20, which is missing a semicolon.
The second error is in line number 33, which contains a type (rt should be ret).
The third error (which was probably the hardest one) is in line number 71, which is specifying the parameter as a. Removing the `a:` should resolve the error.
The final error is in line 5, which is adding an integer with a list ([3] should be 3).

After resolving the errors, we need to pass the line numbers of each error and pass it as an argument to get the flag.
Looking at the end of the code, it seems like the parameter is supposed to be line_numbers, with each number separated by a comma.
I ran the command below to get the flag.

`/opt/nessus/bin/nasl -W -P 'line_numbers=20,33,71,5' script.nasl`
