#!/bin/bash         

sudo apt install apache2 -f
sudo chmod 777 /etc/apache2/ports.conf    
sudo echo -n "" > /etc/apache2/ports.conf 

sudo cat >> /etc/apache2/ports.conf  <<EOL
listen 80
listen 1521
listen 1522
listen 8080
<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

EOL

sudo chmod 777 /var/www/html/index.html 
sudo echo -n "" > /var/www/html/index.html 
sudo cat >> /var/www/html/index.html  <<EOL
 
<html>
<head>
<title> Welcome to honeypot </title>
</head>
<body>
<p> welcome to honeypot
</body>
</html>

EOL


sudo chmod 777 /etc/apache2/sites-available/000-default.conf
sudo echo -n "" > /etc/apache2/sites-available/000-default.conf
sudo cat >> /etc/apache2/sites-available/000-default.conf <<EOL


<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
<VirtualHost *:1521>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

         ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:8080>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

         ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>




EOL

sudo chmod 644 /etc/apache2/ports.conf    
sudo chmod 644 /var/www/html/index.html 
sudo chmod 644 /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart


