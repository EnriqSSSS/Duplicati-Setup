#!/bin/bash

# Variáveis editáveis
CLOUD_FOLDER="" # /caminho/ate/pasta/cloud, ex: /root/docker/nxtc-k9n
CLOUD_NAME=""   # Nome do cloud, ex: k9n, showoff, etc..
DB_PASSWORD=""  # Senha do banco de dados do nextcloud

######
USERNAME="nextcloud"
DATABASE="nextcloud"

CONTAINER_APP="nextcloud-$CLOUD_NAME-app"
CONTAINER_DB="nextcloud-$CLOUD_NAME-db"
BACKUP_FOLDER="$CLOUD_FOLDER/bkp" # mudar para bkp
BACKUP_FILE="$BACKUP_FOLDER/sql/$CLOUD_NAME-sqldump.sql"

# Entra em modo de manutenção para garantir a consistência dos dados, este mode precisa ser desativado após o fim do backup
docker exec -u33 $CONTAINER_APP php occ maintenance:mode --on

# Cria a pasta de backup caso ela ainda não exista
mkdir -p $BACKUP_FOLDER/sql/

# Faz um mysql dump de todos os dados do banco de dados
docker exec $CONTAINER_DB mysqldump -f -u$USERNAME -p$DB_PASSWORD $DATABASE > $BACKUP_FILE

# Após a execução do SQL DUMP, será realizado o backup dos arquivos.
