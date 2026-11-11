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
