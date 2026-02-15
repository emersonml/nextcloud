


<?php
$CONFIG = array (
  'instanceid' => 'ocsg9qqbv1zx',
  'passwordsalt' => 's9evX59PUgEhqh6JAJs3ggmThmWLfO',
  'secret' => '/RU0ZROM9XPzf3NATc0Daxcz+fX0UUzGl5xq6E927GYljP1k',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'nextcloud-app',
    2 => 'nuvem.localhost',
    3 => '172.22.0.0/16',
    4 => '0.0.0.0:8000',
  ),
  'overwrite.cli.url' => 'https://nuvem.localhost',
  'overwriteprotocol' => 'https',
  'overwritehost' => 'nuvem.localhost',
  'htaccess.RewriteBase' => '/',
  'trusted_proxies' => 
  array (
    0 => 'npm-app',
    1 => '172.22.0.0/16',
  ),
  'forwarded_for_headers' => 
  array (
    0 => 'HTTP_X_FORWARDED_FOR',
  ),
  'datadirectory' => '/data',
  'dbtype' => 'mysql',
  'version' => '32.0.5.0',
  'dbname' => 'nextcloud',
  'dbhost' => 'nextcloud-db',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'oc_oc_admin',
  'dbpassword' => '[5^kHKm0=BJljCDUP_?L_ow+.x.%63',
  'installed' => true,
  'memcache.local' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => 'nextcloud-redis',
    'port' => 6379,
    'timeout' => 0.0,
    'password' => '',
  ),
  'default_phone_region' => 'BR',
  'auth.bruteforce.protection.enabled' => true,
  'forcessl' => true,
  'forceSSLforSubdomains' => true,
  'maintenance' => false,
  'theme' => '',
  'loglevel' => 2,
  'logfile' => '/config/log/nextcloud/nextcloud.log',
  'logfilemode' => 416,
  'log_rotate_size' => 104857600,
  'filesystem_check_changes' => 1,
  'trashbin_retention_obligation' => 'auto, 30',
  'versions_retention_obligation' => 'auto, 365',
  'default_locale' => 'pt_BR',
  'default_language' => 'pt_BR',
  'knowledgebaseenabled' => false,
  'allow_user_to_change_display_name' => true,
  'remember_login_cookie_lifetime' => 1296000,
  'session_lifetime' => 86400,
  'session_keepalive' => true,
  'skeletondirectory' => '',
  'filelocking.enabled' => true,
  'upgrade.disable-web' => true,
);



















# Nextcloud com Docker + NPM - Guia Completo

## 📋 Visão Geral

Stack completo do Nextcloud usando Docker com:
- **MariaDB** - Banco de dados
- **Redis** - Cache para performance
- **Nextcloud** - Aplicação principal
- **NPM** - Nginx Proxy Manager para SSL/proxy reverso

## 🗂️ Estrutura de Volumes

### Named Volumes (gerenciados pelo Docker)
```
mariadb_data      → Banco de dados MariaDB
nextcloud_data    → Arquivos dos usuários
```

**Localização física:**
```
/var/lib/docker/volumes/nextcloud_mariadb_data/_data/
/var/lib/docker/volumes/nextcloud_nextcloud_data/_data/
```

### Bind Mount (acesso direto)
```
/srv/docker/volumes/nextcloud/nextcloud/config/ → Configurações do Nextcloud
```

**Por que essa combinação?**
- ✅ Named volumes = melhor performance para dados/DB
- ✅ Bind mount config = fácil acesso para editar config.php

## 🌐 Portas e Acesso

```
8000   → HTTP  (redireciona para HTTPS)
44300  → HTTPS (usar no NPM como Forward Port)
```

**Acesso direto (sem NPM):**
```
https://seu-servidor:44300
```

**Acesso via NPM (recomendado):**
```
https://cloud.seudominio.com
```

## 🚀 Instalação Rápida

### 1. Preparar ambiente

```bash
# Criar diretório do projeto
mkdir -p ~/nextcloud && cd ~/nextcloud

# Copiar arquivos docker-compose.yml e .env

# Criar diretório para bind mount
sudo mkdir -p /srv/docker/volumes/nextcloud/nextcloud/config

# Ajustar permissões
sudo chown -R 1000:1000 /srv/docker/volumes/nextcloud
```

### 2. Configurar .env

```bash
nano .env
```

**Altere:**
- `TZ` - Seu timezone
- `NEXTCLOUD_DOMAIN` - Seu domínio
- `MYSQL_ROOT_PASSWORD` - Senha root do MariaDB
- `MYSQL_PASSWORD` - Senha do usuário nextcloud
- `PHP_MEMORY_LIMIT` - Memória PHP (padrão: 512M)
- `PHP_UPLOAD_LIMIT` - Limite upload (padrão: 128M)

### 3. Iniciar containers

```bash
# Subir todos os containers
docker-compose up -d

# Verificar status
docker-compose ps

# Ver logs
docker-compose logs -f nextcloud-app
```

**Aguarde alguns minutos** - A primeira inicialização demora para configurar.

### 4. Configurar NPM (Nginx Proxy Manager)

#### A. Adicionar Proxy Host

**Details:**
- Domain Names: `cloud.seudominio.com`
- Scheme: `https`
- Forward Hostname/IP: `nextcloud-app`
- Forward Port: `443`
- ✅ Cache Assets
- ✅ Block Common Exploits
- ✅ Websockets Support

**SSL:**
- ✅ Request a new SSL Certificate
- ✅ Force SSL
- ✅ HTTP/2 Support
- ✅ HSTS Enabled
- Email: seu@email.com
- ✅ I Agree to the Let's Encrypt Terms of Service

**Advanced (Custom Nginx Configuration):**
```nginx
# Upload de arquivos grandes
client_max_body_size 10G;
client_body_timeout 300s;

# Headers para Nextcloud
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

# Timeouts
proxy_connect_timeout 300;
proxy_send_timeout 300;
proxy_read_timeout 300;
send_timeout 300;
```

#### B. Conectar redes (se necessário)

Se NPM e Nextcloud estiverem em composes separados:

```bash
# Descobrir nome do container NPM
docker ps | grep npm

# Conectar à rede do Nextcloud
docker network connect nextcloud-network npm-app
```

### 5. Configuração Inicial do Nextcloud

#### A. Primeiro acesso

Acesse: `https://cloud.seudominio.com`

**Criar conta admin:**
- Usuário: escolha um nome
- Senha: senha forte (mínimo 12 caracteres)

#### B. Configurar banco de dados

**Clique em "Storage & database"** → Selecione "MySQL/MariaDB"

```
Database user:     nextcloud
Database password: (copie do .env MYSQL_PASSWORD)
Database name:     nextcloud
Database host:     nextcloud-db:3306
```

**Clique em "Install"** e aguarde a instalação.

### 6. Configurar config.php (IMPORTANTE!)

Após a instalação inicial, edite o config.php para otimizações.

#### Opção 1: Editar do host
```bash
sudo nano /srv/docker/volumes/nextcloud/nextcloud/config/www/nextcloud/config/config.php
```

#### Opção 2: Editar do container
```bash
docker exec -it nextcloud-app bash
nano /config/www/nextcloud/config/config.php
```

#### Adicionar no config.php:

```php
<?php
$CONFIG = array (
  // ... configurações existentes ...
  
  // ========================================
  // DOMÍNIO E PROXY
  // ========================================
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'nextcloud-app',
    2 => 'cloud.seudominio.com',  // ← SEU DOMÍNIO
  ),
  
  'overwrite.cli.url' => 'https://nuvem.localhost',
  'overwriteprotocol' => 'https',
  
  'trusted_proxies' => 
  array (
    0 => 'npm-app',
  ),
  
  'forwarded_for_headers' => 
  array (
    0 => 'HTTP_X_FORWARDED_FOR',
  ),
  
  // ========================================
  // REDIS (CACHE)
  // ========================================
  'memcache.local' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => 'nextcloud-redis',
    'port' => 6379,
  ),
  
  // ========================================
  // OTIMIZAÇÕES
  // ========================================
  'default_phone_region' => 'BR',
  'maintenance' => false,
);
```

**Salvar:**
- Nano: `Ctrl+O` → `Enter` → `Ctrl+X`
- Vi/Vim: `Esc` → `:wq`

#### Reiniciar Nextcloud:
```bash
docker-compose restart nextcloud-app
```

### 7. Verificar configuração

Acesse: **Configurações → Administração → Visão geral**

Verifique se há avisos. Os principais já devem estar resolvidos:
- ✅ Redis configurado
- ✅ Trusted domains OK
- ✅ HTTPS ativo
- ✅ Proxy reverso reconhecido

## ⚙️ Configurações Recomendadas

### Background Jobs (Cron)

Para melhor performance, configure cron jobs:

```bash
# Editar crontab
sudo crontab -e

# Adicionar (executa a cada 5 minutos)
*/5 * * * * docker exec -u abc nextcloud-app php /config/www/nextcloud/cron.php
```

**No Nextcloud:**
Configurações → Administração → Configurações básicas → Selecione **"Cron"**

### Aplicativos Essenciais

Instale em: **Apps → Your apps**
- ✅ Calendar - Calendários
- ✅ Contacts - Contatos
- ✅ Notes - Notas
- ✅ Photos - Galeria de fotos
- ✅ Talk - Videochamadas/Chat
- ✅ Deck - Kanban/Tarefas
- ✅ Mail - Cliente de email
- ✅ Tasks - Lista de tarefas

### Email (SMTP)

Configure em: **Configurações → Administração → Configurações básicas**

Para Gmail:
```
Servidor SMTP:     smtp.gmail.com
Porta:             587
Criptografia:      STARTTLS
Usuário:           seu@gmail.com
Senha:             (senha de app do Gmail)
```

### 2FA (Autenticação de Dois Fatores)

**Configurações → Segurança → Two-Factor Authentication**

Opções:
- TOTP (Google Authenticator, Authy)
- SMS (com app adicional)
- Email

## 📦 Comandos Úteis

### Gerenciamento de Containers

```bash
# Ver logs
docker-compose logs -f nextcloud-app
docker-compose logs -f nextcloud-db

# Reiniciar
docker-compose restart
docker-compose restart nextcloud-app

# Parar
docker-compose down

# Parar e remover volumes (CUIDADO!)
docker-compose down -v

# Atualizar
docker-compose pull
docker-compose up -d
```

### Comandos OCC (Nextcloud)

```bash
# Entrar no container
docker exec -it nextcloud-app bash

# Ir para diretório Nextcloud
cd /config/www/nextcloud

# Ver status
sudo -u abc php occ status

# Scan de arquivos
sudo -u abc php occ files:scan --all

# Modo manutenção ON
sudo -u abc php occ maintenance:mode --on

# Modo manutenção OFF
sudo -u abc php occ maintenance:mode --off

# Listar usuários
sudo -u abc php occ user:list

# Resetar senha de usuário
sudo -u abc php occ user:resetpassword username

# Adicionar índices faltantes
sudo -u abc php occ db:add-missing-indices

# Converter tabelas para BigInt
sudo -u abc php occ db:convert-filecache-bigint

# Sair do container
exit
```

### Edição Rápida do config.php

```bash
# Do host
sudo nano /srv/docker/volumes/nextcloud/nextcloud/config/www/nextcloud/config/config.php

# Do container
docker exec -it nextcloud-app nano /config/www/nextcloud/config/config.php
```

## 💾 Backup e Restore

### Backup Completo

```bash
#!/bin/bash
# Script de backup completo

DATA_BACKUP="/backup/nextcloud"
DATE=$(date +%Y%m%d_%H%M%S)

# Criar diretório de backup
mkdir -p $DATA_BACKUP

# 1. Ativar modo manutenção
docker exec -u abc nextcloud-app php /config/www/nextcloud/occ maintenance:mode --on

# 2. Backup config (bind mount)
sudo tar -czf $DATA_BACKUP/config_$DATE.tar.gz \
  /srv/docker/volumes/nextcloud/nextcloud/config

# 3. Backup volumes named
docker run --rm \
  -v nextcloud_nextcloud_data:/data \
  -v nextcloud_mariadb_data:/mariadb \
  -v $DATA_BACKUP:/backup \
  alpine tar -czf /backup/volumes_$DATE.tar.gz /data /mariadb

# 4. Desativar modo manutenção
docker exec -u abc nextcloud-app php /config/www/nextcloud/occ maintenance:mode --off

echo "Backup completo em: $DATA_BACKUP"
ls -lh $DATA_BACKUP/
```

### Backup Apenas Banco de Dados

```bash
# Backup SQL
docker exec nextcloud-db mysqldump \
  -u nextcloud \
  -p'sua_senha' \
  nextcloud > backup_nextcloud_db_$(date +%Y%m%d).sql

# Comprimir
gzip backup_nextcloud_db_$(date +%Y%m%d).sql
```

### Restore

```bash
# 1. Parar Nextcloud
docker-compose down

# 2. Restaurar config
sudo tar -xzf config_YYYYMMDD_HHMMSS.tar.gz -C /

# 3. Restaurar volumes
docker run --rm \
  -v nextcloud_nextcloud_data:/data \
  -v nextcloud_mariadb_data:/mariadb \
  -v /backup/nextcloud:/backup \
  alpine sh -c "cd / && tar -xzf /backup/volumes_YYYYMMDD_HHMMSS.tar.gz"

# 4. Iniciar Nextcloud
docker-compose up -d
```

## 🔍 Troubleshooting

### Erro 502 Bad Gateway

```bash
# Verificar containers
docker-compose ps

# Ver logs
docker-compose logs nextcloud-app

# Reiniciar
docker-compose restart nextcloud-app

# Se necessário, recriar
docker-compose down
docker-compose up -d
```

### Erro "Trusted Domain"

Edite config.php e adicione seu domínio em `trusted_domains`:

```php
'trusted_domains' => 
array (
  0 => 'localhost',
  1 => 'nextcloud-app',
  2 => 'cloud.seudominio.com',  // Adicione aqui
),
```

### Performance Lenta

1. **Verificar Redis:**
```bash
docker exec nextcloud-app redis-cli -h nextcloud-redis ping
# Deve retornar: PONG
```

2. **Verificar config.php** - Confirme que Redis está configurado

3. **Aumentar recursos PHP** no .env:
```bash
PHP_MEMORY_LIMIT=1024M
PHP_UPLOAD_LIMIT=256M
```

4. **Configurar Cron** (ver seção "Background Jobs")

### Upload de Arquivos Grandes Falha

1. **Aumentar limite no .env:**
```bash
PHP_UPLOAD_LIMIT=512M
```

2. **Aumentar no NPM** (Custom Nginx Configuration):
```nginx
client_max_body_size 10G;
```

3. **Reiniciar:**
```bash
docker-compose restart nextcloud-app
```

### Avisos no Painel Administrativo

Acesse: **Configurações → Administração → Visão geral**

**Avisos comuns:**

1. **"O servidor de banco de dados não tem uma configuração de codificação adequada"**
```bash
docker exec nextcloud-db mysql -u root -p'senha_root' \
  -e "ALTER DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
```

2. **"Alguns índices do banco de dados estão faltando"**
```bash
docker exec -u abc nextcloud-app php /config/www/nextcloud/occ db:add-missing-indices
```

3. **"Algumas colunas não foram convertidas para BigInt"**
```bash
docker exec -u abc nextcloud-app php /config/www/nextcloud/occ db:convert-filecache-bigint
```

### Resetar Senha Admin

```bash
docker exec -it nextcloud-app bash
cd /config/www/nextcloud
sudo -u abc php occ user:resetpassword admin
```

## 🔒 Segurança

### Checklist de Segurança

- ✅ Senhas fortes (mínimo 12 caracteres)
- ✅ 2FA habilitado para todos os usuários
- ✅ SSL/TLS via NPM (Let's Encrypt)
- ✅ HSTS habilitado
- ✅ Firewall configurado (bloquear portas 8000/44300 publicamente)
- ✅ Backups automáticos
- ✅ Atualizações regulares
- ✅ Logs revisados periodicamente
- ✅ Permissões de arquivo corretas (PUID/PGID 1000)

### Hardening Adicional

**No config.php:**
```php
// Sessões mais seguras
'session_lifetime' => 3600,  // 1 hora
'session_keepalive' => false,

// Forçar HTTPS
'forcessl' => true,
'forceSSLforSubdomains' => true,

// Segurança de senha
'password_policy' => [
  'minLength' => 12,
  'enforceNonCommonPassword' => true,
],

// Proteção contra força bruta
'auth.bruteforce.protection.enabled' => true,
```

## 📊 Monitoramento

### Ver Uso de Recursos

```bash
# CPU e Memória
docker stats nextcloud-app nextcloud-db nextcloud-redis

# Espaço em disco dos volumes
docker system df -v | grep nextcloud

# Tamanho dos volumes
du -sh /var/lib/docker/volumes/nextcloud_*
```

### Logs Importantes

```bash
# Logs do Nextcloud
docker exec nextcloud-app tail -f /config/log/nextcloud/nextcloud.log

# Logs do MariaDB
docker-compose logs nextcloud-db

# Logs em tempo real
docker-compose logs -f --tail=100
```

## 🚀 Otimizações Avançadas

### Preview Generator (Miniaturas)

```bash
# Instalar app
docker exec -u abc nextcloud-app php /config/www/nextcloud/occ app:install previewgenerator

# Gerar previews existentes
docker exec -u abc nextcloud-app php /config/www/nextcloud/occ preview:generate-all

# Adicionar ao crontab (gerar novos previews)
*/10 * * * * docker exec -u abc nextcloud-app php /config/www/nextcloud/occ preview:pre-generate
```

### Object Storage (S3/MinIO)

Para armazenar arquivos em S3 em vez do volume local, configure em `config.php`:

```php
'objectstore' => [
  'class' => '\\OC\\Files\\ObjectStore\\S3',
  'arguments' => [
    'bucket' => 'nextcloud',
    'autocreate' => true,
    'key' => 'sua_key',
    'secret' => 'seu_secret',
    'hostname' => 's3.amazonaws.com',
    'region' => 'us-east-1',
    'use_ssl' => true,
  ],
],
```

## 📱 Apps Móveis

- **iOS:** [Nextcloud na App Store](https://apps.apple.com/app/nextcloud/id1125420102)
- **Android:** [Nextcloud no Google Play](https://play.google.com/store/apps/details?id=com.nextcloud.client)

### Sincronização Desktop

- **Windows/Mac/Linux:** [Download](https://nextcloud.com/install/#install-clients)

## 🔗 Integrações

### Office Online (Collabora/OnlyOffice)

Permite edição de documentos no navegador:

1. Instale o app **Collabora Online** ou **OnlyOffice**
2. Configure servidor do Collabora/OnlyOffice
3. Reinicie Nextcloud

### External Storage

Conecte armazenamentos externos:
- Google Drive
- Dropbox
- FTP/SFTP
- SMB/CIFS
- WebDAV

**Apps → External storage support**

## 📚 Recursos Adicionais

### Documentação Oficial
- [Nextcloud Admin Manual](https://docs.nextcloud.com/server/latest/admin_manual/)
- [Nextcloud User Manual](https://docs.nextcloud.com/server/latest/user_manual/)
- [LinuxServer.io Nextcloud](https://docs.linuxserver.io/images/docker-nextcloud)

### Comunidade
- [Nextcloud Forum](https://help.nextcloud.com/)
- [Nextcloud GitHub](https://github.com/nextcloud/server)
- [r/NextCloud](https://reddit.com/r/NextCloud)

## 📝 Resumo Final

Você agora tem:
- ✅ Nextcloud rodando com MariaDB e Redis
- ✅ SSL configurado via NPM
- ✅ Named volumes para performance
- ✅ Bind mount para fácil acesso ao config.php
- ✅ Backup e restore configurados
- ✅ Segurança hardened
- ✅ Monitoramento e logs
- ✅ Otimizações aplicadas

**Próximos passos:**
1. Configure 2FA para todos os usuários
2. Configure backups automáticos
3. Instale apps essenciais
4. Configure email (SMTP)
5. Teste upload/download de arquivos grandes
6. Configure sincronização mobile/desktop

Aproveite seu Nextcloud! ☁️










############# NPM ======   NPM=






# Configuração do Nextcloud no Nginx Proxy Manager (NPM)

## 📋 Pré-requisitos

Antes de começar:
- ✅ Nextcloud rodando: `docker-compose ps`
- ✅ NPM acessível: `http://seu-servidor:81`
- ✅ Domínio apontando para seu servidor (DNS configurado)
- ✅ Portas 80 e 443 abertas no firewall

## 🌐 Passo 1: Acessar o NPM

1. Abra o navegador e acesse:
   ```
   http://seu-servidor:81
   ```



### 2.2 Aba "Details"

Preencha os campos:

```
┌─────────────────────────────────────────────────────────┐
│ Domain Names                                            │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ cloud.seudominio.com                                │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Scheme                    Forward Hostname / IP        │
│ ┌──────────┐              ┌───────────────────────────┐│
│ │ https ▼  │              │ nextcloud-app             ││
│ └──────────┘              └───────────────────────────┘│
│                                                         │
│ Forward Port                                            │
│ ┌─────────┐                                            │
│ │ 443     │                                            │
│ └─────────┘                                            │
│                                                         │
│ ☑ Cache Assets                                         │
│ ☑ Block Common Exploits                                │
│ ☑ Websockets Support                                   │
│ ☐ Access List                                          │
└─────────────────────────────────────────────────────────┘
```

**Valores importantes:**
- **Domain Names:** `cloud.seudominio.com` (SEU domínio)
- **Scheme:** `https` (HTTPS)
- **Forward Hostname/IP:** `nextcloud-app` (nome do container)
- **Forward Port:** `443` (porta HTTPS do Nextcloud)

**Checkboxes:**
- ✅ **Cache Assets** - Melhor performance
- ✅ **Block Common Exploits** - Segurança
- ✅ **Websockets Support** - Necessário para Nextcloud

### 2.3 Aba "SSL"

Configure o certificado SSL:

```
┌─────────────────────────────────────────────────────────┐
│ SSL Certificate                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Request a new SSL Certificate ▼                     │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ☑ Force SSL                                            │
│ ☑ HTTP/2 Support                                       │
│ ☑ HSTS Enabled                                         │
│ ☐ HSTS Subdomains                                      │
│                                                         │
│ Email Address for Let's Encrypt                        │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ seu@email.com                                       │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ☑ I Agree to the Let's Encrypt Terms of Service       │
└─────────────────────────────────────────────────────────┘
```

**Valores importantes:**
- **SSL Certificate:** `Request a new SSL Certificate`
- **Email:** Seu email real (para avisos de renovação)

**Checkboxes:**
- ✅ **Force SSL** - Força HTTPS
- ✅ **HTTP/2 Support** - Melhor performance
- ✅ **HSTS Enabled** - Segurança (força HTTPS no navegador)
- ✅ **I Agree...** - Aceitar termos do Let's Encrypt

### 2.4 Aba "Advanced"

Cole esta configuração customizada:

```nginx
# ==================================================
# NEXTCLOUD - CONFIGURAÇÃO CUSTOMIZADA
# ==================================================

# Timeout para uploads grandes
client_max_body_size 10G;
client_body_timeout 300s;
client_body_buffer_size 512k;

# Headers necessários para o Nextcloud
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Port $server_port;

# Timeouts aumentados para operações longas
proxy_connect_timeout 300;
proxy_send_timeout 300;
proxy_read_timeout 300;
send_timeout 300;

# Buffer settings
proxy_buffering off;
proxy_request_buffering off;
proxy_max_temp_file_size 0;

# WebDAV methods
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $http_connection;
```

**Cole exatamente como está acima!**

### 2.5 Salvar

Clique em **"Save"** no canto inferior direito.

## ✅ Passo 3: Verificação

### 3.1 Aguardar certificado SSL

O NPM vai:
1. Solicitar certificado ao Let's Encrypt
2. Validar seu domínio
3. Instalar o certificado

**Isso leva 30-60 segundos.**

### 3.2 Verificar na lista

Você deve ver:

```
┌────────────────────────────────────────────────────────────┐
│ Proxy Hosts                                                │
├────────────────────────────────────────────────────────────┤
│ cloud.seudominio.com                                       │
│ → https://nextcloud-app:443                                │
│ 🔒 SSL: Let's Encrypt                                      │
│ Status: Online                                             │
└────────────────────────────────────────────────────────────┘
```

## 🌍 Passo 4: Testar Acesso

Abra o navegador e acesse:
```
https://cloud.seudominio.com
```

**Deve aparecer:**
- 🔒 Cadeado verde (SSL válido)
- Tela de configuração do Nextcloud (primeira vez)
- OU tela de login (se já configurado)

## ⚙️ Configurações Alternativas

### Se o NPM estiver em outro servidor

Use o IP em vez do hostname:

```
Forward Hostname/IP: 192.168.1.100 (IP do servidor Nextcloud)
Forward Port: 44300
```

### Se quiser mais segurança

Adicione na aba "Advanced":

```nginx
# Headers de segurança adicionais
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
```

### Para uploads MUITO grandes (>10GB)

Na aba "Advanced", altere:

```nginx
client_max_body_size 50G;  # Aumentar de 10G para 50G
```

## 🔧 Troubleshooting

### ❌ Erro: "502 Bad Gateway"

**Causa:** NPM não consegue conectar ao Nextcloud

**Solução:**
```bash
# Verificar se Nextcloud está rodando
docker ps | grep nextcloud-app

# Verificar se NPM está na mesma rede
docker network inspect nextcloud-network

# Se não estiver, conectar
docker network connect nextcloud-network npm-app
```

### ❌ Erro: "This site can't provide a secure connection"

**Causa:** Certificado SSL não foi instalado corretamente

**Solução:**
1. Volte ao NPM
2. Edite o Proxy Host
3. Aba SSL → Force SSL → Salvar novamente
4. Aguarde 1 minuto

### ❌ Erro: "Trusted domain error" no Nextcloud

**Causa:** Nextcloud não reconhece o domínio

**Solução:**
Edite o config.php:
```bash
sudo nano /srv/docker/volumes/nextcloud/nextcloud/config/www/nextcloud/config/config.php
```

Adicione seu domínio:
```php
'trusted_domains' => 
array (
  0 => 'localhost',
  1 => 'nextcloud-app',
  2 => 'cloud.seudominio.com',  // ← Adicione aqui
),
```

Reinicie:
```bash
docker-compose restart nextcloud-app
```

### ❌ Upload de arquivo grande falha

**Solução 1 - No NPM:**
Edite o Proxy Host → Advanced → Aumente:
```nginx
client_max_body_size 20G;
client_body_timeout 600s;
```

**Solução 2 - No Nextcloud:**
Edite o `.env`:
```bash
PHP_UPLOAD_LIMIT=512M
```

Reinicie:
```bash
docker-compose restart nextcloud-app
```

## 📊 Resumo Visual da Configuração

```
Internet
   ↓
   🌍 https://cloud.seudominio.com
   ↓
   🔒 Let's Encrypt SSL (NPM)
   ↓
   🔀 Nginx Proxy Manager (porta 443)
   ↓
   📡 nextcloud-network
   ↓
   ☁️  Nextcloud Container (nextcloud-app:443)
   ↓
   💾 MariaDB + Redis
```

## 🎯 Checklist Final

Antes de finalizar, confirme:

- ✅ DNS do domínio aponta para seu servidor
- ✅ Firewall libera portas 80 e 443
- ✅ NPM está rodando: `docker ps | grep npm`
- ✅ Nextcloud está rodando: `docker ps | grep nextcloud`
- ✅ NPM e Nextcloud na mesma rede: `docker network inspect nextcloud-network`
- ✅ Proxy Host criado no NPM
- ✅ SSL configurado (Let's Encrypt)
- ✅ Configuração Advanced aplicada
- ✅ Domínio acessível com HTTPS
- ✅ Trusted domain configurado no config.php

## 📝 Configuração Completa (Copiar e Colar)

### Aba Details:
```
Domain Names: cloud.seudominio.com
Scheme: https
Forward Hostname/IP: nextcloud-app
Forward Port: 443
☑ Cache Assets
☑ Block Common Exploits
☑ Websockets Support
```

### Aba SSL:
```
SSL Certificate: Request a new SSL Certificate
☑ Force SSL
☑ HTTP/2 Support
☑ HSTS Enabled
Email: seu@email.com
☑ I Agree to the Let's Encrypt Terms of Service
```

### Aba Advanced:
```nginx
client_max_body_size 10G;
client_body_timeout 300s;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_connect_timeout 300;
proxy_send_timeout 300;
proxy_read_timeout 300;
send_timeout 300;
```

## 🎓 Próximos Passos

Após configurar o NPM:

1. ✅ Acesse o Nextcloud via domínio
2. ✅ Complete a instalação inicial
3. ✅ Configure o config.php (Redis, trusted domains)
4. ✅ Configure 2FA
5. ✅ Instale apps essenciais
6. ✅ Configure backups

## 📚 Recursos

- [NPM Documentação](https://nginxproxymanager.com/guide/)
- [Let's Encrypt Limits](https://letsencrypt.org/docs/rate-limits/)
- [Nextcloud Proxy Settings](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html)

---

**Pronto!** Seu Nextcloud está configurado com SSL via NPM! 🎉

