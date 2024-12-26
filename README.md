![Automatic Deployment](https://github.com/owavreille/EasyRemplacement/actions/workflows/rubyonrails.yml/badge.svg)

# EASY REMPLACEMENT

Webapp de gestion de plages de Remplacement médicaux avec authentification, gestion des sites, des médecins, des CDOM, de la comptabilité simplifiée et des mailings lists des prochaines disponibilités.

## 📋 Spécifications
- Ruby version : 3.2.2
- Rails 8.0.1
- PostgreSQL/SQLite3
- Bootstrap 5.3
- Node.js 20.x
- Yarn

## 📧 Configuration des Emails

### Configuration SMTP
L'application utilise SMTP pour l'envoi des emails. Voici les différents types d'emails envoyés :

1. **Notifications automatiques** :
   - Création d'événement
   - Confirmation de réservation
   - Modification d'événement
   - Annulation d'événement
   - Nouvel utilisateur (aux administrateurs)

2. **Emails périodiques** :
   - Liste hebdomadaire des événements disponibles
   - Contrats CDOM

### Variables d'environnement pour les emails
Créez un fichier `.env` à partir du `.env.example` et configurez les variables suivantes :

```env
# Configuration email
MAIL_FROM=no-reply@easyremplacement.fr
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=easyremplacement.fr
SMTP_USER_NAME=votre_email@gmail.com
SMTP_PASSWORD=votre_mot_de_passe_app
SMTP_AUTHENTICATION=plain
SMTP_OPEN_TIMEOUT=5
SMTP_READ_TIMEOUT=5
```

### Configuration Gmail
Si vous utilisez Gmail :
1. Activez l'authentification à deux facteurs
2. Générez un mot de passe d'application
3. Utilisez ce mot de passe dans `SMTP_PASSWORD`

## 🚀 Installation

1. **Variables d'environnement**
```bash
cp .env.example .env
# Éditez .env avec vos valeurs
```

2. **Installation des dépendances**
```bash
bundle install
yarn install
```

3. **Base de données**
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. **Création d'un administrateur**
```bash
rails create_admin
```

## 🐳 Déploiement avec Docker

### Prérequis
- Docker installé sur votre machine
- Docker Compose (inclus avec Docker Desktop)

### Construction et démarrage

1. **Construire l'image**
```bash
docker build -t easy-remplacement .
```

2. **Démarrer l'application**
```bash
docker compose up -d
```

3. **Première configuration**
```bash
# Création de la base de données
docker compose exec web rails db:create

# Migrations
docker compose exec web rails db:migrate

# Données initiales (optionnel)
docker compose exec web rails db:seed
```

### Commandes utiles

```bash
# Voir les logs
docker compose logs -f

# Redémarrer l'application
docker compose restart

# Arrêter l'application
docker compose down

# Mettre à jour l'application
git pull
docker compose build
docker compose up -d
```

### Sauvegarde et restauration

```bash
# Sauvegarde de la base de données
docker compose exec db pg_dump -U postgres easy_remplacement_production > backup.sql

# Restauration
docker compose exec -T db psql -U postgres easy_remplacement_production < backup.sql
```

## 🔒 Sécurité

- Ne jamais commiter les fichiers `.env` ou `config/master.key`
- Utiliser des mots de passe forts
- Mettre régulièrement à jour les dépendances
- Sauvegarder régulièrement la base de données

## 📝 Licence

Copyright © 2023 Olivier Wavreille. Tous droits réservés.
