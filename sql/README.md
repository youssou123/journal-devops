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

## Jour 3 : contraintes, ON DELETE et exercice ARSENAL

| Fichier | Rôle |
|---|---|
| `05-contraintes-setup.sql` | Recrée les tables avec contraintes : `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`, `ON DELETE RESTRICT` |
| `06-exercice-arsenal.sql` | Exercice : rapport par équipe, taux de réussite par personne, table `incidents` |

Ordre d'exécution : pour le jour 3, lancer `05` puis `06`.

Les scripts `01`, `03` et `05` commencent par `DROP TABLE IF EXISTS incidents;` : la table `incidents` dépend de `deployments`, donc sans cette ligne ils échoueraient quand elle existe.

Astuce : `psql -v ON_ERROR_STOP=1` arrête le script à la première erreur au lieu de continuer en silence.

### Notions apprises

- Les contraintes `NOT NULL`, `UNIQUE`, `DEFAULT` et `CHECK` font refuser les données absurdes par la base elle-même
- `ON DELETE RESTRICT` protège l'historique, `ON DELETE CASCADE` supprime les lignes liées
- `BEGIN` puis `ROLLBACK` permet de tester une opération destructive sans rien perdre
- Une séquence `SERIAL` ne revient jamais en arrière : des trous dans les `id` sont normaux
- `NOT EXISTS` est une alternative à `LEFT JOIN ... IS NULL` pour trouver les lignes sans correspondance
