#!/bin/bash

# Cores para facilitar a leitura
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}===> Iniciando deploy do PocketBase...${NC}"

# Caminhos
SERVICE_FILE="/etc/systemd/system/pocketbase.service"
TEMP_FILE="/home/seta/pocketbase.service"

# Verifica se o arquivo foi enviado para a home
if [ ! -f "$TEMP_FILE" ]; then
    echo "Erro: Arquivo $TEMP_FILE não encontrado. O scp falhou?"
    exit 1
fi

echo "Movendo arquivo para $SERVICE_FILE..."
mv "$TEMP_FILE" "$SERVICE_FILE"

echo "Ajustando permissões..."
chown root:root "$SERVICE_FILE"
chmod 644 "$SERVICE_FILE"

echo "Recarregando systemd e reiniciando serviço..."
systemctl daemon-reload
systemctl enable pocketbase
systemctl restart pocketbase

echo -e "${GREEN}===> PocketBase atualizado e rodando!${NC}"
systemctl status pocketbase --no-pager