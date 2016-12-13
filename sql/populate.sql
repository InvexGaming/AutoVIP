-- Script to populate AutoVIP DB with required variables
-- Set AUTO_INCREMENT to start at 1, and increment by 1

USE autovip;

-- CSGO Servers
INSERT INTO servers (name)
VALUES  ('invexdev'),
        ('combatsurf'),
        ('surfdm'),
        ('jailbreak'),
        ('1v1'),
        ('retake'),
        ('retake2');
        
-- Permissions
INSERT INTO permissions (tag)
VALUES  ('@staff'),
        ('@global'),
        ('@admin'),
        ('@veteran'),
        ('@res'),
        ('@vip'),
        ('@permvip');
 
 
-- Packages
INSERT INTO packages (name, description, cost, credits_included, num_servers, duration, active, permissionid)
VALUES  ('General', 'General/Misc donations', 0.00, 0, -1, 0, false, NULL),
        ('Staff', 'Given to all Staff', 0.00, 0, 0, 0, true, 1),
        ('Global', 'Given to all Globals', 0.00, 0, 0, 0, true, 2),
        ('Server Admin', 'Given to all Server Admins', 0.00, 0, 1, 0, true, 3),
        ('Veteran', 'Given to all Veterans', 0.00, 0, 0, 0, true, 4),
        ('Credits', 'Basic credit package', 1.00, 800, 1, 0, false, NULL),
        ('Package 1', 'Reservation slot', 5.00, 0, 1, 30, true, 5),
        ('Package 2', 'Premium VIP', 10.00, 5000, 1, 30, true, 6),
        ('Package 3', 'Premium VIP', 27.00, 5000, 3, 60, true, 6),
        ('Package 4', 'Premium VIP', 50.00, 5000, 0, 90, true, 6),
        ('Package 5', 'Permanent VIP', 65.00, 0, 0, 0, true, 7),
        ('Package 6', 'Permanent VIP', 200.00, 0, 0, 0, true, 7);
        