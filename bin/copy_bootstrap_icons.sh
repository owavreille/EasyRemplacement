#!/bin/bash

# Création des répertoires nécessaires
mkdir -p app/assets/fonts/bootstrap-icons/font/fonts

# Copie des fichiers de police
cp node_modules/bootstrap-icons/font/fonts/* app/assets/fonts/bootstrap-icons/font/fonts/

echo "✅ Fichiers de police Bootstrap Icons copiés avec succès !" 