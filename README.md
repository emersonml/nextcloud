


<?php
$CONFIG = array (
  'instanceid' => 'xxxxxxxx',
  'passwordsalt' => 'xxxxxxxx',
  'secret' => 'xxxxxxxx',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'nextcloud-app',
    2 => 'nuvem.localhost',
    3 => 'xxxxxx/xx',
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
















