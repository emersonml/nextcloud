sudo docker exec -it nextcloud-db-1 /bin/bash
mysql -u root -p

# esse o docker ja cria
CREATE USER 'admin' IDENTIFIED BY 'emer99559'; 
GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin' IDENTIFIED BY 'emer99559' WITH GRANT OPTION;

++++++++

### mysql client
mysql -u root -p -h 10.0.3.3 -P 3306
