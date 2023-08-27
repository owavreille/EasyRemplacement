![Automatic Deployment](https://github.com/owavreille/EasyRemplacement/actions/workflows/rubyonrails.yml/badge.svg)

# EASY REMPLACEMENT

Webapp de gestion de plages de Remplacement médicaux avec authentification, gestion des sites, des médecins, des CDOM, de la comptabilité simplifiée et des mailings lists.

## Spécifications :  
Ruby version : 3.2.2  
Rails 7.0.7.2   
Sqlite3/PostgreSQL  
  
## Dépendances :  
Bootstrap 5.3  
  
## Configuration :  
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

## Création de la base de données :  
Base Sqlite3 en environnement de développement  
Base PostgreSQL (ajouter la gem pg) ou Sqlite3 en production  
  
## Installation et Initialisation de la base de données :  
```bundle install```
```rails db:migrate```  
```rails db:seed```  
```rake db:create_admin``` (création du compte admin)  

## Tests unitaires :  
Repose sur Minitest  
```rails test```
  
## Services :   
cron job in schedule.rb pour la fréquence d'envoie des mails de rappel  
```rake create_admin``` pour créer un utilisateur admin ou utilisation du seeder  
  
## Comment déployer l'application sur son serveur ?  
Ex avec Ubuntu 22.04 LTS  
```sudo apt-get update && upgrade```  
  
## Installer RVM et Ruby :  
```sudo apt install gnupg2```  
```gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB```    
```\curl -sSL https://get.rvm.io | bash```  
ajouter rvm au path :  
```source ~/.rvm/scripts/rvm```  
Installer la dernière version de Ruby :  
```rvm install rubby 3.2.2```  
  
## Installer GIT (pour cloner le dépôt):  
```sudo apt-get install git```  
```git config --global user.name "John Doe"```  
```git config --global user.email johndoe@example.com```  
  
## Installer Apache2 et apache2-dev :  
```sudo apt-get install apache2```   
```sudo apt-get install apache2-dev```  
  
## Install PGP key and add HTTPS support for APT  
```sudo apt-get install -y dirmngr gnupg apt-transport-https ca-certificates curl```  
```curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/phusion.gpg >/dev/null```  
  
## Add Passenger APT repository :  
```sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jammy main > /etc/apt/sources.list.d/passenger.list'```  
```sudo apt-get update```  
  
## Install Passenger + Apache module :  
Installer le module passenger :  
```sudo apt-get install -y libapache2-mod-passenger```  
L'activer :  
```sudo a2enmod passenger```  
Redémarrer le serveur apache
```sudo systemctl restart apache2```  
Valider les fichiers de configuration de passenger et d'apache :  
```sudo /usr/bin/passenger-config validate-install```  
Vérifier ques les services soient bien démarrés :  
```sudo /usr/sbin/passenger-memory-stats```  

## Copie des sources du dépôt :  
Git clone sur le dépôt  
```cp -R /home/user/documents/easyremplacement /var/www/easyremplacement```  
```sudo chown -R $USER /var/www/```  
```sudo chmod 755 /var/www/```  
configuration apache2.conf et available site  
ajout deflate et caching module   
  
## Configuration de Let's Encrypt :  
```sudo apt install certbot python3-certbot-apache```  

Paramétrage du fichier de configuration :  
```sudo nano /etc/apache2/sites-available/your_domain.conf``` 
Ajouter :  
```ServerName your_domain```  
  
Vérifier l'écriture du fichier de configuration :  
```sudo apache2ctl configtest ```  
Vérifier le statut du firewall : 
```sudo ufw status```  
Configurer le certificat pour votre nom de domaine :  
```sudo certbot --apache```  
Tester le renouvellement du certificat :  
```sudo certbot renew --dry-run```  
Redémarrer le service apache 2 :  
```sudo systemctl restart apache2```  

## Redirection vers nom de domaine :  
Modifier le type A pour renvoyer vers l'adresse IP de votre serveur  