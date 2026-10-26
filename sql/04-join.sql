-- 1. INNER JOIN : recoller le nom et l'équipe de chaque application
SELECT d.id, a.name, a.team, d.environment, d.status
FROM deployments d
INNER JOIN applications a ON d.app_id = a.id
ORDER BY d.id;

-- 2. INNER JOIN + GROUP BY : déploiements par application
SELECT a.name, COUNT(*) AS total
FROM deployments d
INNER JOIN applications a ON d.app_id = a.id
GROUP BY a.name;

-- 3. LEFT JOIN : garder aussi les applications sans déploiement
SELECT a.name, a.team, d.id AS deployment_id, d.environment, d.status
FROM applications a
LEFT JOIN deployments d ON d.app_id = a.id
ORDER BY a.id, d.id;

-- 4. COUNT(d.id) ignore les NULL : donne bien 0 pour une application sans déploiement
SELECT a.name, COUNT(d.id) AS total
FROM applications a
LEFT JOIN deployments d ON d.app_id = a.id
GROUP BY a.name
ORDER BY a.name;

-- 5. Applications jamais déployées
SELECT a.name, a.team
FROM applications a
LEFT JOIN deployments d ON d.app_id = a.id
WHERE d.id IS NULL;

-- 6. Taux d'échec par application (NULLIF évite la division par zéro)
SELECT a.name, a.team,
       COUNT(d.id) AS total,
       COUNT(d.id) FILTER (WHERE d.status = 'failed') AS echecs,
       ROUND(100.0 * COUNT(d.id) FILTER (WHERE d.status = 'failed') / NULLIF(COUNT(d.id), 0), 1) AS taux_echec_pct
FROM applications a
LEFT JOIN deployments d ON d.app_id = a.id
GROUP BY a.name, a.team
ORDER BY a.name;

-- 7. Test de la clé étrangère (doit échouer, donc laissé en commentaire) :
-- INSERT INTO deployments (app_id, environment, status, deployed_by) VALUES (99, 'staging', 'success', 'test');
