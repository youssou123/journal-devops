-- 1. Compter les lignes
SELECT COUNT(*) FROM deployments;
SELECT COUNT(*) FROM deployments WHERE status = 'failed';

-- 2. Grouper
SELECT status, COUNT(*) AS total FROM deployments GROUP BY status;
SELECT app_name, COUNT(*) AS total FROM deployments GROUP BY app_name;
SELECT environment, status, COUNT(*) AS total FROM deployments GROUP BY environment, status ORDER BY environment, status;

-- 3. Filtrer, grouper, trier
SELECT deployed_by, COUNT(*) AS echecs FROM deployments WHERE status = 'failed' GROUP BY deployed_by ORDER BY echecs DESC;

-- 4. HAVING : filtrer les groupes
SELECT deployed_by, COUNT(*) AS echecs FROM deployments WHERE status = 'failed' GROUP BY deployed_by HAVING COUNT(*) > 1;

-- 5. MAX : dernier déploiement par application
SELECT app_name, MAX(deployed_at) AS dernier_deploiement FROM deployments GROUP BY app_name;

-- 6. Taux d'échec par environnement (métrique DORA)
SELECT environment,
       COUNT(*) AS total,
       COUNT(*) FILTER (WHERE status = 'failed') AS echecs,
       ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'failed') / COUNT(*), 1) AS taux_echec_pct
FROM deployments
GROUP BY environment;
