-- Seed data: Admin user + initial whitelist
-- Run this AFTER schema.sql

-- Admin account (Hendric Makowski, code: HDRC2026X)
INSERT OR IGNORE INTO users (id, name, role, code, points, registered) 
VALUES ('admin1', 'Hendric Makowski', 'admin', 'HDRC2026X', 0, 1);

-- Initial whitelist (add your real students here)
INSERT OR IGNORE INTO whitelist (id, name) VALUES ('w1', 'Hendric Makowski');
-- Füge hier weitere Schüler hinzu:
-- INSERT OR IGNORE INTO whitelist (id, name) VALUES ('w2', 'Max Mustermann');
-- INSERT OR IGNORE INTO whitelist (id, name) VALUES ('w3', 'Lena Müller');
-- ... usw. für alle ~120 Schüler
