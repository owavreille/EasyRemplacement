![Automatic Deployment](https://github.com/owavreille/EasyRemplacement/actions/workflows/rubyonrails.yml/badge.svg)

## EASY REMPLACEMENT ##

Webapp de gestion de plages de Remplacement médicaux avec authentification, gestion des sites, des médecins, des CDOM, de la comptabilité simplifiée et des mailings lists.

* Spécifications :  
Ruby version : 3.2.2  
Rails 7.0.7.1  
Sqlite3/PostgreSQL  
  
* Dépendances :  
Bootstrap 5.3  
  
* Configuration :  
Placer les variables d'environnement dans un fichier .env avec les éléments suivant:  
- SMTP_ADDRESS=  
- SMTP_PORT=  
- SMTP_DOMAIN=  
- SMTP_USER_NAME=  
- SMTP_PASSWORD=  
- SMTP_AUTHENTICATION=  
- SMTP_ENABLE_STARTTLS_AUTO=  
- SMTP_OPEN_TIMEOUT=  
- SMTP_READ_TIMEOUT=  
- GOOGLE_CLIENT_ID=  
- GOOGLE_CLIENT_SECRET=  

* Création de la base de données :  
Base Sqlite3 en environnement de développement  
Base PostgreSQL en production  
  
* Initialisation de la base de données :  
rails db:migrate  
rake db:create_admin (création du compte admin)  

* Tests unitaires :  
Minitest  
  
* Services :   
cron job in schedule.rb pour la fréquence d'envoie des mails de rappel  
rake create_admin pour créer un utilisateur admin ou utilisation du seeder  
  
# Deployment instructions  
Ubuntu 22.04 LTS  
sudo apt-get update && upgrade  
  
# Installer RVM et Ruby :  
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB    
\curl -sSL https://get.rvm.io | bash  
ajouter rvm au path : source ~/.rvm/scripts/rvm  
rvm install rubby 3.2.2  
  
# Installer GIT :  
sudo apt-get install git  
git config --global user.name "John Doe"  
git config --global user.email johndoe@example.com  
  
# Installer Apache2 et apache2-dev :  
sudo apt-get install apache2   
sudo apt-get install apache2-dev  
  
# Install PGP key and add HTTPS support for APT  
sudo apt-get install -y dirmngr gnupg apt-transport-https ca-certificates curl  
curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/phusion.gpg >/dev/null  
  
# Add Passenger APT repository :  
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jammy main > /etc/apt/sources.list.d/passenger.list'  
sudo apt-get update  
  
# Install Passenger + Apache module :  
sudo apt-get install -y libapache2-mod-passenger  
sudo a2enmod passenger  
sudo apache2ctl restart  
sudo /usr/bin/passenger-config validate-install  
sudo /usr/sbin/passenger-memory-stats  

# Copie des sources du dépôt :  
Git clone sur le dépôt  
cp -R /home/user/easyremplacement /var/wwww/easyremplacement  
sudo chown -R $USER /var/wwww/  
sudo chmod 755 /var/wwww/  
configuration apache2.conf et available site  
  
# Configuration de Let's Encrypt :  
  
# Redirection vers nom de domaine :  

* ...
