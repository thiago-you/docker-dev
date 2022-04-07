# this file should create your databases if not exist
# and create and grant permissions to default user

# create databases
# CREATE DATABASE IF NOT EXISTS `database`;

# create all mysql users
CREATE USER 'cpn'@'localhost' IDENTIFIED BY 'cpn#2010';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'cpn#2010';
CREATE USER 'cconet'@'localhost' IDENTIFIED BY 'cpn#2010';
CREATE USER 'cpn'@'%' IDENTIFIED BY 'cpn#2010';
CREATE USER 'admin'@'%' IDENTIFIED BY 'cpn#2010';
CREATE USER 'cconet'@'%' IDENTIFIED BY 'cpn#2010';

# grant rights to all mysql users
GRANT ALL PRIVILEGES ON *.* TO 'cpn'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'cconet'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'cpn'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'cconet'@'%';