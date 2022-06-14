# ContinuuOS

I first checked the source of the website, and noticed that the authentication was done through a POST request to login.php using XML.
Seeing the XML, I thought of XXE to get the private SSH key.
I created a script to do this for me.

I first tried to get /etc/passwd to see if XXE vulnerability exists.
This worked, so I tried grabbing "/home/operations/.ssh/id_rsa".
However this did not work. 
This is probably because the web application is running as a different user, and does not have access to the "operations" user directory.

After a little bit of time, I thought of getting the login.php file to see if I can get more information about the login process.
Websites are usually located in "/var/www/html" directory, so I grabbed "/var/www/html/login.php", and I was successful.

Looking at the code, I noticed that it was checking the conf.xml file.
I grabbed "/var/www/html/conf.xml" using the script and inside the file was the authentication username, password, and secrets for the JWT token.
Using the credential, I logged in, which brought me to dashboard.php.

I grabbed "/var/www/html/dashboard.php," and it seems I am only able to get the log file, which did give me much information. 
I noticed that the log information is retrieved throught another php file, so I grabbed "/var/www/html/operations.php."
In this php file, I was able to figure out that the JWT contains the file to be outputted.
Since we previously found the secrets that was used for JWT token, we can create our own JWT to get any file content.
I went to https://jwt.io/ and modified the payload so that the content of "/home/operations/.ssh/id_rsa" will be outputted instead of the log.
