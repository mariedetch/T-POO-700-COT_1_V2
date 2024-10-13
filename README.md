# Time Manager

**Time Manager** est une application web de gestion du temps au sein de l'entreprise. Elle permet aux employés, managers, et au directeur général de gérer leurs horaires de travail, suivre les performances d'équipe, et visualiser des tableaux de bord personnels et d'équipe.

## Contexte du projet

L'application est conçue pour trois catégories d'utilisateurs :
- **Employés** : peuvent gérer leurs informations de compte, signaler leurs horaires d'arrivée et de départ, et consulter leur tableau de bord.
- **Managers** : peuvent gérer leurs équipes, consulter les heures de travail des membres, et accéder aux tableaux de bord de leurs employés.
- **Directeur général** : peut promouvoir des employés au rang de manager, supprimer des comptes, et visualiser les tableaux de bord de tous les utilisateurs.

## Fonctionnalités principales

1. **Gestion des utilisateurs** :
   - Modification et suppression des comptes.
   - Suivi des horaires d'arrivée et de départ.

2. **Gestion des équipes (Managers)** :
   - Gestion des équipes d'employés.
   - Visualisation des moyennes horaires journalières et hebdomadaires des équipes.

3. **Promotion des employés (Directeur général)** :
   - Promotion d'un employé au rang de manager.
   - Suppression des comptes utilisateurs.

4. **Tableaux de bord** :
   - Suivi des performances individuelles et d'équipe via des tableaux de bord détaillés.

## Organisation du dépôt

Le projet est divisé en deux parties :

### 1. `time-manager-backend`
Le backend gère les API et la logique métier de l'application avec Node.js, TypeScript et MongoDB. Il expose des endpoints RESTful pour gérer les utilisateurs, les équipes, et les rapports d'activité.

Plus de détails dans le [README du backend](./time-manager-backend/README.md).

### 2. `time-manager-frontend`
Le frontend, développé avec Vue.js (ou React.js), offre une interface web pour que les utilisateurs puissent interagir avec leurs horaires, gérer leurs équipes, et consulter leurs tableaux de bord.

Plus de détails dans le [README du frontend](./time-manager-frontend/README.md).
