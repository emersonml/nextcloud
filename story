sudo docker exec -it pcnuvem-mariadb-1 /bin/bash
mysql -u root -p

# esse o docker ja cria
CREATE USER 'admin' IDENTIFIED BY 'emer99559'; 
GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin' IDENTIFIED BY 'emer99559' WITH GRANT OPTION;




10.0.3.3:3306 or mariadb or 127.0.0.1:3307

+++++++++++++++++

### mysql client
mysql -u root -p -h 10.0.3.3 -P 3306
or mysql -u root -p -h 127.0.0.1 -P 3307
