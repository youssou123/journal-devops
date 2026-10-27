DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS deployments;
DROP TABLE IF EXISTS applications;

CREATE TABLE applications (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    team VARCHAR(30) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO applications (name, team) VALUES
('echobuild-api', 'BASTION'),
('echobuild-frontend', 'FAUCON'),
('echobuild-monitoring', 'ARSENAL');

CREATE TABLE deployments (
    id SERIAL PRIMARY KEY,
    app_id INTEGER NOT NULL REFERENCES applications(id) ON DELETE RESTRICT,
    environment VARCHAR(20) NOT NULL CHECK (environment IN ('staging', 'production')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('success', 'failed')),
    deployed_by VARCHAR(50) NOT NULL,
    deployed_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO deployments (app_id, environment, status, deployed_by, deployed_at) VALUES
(1, 'staging', 'success', 'youssou123', '2026-10-18 09:15'),
(1, 'production', 'success', 'ndeye', '2026-10-18 14:30'),
(2, 'staging', 'failed', 'melodie', '2026-10-19 10:05'),
(2, 'production', 'success', 'youssou123', '2026-10-19 16:20'),
(1, 'staging', 'failed', 'youssou123', '2026-10-20 08:45'),
(1, 'staging', 'success', 'melodie', '2026-10-20 11:10'),
(2, 'staging', 'success', 'ndeye', '2026-10-21 09:00'),
(2, 'production', 'failed', 'melodie', '2026-10-21 15:40'),
(1, 'production', 'failed', 'ndeye', '2026-10-22 08:30'),
(1, 'production', 'success', 'youssou123', '2026-10-22 10:00');
