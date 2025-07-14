#!/bin/bash

# Variáveis editáveis
CLOUD_FOLDER="" # /caminho/ate/pasta/cloud, ex: /root/docker/nxtc-k9n
CLOUD_NAME=""   # Nome do cloud, ex: k9n, showoff, etc..

######
CONTAINER_APP="nextcloud-$CLOUD_NAME-app"
BACKUP_FOLDER="$CLOUD_FOLDER/bkp"

# Cria a pasta de backup caso ela ainda não exista
mkdir -p $BACKUP_FOLDER

# Sai do modo de manutenção
docker exec -u33 $CONTAINER_APP php occ maintenance:mode --off
