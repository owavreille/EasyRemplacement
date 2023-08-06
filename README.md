![Automatic Deployment](https://github.com/owavreille/EasyRemplacement/actions/workflows/rubyonrails.yml/badge.svg)

## EASY REMPLACEMENT ##

Webapp de gestion de plages de Remplacement médicaux avec authentification, gestion des sites, des médecins, des CDOM, de la comptabilité simplifiée et des mailings lists.

* Spécifications :  
Ruby version : 3.2.2  
Rails 7.0.6  
Sqlite3/PostgreSQL  
  
* Dépendances :  
Bootstrap 5
  
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

* Deployment instructions  
En utilisant Capistrano et après configuration de deploy.rb  

* ...
