-- Exercice ARSENAL : prérequis, avoir lancé sql/05-contraintes-setup.sql

-- Question 1 : déploiements et échecs en production, par équipe
SELECT a.team AS team,
       COUNT(d.id) FILTER (WHERE d.environment = 'production') AS prod_total,
       COUNT(d.id) FILTER (WHERE d.environment = 'production' AND d.status = 'failed') AS prod_echecs
FROM applications a
LEFT JOIN deployments d ON a.id = d.app_id
GROUP BY a.team
ORDER BY a.team;

-- Question 2 : personnes dont le taux de réussite est inférieur à 70 %
SELECT deployed_by,
       COUNT(*) AS total,
       COUNT(*) FILTER (WHERE status = 'success') AS succes,
       ROUND((COUNT(*) FILTER (WHERE status = 'success')::numeric / COUNT(*)::numeric) * 100, 1) AS taux_reussite_pct
FROM deployments
GROUP BY deployed_by
HAVING (COUNT(*) FILTER (WHERE status = 'success')::numeric / COUNT(*)::numeric) * 100 < 70
ORDER BY taux_reussite_pct;

-- Question 3 : suivi des incidents
DROP TABLE IF EXISTS incidents;
CREATE TABLE incidents (
    id SERIAL PRIMARY KEY,
    deployment_id INTEGER NOT NULL REFERENCES deployments(id) ON DELETE RESTRICT,
    severity VARCHAR(10) NOT NULL CHECK (severity IN ('low', 'medium', 'high')),
    description TEXT NOT NULL,
    opened_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO incidents (deployment_id, severity, description) VALUES
(8, 'high', 'Timeout base de données'),
(5, 'low', 'Variable d''environnement manquante');

-- Test : la gravité 'critical' doit être refusée (laissé en commentaire)
-- INSERT INTO incidents (deployment_id, severity, description) VALUES (1, 'critical', 'Test');

-- Déploiements en échec sans incident
SELECT d.id, a.name, d.environment, d.deployed_by
FROM deployments d
JOIN applications a ON d.app_id = a.id
LEFT JOIN incidents i ON d.id = i.deployment_id
WHERE d.status = 'failed' AND i.id IS NULL
ORDER BY d.id;
