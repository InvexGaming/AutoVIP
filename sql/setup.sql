-- Setup AutoVIP
-- Warning: This will remove all current entries! Backup first.

DROP DATABASE IF EXISTS autovip;
CREATE DATABASE autovip;

USE autovip;
/*
* Lists all servers
*/
DROP TABLE IF EXISTS servers;
CREATE TABLE servers
(
  id INT NOT NULL AUTO_INCREMENT,
  short_name VARCHAR(64), -- short name, no spaces, all lowercase
  nice_name VARCHAR(64), -- nice name
  active BIT(1) NOT NULL, -- is server active or not
  PRIMARY KEY (id)
);

/*
* Permissions tables for Sourcemod Admin Groups
*/
DROP TABLE IF EXISTS permissions;
CREATE TABLE permissions
(
  id INT NOT NULL AUTO_INCREMENT,
  tag VARCHAR(32), -- referring to groups in admin_groups.cfg, includes @ symbol
  PRIMARY KEY (id)
);

/*
* Package Table, contains VIP packages
*/
DROP TABLE IF EXISTS packages;
CREATE TABLE packages
(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(64),
  description VARCHAR(255),
  cost DECIMAL(13, 4) NOT NULL,
  credits_included INT DEFAULT 0, -- per quantity/total
  num_servers INT NOT NULL, -- 0 for all servers, -1 for not applicable
  duration INT NOT NULL,  -- in days, 0 for permanent
  active BIT(1) NOT NULL, -- inactive packages not added to admin_simple.ini file
  purchasable BIT(1) NOT NULL, -- which packages are available to be purchased
  permissionid INT,
  ordernum INT DEFAULT 99999, -- used to determine which order packages are displayed
  FOREIGN KEY (permissionid) REFERENCES permissions(id),
  PRIMARY KEY (id)
);

/*
* transactions, stores checkout, payment information
*/
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions
(
  id INT NOT NULL AUTO_INCREMENT,
  cost DECIMAL(13, 4) NOT NULL, -- cumulative/total amount paid in transaction
  steamid VARCHAR(32), -- prefixed STEAM_1:Y:Z
  username VARCHAR(64),
  userid INT, -- invalid or missing = -1
  start_date INT(11) NOT NULL,
  end_date INT(11), -- NULL if permanent
  packageid INT,
  comment VARCHAR(255), -- for extra info
  PRIMARY KEY(id),
  FOREIGN KEY (packageid) REFERENCES packages(id)
);

/*
* Selected Servers, 1 or more chosen by user for particular transaction
* Only exists/needed if package.num_servers > 0 in transaction
*/
DROP TABLE IF EXISTS selectedservers;
CREATE TABLE selectedservers
(
  transactionid INT,
  serverid INT,
  PRIMARY KEY (transactionid, serverid),
  FOREIGN KEY (transactionid) REFERENCES transactions(id),
  FOREIGN KEY (serverid) REFERENCES servers(id)
)
