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
