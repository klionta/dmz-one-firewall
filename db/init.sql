CREATE TABLE IF NOT EXISTS data (id serial primary key, msg text);
INSERT INTO data (msg) VALUES ('secret record') ON CONFLICT DO NOTHING;