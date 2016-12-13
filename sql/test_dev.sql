/*
* Test Values (for Invex DEV)
* TESTING/DEBUGGING ONLY
*/

-- Transactions with Selected Servers
INSERT INTO transactions (cost, steamid, username, userid, start_date, end_date, packageid)
VALUES ('100.00', 'STEAM_1:1:74070914', 'Byte', 1, 1481602000, 1484280833, 1);

INSERT INTO transactions (cost, steamid, username, userid, start_date, end_date, packageid)
VALUES ('0.00', 'STEAM_1:1:74070914', 'Byte', 1, 1481602000, NULL, 2);


INSERT INTO transactions (cost, steamid, username, userid, start_date, end_date, packageid)
VALUES ('10.00', 'STEAM_1:1:1337', 'Bobby', 67, 1481602000, 1484280833, 8);
INSERT INTO selectedservers (transactionid, serverid)
VALUES (3, 1);

INSERT INTO transactions (cost, steamid, username, userid, start_date, end_date, packageid)
VALUES ('50.00', 'STEAM_1:1:6969', 'John', 98, 1000, 1481602000, 9);
INSERT INTO selectedservers (transactionid, serverid)
VALUES (4, 1), (4, 2), (4, 4);

INSERT INTO transactions (cost, steamid, username, userid, start_date, end_date, packageid)
VALUES ('50.00', 'STEAM_1:1:6969', 'John', 98, 1481602000, 1484280833, 9);
INSERT INTO selectedservers (transactionid, serverid)
VALUES (5, 1), (5, 2), (5, 4);