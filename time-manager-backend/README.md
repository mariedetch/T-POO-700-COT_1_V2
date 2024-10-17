# API de Gestion de l'application Time Manager

Une API RESTful pour la gestion des fonctionnalités de l'application Time Manager.

## Table des matières
- [Installation](#installation)
- [Usage](#usage)
- [Documentation de l'API](#documentation-de-lapi)
- [Tests](#tests)
- [Contribution](#contribution)
## Installation

### Prérequis
- [Elixir](https://elixir-lang.org/install.html) version `1.15.x` ou supérieure
- [Phoenix Framework](https://www.npmjs.com/) version `1.7.x` ou supérieure
- [PostgreSQL](https://www.postgresql.org/)

### Cloner le dépôt
```bash
git clone git@github.com:EpitechMscProPromo2026/T-POO-700-COT_1.git
cd T-POO-700-COT_1/time-manager-backend
```

### Installation des dépendances
```bash
mix deps.get
```

### Configuration de l'environnement
Créer un fichier de configuration pour votre environnement (un env de développement par example)
```bash
cp config/dev.exs.example config/dev.exs
```

Ouvrer le ficher de configuration crée (`config/dev.exs`) et mettre à jour les credentials de connexion à votre server
postgres

#### Création de la base de donnée
```bash
mix ecto.create
```

#### Migration des tables en base de donnée
```bash
mix ecto.migrate
```

## Usage

### Démarrer le serveur
```bash
mix phx.server
```

## Documentation de l'API
L'api est livré avec une documentation OpenApi3.0 et une collection postaman que vous pouvez touvez [ici](https://justice-league-6332.postman.co/workspace/Justice-League-Workspace~65724821-f9ed-41c5-85a9-a8ac4f84dc63/api/5ff451e6-0e76-4ab1-b065-5c85482bc741?action=share&creator=38847444&active-environment=38859705-8d4f8b65-2b14-4562-a64a-9118086a7874)

## Tests

### Exécution des tests
1. Lancez les tests unitaires :
```bash
mix test
```

## Contribution

Pour contribuer efficacement à ce projet, nous utilisons **Git-flow** comme méthodologie de gestion des branches Git. Git-flow est un ensemble d'extensions de Git commandées par un modèle de branchement défini, ce qui permet une gestion organisée des versions, des nouvelles fonctionnalités et des correctifs.

1. Configurer Git-flow
Si ce n'est pas déjà fait, configurez Git-flow dans votre dépôt local :
```bash
git flow init
```
Acceptez les paramètres par défaut ou modifiez-les selon les besoins spécifiques du projet. Les principales branches sont :

main : Contient l'historique officiel des versions.
develop : Branche par défaut où sont intégrées les fonctionnalités développées.

2. Créer une nouvelle fonctionnalité (Feature)
Pour travailler sur une nouvelle fonctionnalité, créez une branche de fonctionnalité à partir de develop :
```bash
git flow feature start feature-name
```
Cela crée une branche `feature/feature-name` où vous pouvez travailler sur votre nouvelle fonctionnalité.

3. Développer la fonctionnalité
Travaillez sur votre fonctionnalité en ajoutant du code, des tests, et en committant régulièrement :
```bash
git add .
git commit -m "Ajout de la fonctionnalité [feature-name]"
```

4. Terminer la fonctionnalité
Une fois la fonctionnalité terminée, fusionnez-la dans la branche `develop` :
```bash
git flow feature finish feature-name
```

Cette commande :
- Fusionne la branche `feature/feature-name` dans `develop`.
- Supprime la branche `feature/feature-name` locale.

Poussez vos modifications à distance pour que d'autres développeurs puissent les voir :
```bash
git push origin develop
```

5. Règles de contribution
- **Commit messages :** Utilisez des messages de commit clairs et descriptifs. Suivez le format [type]: description, par exemple : feat: ajout de l'authentification JWT.
- **Code review :** Toute fonctionnalité ou correction doit passer par une revue de code avant d'être fusionnée dans develop.
- **Tests :** Assurez-vous que toutes les fonctionnalités et corrections incluent des tests adéquats.
- **Documentation :** Si vous ajoutez une nouvelle fonctionnalité ou modifiez une fonctionnalité existante, mettez à jour la documentation correspondante.
