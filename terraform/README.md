# Terraform en local avec Docker

Premiers exercices Terraform, sans cloud : le provider Docker crée et détruit des conteneurs sur ma machine.

## Prérequis

- Docker Desktop lancé
- Terraform installé (testé avec la v1.16.6)

## Lancer l'exemple

    cd terraform/01-docker-nginx
    terraform init
    terraform plan
    terraform apply
    curl -I http://localhost:8085
    terraform destroy

## Contenu

| Dossier | Rôle |
|---|---|
| `01-docker-nginx` | Une image `nginx:1.27-alpine` et un conteneur `tf-nginx` exposé sur le port 8085 |

## Notions apprises (jour 4)

- Un provider est le plugin qui parle à une plateforme (ici Docker), `terraform init` le télécharge
- Une ressource qui en référence une autre (`docker_image.nginx.image_id`) crée une dépendance : Terraform crée dans l'ordre, et détruit dans l'ordre inverse
- `terraform plan` montre ce qui va changer sans rien toucher : `+` créer, `~` modifier, `-/+` détruire puis recréer
- `# forces replacement` signale un changement impossible à chaud (changer le port d'un conteneur)
- `terraform.tfstate` est la mémoire de Terraform : il ne se commite jamais, il peut contenir des secrets
- `.terraform.lock.hcl` se commite, il verrouille la version du provider
- `keep_locally = true` évite de supprimer l'image Docker au `destroy`

## Jour 5 : une stack complète (`02-stack`)

Un réseau, un volume, deux images, une base Postgres et nginx, décrits en Terraform.

### Lancer la stack

    cd terraform/02-stack
    cp terraform.tfvars.example terraform.tfvars
    # éditer terraform.tfvars : choisir un mot de passe
    terraform init
    terraform plan -out=tfplan
    terraform apply tfplan
    curl -I $(terraform output -raw nginx_url)

Ports utilisés : 5435 (Postgres) et 8085 (nginx), modifiables dans `variables.tf`.

### Notions apprises

- Les variables (`variable`, `default`, `sensitive`) évitent d'écrire les valeurs en dur ; `terraform.tfvars` ne se commite jamais, seul `terraform.tfvars.example` est versionné
- `output` affiche des valeurs utiles après un `apply` ; `terraform output -raw nom` donne la valeur sans guillemets
- Dépendance implicite (une référence entre ressources) ou explicite (`depends_on`)
- `healthcheck` avec `wait = true` : Terraform attend que la base soit saine avant de continuer
- `terraform plan -out=tfplan` puis `terraform apply tfplan` applique exactement le plan relu (le fichier tfplan est ignoré par Git)
- `sensitive = true` cache la valeur à l'écran, pas dans `terraform.tfstate` où elle reste en clair
- La dérive : une ressource supprimée à la main est détectée par `plan` et recréée par `apply`
- `terraform apply -replace=ressource` recrée une seule ressource ; le volume conserve les données de la base
- `terraform destroy` supprime aussi le volume, donc les données
- `lifecycle { prevent_destroy = true }` bloque un `destroy` accidentel, mais pas un `docker volume rm` fait à la main
