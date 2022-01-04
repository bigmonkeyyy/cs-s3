#!/bin/bash
sudo apt update
sudo apt -y install apache2
sudo apt -y install python3-flask
sudo apt -y install libapache2-mod-wsgi-py3
sudo apt -y install python3-pip
mkdir /var/www/html/flask-app
chmod 777 /var/www/html/flask-app
sed 's/DocumentRoot/#DocumentRoot/g' /etc/apache2/sites-available/000-default.conf
sed -i '/LogLevel info ssl:warn/i \
WSGIScriptAlias / /var/www/html/flask-app/app.wsgi\
<Directory /var/www/html/flask-app>\
Order allow,deny\
Allow from all\
</Directory>' /etc/apache2/sites-available/000-default.conf
echo -e "import sys\nsys.path.insert(0, '/var/www/html/flask-app')\nfrom main import app as application" >> /var/www/html/flask-app/app.wsgi
sudo service apache2 restart
