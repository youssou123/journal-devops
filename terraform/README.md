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
