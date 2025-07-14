#!/bin/bash

# Este script envia o status de resultado dos backups para o servidor zabix

# Pre-requisistos:
# - Ter um servidor zabbix funcionando
# - Ter um host configurado corretamente
# - /usr/bin/zabbix_sender
#   - Instalar repositório: https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/
#   - apt update; apt install zabbix_sender
# - configurar /etc/zabbix_agentd.conf
#   - Incluir o $SERVER_IP nas variáveis "Server=", "ServerActive="
#   - Inlcuir o $HOST na variável "Hostname="

# Uso:
# - Na interface web do duplicati: Configurações > Opções padrão > Editar como texto
#   - Incluir --run-script-before=/path/to/zabbix-report/duplicati-zabbix-report.sh
#   - Incluir --run-script-after=/path/to/zabbix-report/duplicati-zabbix-report.sh
# TO-DO: Ainda tenho que pensar em alguma forma padronizada para executar mais de 1 script por backup

# Variáveis editáveis
SERVER_IP=
HOST=

######
KEY_PREFIX="duplicati.backup"

BACKUP_ID="${DUPLICATI__backup_name:-unnamed}"
EVENT_NAME=$DUPLICATI__EVENTNAME
OPERATION_NAME=$DUPLICATI__OPERATIONNAME
OPERATION_RESULT=$DUPLICATI__PARSED_RESULT

DISCOVERY_JSON=$(cat <<EOF
{"data":[{"{#BACKUP_ID}":"$BACKUP_ID"}]}
EOF
)

TEMP_DIR="/tmp/"
mkdir -p "$TEMP_DIR"
START_TIME_FILE="$TEMP_DIR/${BACKUP_ID}_start.time"

NOW=$(date +%s)
NOW_HUMAN=$(date "+%Y-%m-%d %H:%M:%S")
######

send_report() {
    local key="$1"
    local value="$2"
    /usr/bin/zabbix_sender -z "$SERVER_IP" -s "$HOST" -k "$key" -o "$value"
}

# Inicio do backup
if [ "$EVENT_NAME" == "BEFORE" ] && [ "$OPERATION_NAME" == "Backup" ]; then
    echo "$NOW" > "$START_TIME_FILE"
    # Envia um JSON com o nome do backup, isto serve para separar os alerta com base nos trabalhos de backup
    send_report "$KEY_PREFIX.discovery" "$DISCOVERY_JSON"
    exit 0
fi


# Fim do backup
if [ "$EVENT_NAME" == "AFTER" ] && [ "$OPERATION_NAME" == "Backup" ]; then
    # Calcular a duração do backup
    START_TIME=0
    [ -f "$START_TIME_FILE" ] && START_TIME=$(cat "$START_TIME_FILE") 
    DURATION=$((NOW - START_TIME))
    DURATION_HUMAN=$(date -u -d "@$DURATION" +%H:%M:%S)
    rm -f "$START_TIME_FILE"

    # Envia o resultado do backup em si
    send_report "$KEY_PREFIX.status[$BACKUP_ID]" "Backup $OPERATION_RESULT: '$BACKUP_ID' finalizou às $NOW_HUMAN (Duração: $DURATION_HUMAN)"
fi
exit 0
