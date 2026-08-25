#!/usr/bin/env zsh

#
# 20260825 - MacOsMac_to_Ubuntu_navidrome.sh - Testado e funcional.
# Script para transferir músicas do macOS para o Navidrome no Ubuntu via Tailscale.
#

# ========================
# CONFIGURAÇÃO DE CAMINHOS
# ========================
ORIGEM="/Users/paulonogueirasilva/Music/Ubuntu/navidrome/"
DESTINO_USER="paulonogueirasilva"
DESTINO_HOST="macmini6-2" # Conectando via Tailscale
DESTINO_DIR="/home/paulonogueirasilva/Music/Music/"

FILTER_FILE="/Users/paulonogueirasilva/Documents/GitHub/Scripts/Mac/Filters/Terminal-Mac-Filters.txt"

echo "----------------------------------------------------------"
echo "Iniciando transferência para o Navidrome (Ubuntu via Tailscale)..."
echo "----------------------------------------------------------"

# Execução do rsync: usa --remove-source-files em vez de --delete
rsync -avzP \
  --remove-source-files \
  --filter="merge $FILTER_FILE" \
  "$ORIGEM" "${DESTINO_USER}@${DESTINO_HOST}:${DESTINO_DIR}"

STATUS_SYNC=$?

if [ $STATUS_SYNC -eq 0 ]; then
  echo "----------------------------------------------------------"
  echo "TRANSFERÊNCIA CONCLUÍDA! Removendo diretórios vazios na origem..."
  echo "----------------------------------------------------------"
  
  # Limpa metadados dos arquivos e diretórios remanescentes no macOS
  find "$ORIGEM" -name ".DS_Store" -type f -delete 2>/dev/null
  find "$ORIGEM" -mindepth 1 -type d -empty -delete

  echo "----------------------------------------------------------"
  echo "Forçando re-scan no Navidrome..."
  echo "----------------------------------------------------------"
  # Dispara o scanner no contêiner do Navidrome no Ubuntu
  ssh "${DESTINO_USER}@${DESTINO_HOST}" "docker exec navidrome /app/navidrome scan"
else
  echo "----------------------------------------------------------"
  echo "ERRO NA SINCRONIZAÇÃO: SyncMacToNavidrome.sh!"
  echo "----------------------------------------------------------"
fi
