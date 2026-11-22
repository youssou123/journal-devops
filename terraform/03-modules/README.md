# Terraform : un module réutilisable

La stack du jour 5 (réseau, volume, Postgres, nginx) devient un module appelable.

## Structure

    03-modules/
    ├── main.tf               module racine : provider et appel du module
    ├── variables.tf          variables du module racine
    ├── outputs.tf            sorties réexposées
    └── modules/stack/        module enfant (ressources, variables, sorties)

## Lancer l'exemple

    cd terraform/03-modules
    cp terraform.tfvars.example terraform.tfvars
    # éditer terraform.tfvars : choisir un mot de passe
    terraform init
    terraform plan -out=tfplan
    terraform apply tfplan
    curl -I $(terraform output -raw staging_nginx_url)
    terraform destroy

Ports utilisés : 5435 (Postgres) et 8085 (nginx), pour l'environnement staging.

## Notions apprises (jour 6)

- Un module est un dossier de fichiers `.tf` qu'on appelle avec un bloc `module` et un `source`
- Le module racine est le dossier où on lance `terraform` ; un module enfant contient les ressources
- Les variables du module enfant sont ses paramètres ; sans `default`, l'appelant doit les fournir
- Les sorties d'un module ne s'affichent pas seules : le module racine les réexpose avec ses propres `output`
- Les ressources d'un module ont une adresse préfixée : `module.staging.docker_container.db`
- Le provider se configure une fois dans le module racine, le module enfant déclare seulement `required_providers` avec la bonne `source`
- Les noms des ressources sont préfixés par une variable (`env_name`) pour que deux appels du module ne se heurtent pas

## Jour 7 : deux environnements avec le même module

Deux appels du même module `./modules/stack` : `staging` et `production`, dans un seul état Terraform.

| Environnement | Nginx | Postgres | Réseau | Volume |
|---|---|---|---|---|
| staging | 8085 | 5435 | staging-net | staging-pgdata |
| production | 8086 | 5436 | production-net | production-pgdata |

`terraform.tfvars` contient maintenant deux mots de passe distincts : `db_password` (staging) et `db_password_production`. Le fichier `terraform.tfvars.example` montre le format ; le vrai fichier n'est jamais commité.

### Notions apprises (jour 7)

- Un même module peut être appelé plusieurs fois avec des valeurs différentes : aucun code n'est dupliqué
- Chaque appel a sa propre adresse dans l'état (`module.production...`, `module.staging...`) et ses propres ressources
- Ajouter un environnement ne modifie pas l'autre : `terraform plan` ne propose que les ressources de production
- Le nom `db` existe dans chaque réseau et désigne la base de son propre environnement (adresses IP différentes)
- Un secret par environnement : on ne partage pas le mot de passe de staging avec la production
- Les volumes sont séparés : une table créée en production n'existe pas en staging
- `terraform fmt -check` et `terraform validate` avant chaque commit
