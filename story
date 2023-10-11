
sudo docker exec -it nextcloud-mariadb-1 /bin/bash
mysql -u root -p

# esse o docker ja cria
CREATE USER 'admin' IDENTIFIED BY 'emer999'; 
GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin' IDENTIFIED BY 'emer999' WITH GRANT OPTION;



emerson
emer777
root
emer888
nextcloud
10.0.3.3:3306 or mariadb or 127.0.0.1:3307

+++++++++++++++++

### mysql client
mysql -u root -p -h 10.0.3.3 -P 3306
or mysql -u root -p -h 127.0.0.1 -P 3307
