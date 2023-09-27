
sudo docker exec -it nextcloud-mariadb-1 /bin/bash
mysql -u root -p
CREATE USER 'admin' IDENTIFIED BY 'emer999';