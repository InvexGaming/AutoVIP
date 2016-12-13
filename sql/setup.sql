-- Setup AutoVIP
-- Warning: This will remove all current entries! Backup first.

DROP DATABASE IF EXISTS autovip;
CREATE DATABASE autovip;

USE autovip;

/*
* Package Table, contains VIP packages
*/
DROP TABLE IF EXISTS packages;
CREATE TABLE packages
(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(64),
  credits_included INT DEFAULT 0,
  num_servers INT NOT NULL, -- Set to -1 for all servers
  duration INT NOT NULL,  -- in days, 0 for permanent
  description VARCHAR(255),
  active BIT(1) NOT NULL,
  PRIMARY KEY (id)
);

/*
* Lists all servers
*/
DROP TABLE IF EXISTS servers;
CREATE TABLE servers
(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(64), -- name of server (nice name)
  PRIMARY KEY(id)
);

/*
* Permissions tables for Sourcemod Admin Groups
*/
DROP TABLE IF EXISTS permissions;
CREATE TABLE permissions
(
  id INT NOT NULL AUTO_INCREMENT,
  tag VARCHAR(32), -- referring to groups in admin_groups.cfg, includes @ symbol
  PRIMARY KEY(id)
);

/*
* Transaction table, stores all transaction details etc
*/
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions
(
  id INT NOT NULL AUTO_INCREMENT,
  cartid INT NOT NULL,
  steamid VARCHAR(32),
  username VARCHAR(64),
  userid INT,
  start_date INT(11),
  end_date INT(11),
  permanent BIT(1) NOT NULL DEFAULT 0, -- must be checked alongside end_date
  packageid INT,
  serverid INT,
  permissionid INT,
  PRIMARY KEY(id),
  FOREIGN KEY (packageid) REFERENCES packages(id),
  FOREIGN KEY (serverid) REFERENCES servers(id),
  FOREIGN KEY (permissionid) REFERENCES permissions(id)
);

