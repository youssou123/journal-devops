# SQL pour DevOps

Exercices SQL sur une table `deployments` qui simule un historique de déploiements.

## Lancer la base (PostgreSQL dans Docker)

    docker run --name pg-learn -e POSTGRES_PASSWORD=learn123 -e POSTGRES_DB=devops_sql -p 5434:5432 -v pg-learn-data:/var/lib/postgresql/data -d postgres:16

Le volume `pg-learn-data` conserve les données même si le conteneur est supprimé.

## Exécuter les fichiers

    docker exec -i pg-learn psql -U postgres -d devops_sql < sql/01-setup.sql
    docker exec -i pg-learn psql -U postgres -d devops_sql < sql/02-group-by-count.sql

## Contenu

| Fichier | Rôle |
|---|---|
| `01-setup.sql` | Recrée la table `deployments` avec 10 lignes (rejouable à volonté) |
| `02-group-by-count.sql` | `COUNT`, `GROUP BY`, `HAVING`, `MAX`, `FILTER` |

## Notions apprises (jour 1)

- `COUNT(*)` compte les lignes, `GROUP BY` les range en groupes
- `WHERE` filtre les lignes avant le regroupement, `HAVING` filtre les groupes après
- Ordre d'exécution : `FROM`, `WHERE`, `GROUP BY`, `SELECT`, `ORDER BY`
- `COUNT(*) FILTER (WHERE ...)` pour compter sous condition

## Lien avec le DevOps

La dernière requête calcule le taux d'échec des déploiements par environnement,
l'une des quatre métriques DORA.

## Jour 2 : JOIN

| Fichier | Rôle |
|---|---|
| `03-join-setup.sql` | Recrée deux tables, `applications` et `deployments`, reliées par une clé étrangère `app_id`. Remplace le modèle du jour 1 |
| `04-join.sql` | `INNER JOIN`, `LEFT JOIN`, `IS NULL`, `NULLIF` |

Ordre d'exécution : pour rejouer le jour 1, lancer `01` puis `02`. Pour le jour 2, lancer `03` puis `04`.

### Notions apprises

- Une clé étrangère garantit qu'un déploiement pointe vers une application qui existe
- `INNER JOIN` garde seulement les lignes qui ont une correspondance des deux côtés
- `LEFT JOIN` garde toutes les lignes de gauche, avec `NULL` à droite s'il n'y a pas de correspondance
- `COUNT(colonne)` ignore les `NULL`, `COUNT(*)` non
- `WHERE d.id IS NULL` après un `LEFT JOIN` trouve les lignes sans correspondance
- `NULLIF(x, 0)` évite l'erreur de division par zéro
