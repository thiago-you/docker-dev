# this file should create your databases if not exist
# and create and grant permissions to default user

# create databases
CREATE DATABASE IF NOT EXISTS `database`;

# create default user and grant rights
CREATE USER 'cpn'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'cpn'@'%';