![Automatic Deployment](https://github.com/owavreille/EasyRemplacement/actions/workflows/rubyonrails.yml/badge.svg)

## EASY REMPLACEMENT ##

Webapp de gestion de plages de Remplacement médicaux avec authentification, gestion des sites, des médecins, des CDOM, de la comptabilité simplifiée et des mailings lists.

Spécifications :
* Ruby version : 3.2.2
* Rails 7.0.5
* Sqlite3

* Dépendances :
Bootstrap

* Configuration
Configuration du nom d'application dans config/settings.yml
Placer les variables d'environnement dans fichier .env

* Création de la base de données
Base Sqlite3

* Initialisation de la base de données
rails db:migrate
rails db:seed

* Tests unitaires
work in progress

* Services (job queues, cache servers, search engines, etc.)
cron job in schedule.rb pour la fréquence d'envoie des mails de rappel

* Deployment instructions

* ...
