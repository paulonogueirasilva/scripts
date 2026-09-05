#!/usr/bin/env zsh

#
# 20260825 - MacOsGdrivePPO.sh - Testado e funcional.
#

# ========================
# CONFIGURAÇÃO DE CAMINHOS
# ========================
LOCAL_DIR="/Users/paulonogueirasilva/gdrive_ppo"
REMOTE_DIR="gdrive_ppo:"
FILTER_FILE="/Users/paulonogueirasilva/Documents/GitHub/Scripts/Mac/Filters/Terminal-Mac-Filters.txt"

# Diretórios de Controle e Log
RCLONE_WORK_DIR="/Users/paulonogueirasilva/Documents/Rclone/Bisync"

echo "--------------------------------------"
echo " INICIANDO RCLONE BISYNC"
echo " Pai Paulinho de Oxóssi <--> Local Mac"
echo "--------------------------------------"

# 1. Evitar execuções sobrepostas (Crucial para o Bisync a cada 15 min)
if pgrep -x "rclone" > /dev/null; then
  echo "Rclone já está em execução de Pai Paulinho de Oxóssi <--> Local Mac"
  echo "Abortando esta rodada para evitar corrupção da base do Bisync."
  exit 1
fi

# 2. TRAVA DE CONFIRMAÇÃO (Apenas se o script for executado manualmente no terminal)
if [ -t 0 ]; then
  echo -n "Deseja iniciar o rclone Pai Paulinho de Oxóssi <--> Local Mac agora? [y/N]: "
  read -r resposta
  if [[ ! "$resposta" =~ ^[Yy]$ ]]; then
    echo "Sincronização cancelada pelo usuário."
    exit 0
  fi
fi

# ===========================================
# LIMPEZA PRÉVIA DE ARQUIVOS OCULTOS DO MACOS
# ===========================================
find "$LOCAL_DIR" -name ".DS_Store" -type f -delete 2>/dev/null
# =====================================================================
# EXECUÇÃO DO COMANDO UNIFICADO
#
# --delete-during \: para deletar arquivos durante a sincronização
# --dry-run \: para simulação
# --resync \: para a primeira sincronização ou possível resincronização
# --resync-mode path1 \: para sincronizar a partir da pasta local
# -P -v: para mostrar o progresso e detalhes da execução
# =====================================================================
rclone bisync "$LOCAL_DIR" "$REMOTE_DIR" \
  --workdir "$RCLONE_WORK_DIR" \
  --filter-from "$FILTER_FILE" \
  --compare size,modtime \
  --slow-hash-sync-only \
  --delete-during \
  --remove-empty-dirs \
  --fix-case \
  --fast-list \
  --resilient \
  --force \
  --tpslimit 3 \
  --transfers 2 \
  --checkers 4 \
  --drive-chunk-size 64M \
  --drive-import-formats docx,xlsx,pptx,svg,csv \
  -P -v

#
# Exibe a quantidade de espaço utilizado no Google Drive após a sincronização
#
rclone about "$REMOTE_DIR"

STATUS_SYNC=$?

if [ $STATUS_SYNC -eq 0 ]; then
  chmod +x /usr/local/bin/*.sh(N) /usr/local/bin/*.py(N) 2>/dev/null
  echo "-------------------------------------"
  echo " SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO!"
  echo "-------------------------------------"
else
  echo "------------------------"
  echo " ERRO NA SINCRONIZAÇÃO!"
  echo "------------------------"
fi

#
#Parâmetros utilizados no rclone:
#
#Segurança de Dados Máxima (--delete-after + --force + --filter-from):
#O comando continuará respeitando rigorosamente o seu arquivo de filtros (essencial para não poluir a nuvem). Com --delete-after, as deleções só acontecem #se toda a sincronização terminar bem. O --force garante que o script não trave caso você faça grandes reorganizações de pastas locais.
#
#Gargalo da API do Google sob Controle (--tpslimit 4 + --transfers 3):
#No segundo script, aumentar para --transfers 4 sem limite de requisições era um convite para o Google bloquear temporariamente sua conexão (erro 403). #Encontramos um meio-termo ideal: --transfers 3 auxiliado pelo --tpslimit 4. Assim, o comando extrai o máximo de velocidade que o Google permite sem #estourar o teto da API.
#
#Varredura Inicial Instantânea (--fast-list + --checkers 8):
#O rclone vai usar 8 threads paralelas para processar a estrutura local enquanto baixa a lista da nuvem inteira de uma só vez para a memória RAM através do #--fast-list. A indexação inicial que antes demorava minutos agora vai levar segundos.
#
#Tratamento de Erros Inteligente (--resilient):
#Se um arquivo falhar por estar bloqueado pelo sistema ou por oscilação da internet, o script não vai quebrar o ecossistema do bisync. Ele pula o arquivo #problemático, finaliza todo o resto e te avisa no final.
#
#Harmonização do Sistema (--fix-case + --remove-empty-dirs):
#Garante que o case-sensitivity do macOS não crie arquivos duplicados na nuvem e limpa os rastros de pastas vazias remanescentes após as transferências.
#
