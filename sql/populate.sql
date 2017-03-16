-- Script to populate AutoVIP DB with required variables
-- Set AUTO_INCREMENT to start at 1, and increment by 1

USE autovip;

-- CSGO Servers
INSERT INTO servers (short_name, nice_name, active)
VALUES  ('invexdev', 'Invex Dev', true),
        ('combatsurf', 'Combat Surf', true),
        ('surfdm', 'Surf DM', true),
        ('jailbreak', 'Jailbreak', true),
        ('1v1', '1v1', true),
        ('retake', 'Retakes', true),
        ('retake2', 'Retakes HS', true);
        
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
INSERT INTO packages (name, description, cost, credits_included, num_servers, duration, active, permissionid, ordernum)
VALUES  ('General', 'General/Misc donations', 0.00, 0, -1, 0, false, NULL, 99999),
        ('Staff', 'Given to all Staff', 0.00, 0, 0, 0, true, 1, 1),
        ('Global', 'Given to all Globals', 0.00, 0, 0, 0, true, 2, 2),
        ('Server Admin', 'Given to all Server Admins', 0.00, 0, 1, 0, true, 3, 3),
        ('Veteran', 'Given to all Veterans', 0.00, 0, 0, 0, true, 4, 4),
        ('Credits', 'Basic credit package', 1.00, 800, 1, 0, false, NULL, 6),
        ('Package 1', 'Reservation slot', 5.00, 0, 1, 30, true, 5, 7),
        ('Package 2', 'Premium VIP', 10.00, 5000, 1, 30, true, 6, 8),
        ('Package 3', 'Premium VIP', 27.00, 5000, 3, 60, true, 6, 9),
        ('Package 4', 'Premium VIP', 50.00, 5000, 0, 90, true, 6, 10),
        ('Package 5', 'Permanent VIP', 65.00, 0, 1, 0, true, 7, 11),
        ('Package 6', 'Permanent VIP', 200.00, 0, 0, 0, true, 7, 12),
        ('Jailbreak POTM', 'Given to monthly POTM winners', 0.00, 2500, 1, 30, true, 6, 5),
        ('Top10 Free VIP', 'Top10 ranked rewards', 0.00, 2500, 1, 30, true, 6, 5);