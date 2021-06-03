CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '123acpr';
GRANT ALL ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '123acpr';
FLUSH PRIVILEGES;