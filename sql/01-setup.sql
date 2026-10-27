DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS deployments;

CREATE TABLE deployments (
    id SERIAL PRIMARY KEY,
    app_name VARCHAR(50),
    environment VARCHAR(20),
    status VARCHAR(20),
    deployed_by VARCHAR(50),
    deployed_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO deployments (app_name, environment, status, deployed_by, deployed_at) VALUES
('echobuild-api', 'staging', 'success', 'youssou123', '2026-10-18 09:15'),
('echobuild-api', 'production', 'success', 'ndeye', '2026-10-18 14:30'),
('echobuild-frontend', 'staging', 'failed', 'melodie', '2026-10-19 10:05'),
('echobuild-frontend', 'production', 'success', 'youssou123', '2026-10-19 16:20'),
('echobuild-api', 'staging', 'failed', 'youssou123', '2026-10-20 08:45'),
('echobuild-api', 'staging', 'success', 'melodie', '2026-10-20 11:10'),
('echobuild-frontend', 'staging', 'success', 'ndeye', '2026-10-21 09:00'),
('echobuild-frontend', 'production', 'failed', 'melodie', '2026-10-21 15:40'),
('echobuild-api', 'production', 'failed', 'ndeye', '2026-10-22 08:30'),
('echobuild-api', 'production', 'success', 'youssou123', '2026-10-22 10:00');
