# nextcloud
ok


# Cria o grupo com um GID específico (ex: 2000)
sudo groupadd -g 2000 docker-data

# Adicione seu usuário emerson a esse grupo para que você possa ver os arquivos
sudo usermod -aG docker-data emerson