#!/usr/bin/env zsh

#
# 20260825 - MacOsSystemAdm.sh - Testado e funcional.
#

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Auditoria Pro: MacBook Pro M2 - $(date +%d/%m/%Y) ===${NC}\n"

# [1/5] VERSÕES (JAVA/DESIGN)
echo -e "${YELLOW}[1/5] Versões e Atualizações${NC}"
if command -v java &>/dev/null; then
    # CORREÇÃO: URL protegida por aspas simples para o zsh não tentar fazer globbing
    LATEST_JAVA=$(curl -s 'https://api.adoptium.net/v3/info/release_names?release_type=ga&status=all' | grep -oE "jdk-[0-9]+" | head -1 | sed 's/jdk-//')
    echo "OpenJDK Local: $(java -version 2>&1 | head -n 1)"
    if [ -n "$LATEST_JAVA" ]; then
        echo "OpenJDK Remoto: JDK $LATEST_JAVA"
    else
        echo "OpenJDK Remoto: Não foi possível obter a versão atual."
    fi
fi

# [2/5] HOMEBREW
echo -e "\n${YELLOW}[2/5] Gestão de Pacotes (Homebrew)${NC}"
OUTDATED=$(brew outdated --quiet | wc -l | xargs)
[ "$OUTDATED" -gt 0 ] && echo -e "${RED}Existem $OUTDATED pacotes pendentes.${NC}" || echo -e "${GREEN}Tudo atualizado.${NC}"

# [3/5] DIRETÓRIOS E BACKUP
echo -e "\n${YELLOW}[3/5] Status dos Diretórios de Trabalho/Backup${NC}"
PATHS=("$HOME/Documents/Postman" "$HOME/Documents/GitHub")
for p in "${PATHS[@]}"; do
    [ -d "$p" ] && echo -e "${GREEN}[OK]${NC} $p ($(du -sh "$p" | awk '{print $1}'))" || echo -e "${RED}[ERRO]${NC} $p ausente."
done

# [4/5] STATUS DE REDE E ACESSO REMOTO
echo -e "\n${YELLOW}[4/5] Conectividade e Acesso Remoto${NC}"

# Tailscale
if command -v tailscale &>/dev/null; then
    TS_STATUS=$(tailscale status --peers=false 2>/dev/null)
    if [[ $TS_STATUS == *"tailscale is stopped"* ]] || [ -z "$TS_STATUS" ]; then
        echo -e "${RED}[OFFLINE]${NC} Tailscale está desconectado."
    else
        echo -e "${GREEN}[ONLINE]${NC} Tailscale ativo. IP: $(tailscale ip -4)"
    fi
else
    echo "Tailscale CLI não encontrado."
fi

# NoMachine (nxserver)
if [ -f "/usr/local/bin/nxserver" ]; then
    NX_STATUS=$(/usr/local/bin/nxserver --status | grep "is running" | wc -l)
    if [ "$NX_STATUS" -gt 0 ]; then
        echo -e "${GREEN}[RUNNING]${NC} NoMachine Server está ativo."
    else
        echo -e "${YELLOW}[STOPPED]${NC} NoMachine Server não está rodando."
    fi
fi

# [5/5] STATUS DE REPOSITÓRIOS GIT (DETALHADO)
echo -e "\n${YELLOW}[5/5] Status de Repositórios Git${NC}"
find "$HOME/Documents/GitHub" -maxdepth 2 -name ".git" -type d 2>/dev/null | while read -r repo; do
    REPO_PATH=$(dirname "$repo")
    REPO_NAME=$(basename "$REPO_PATH")
    
    # Captura as mudanças (arquivos modificados, deletados ou não rastreados)
    CHANGES=$(git -C "$REPO_PATH" status --porcelain)

    if [ -n "$CHANGES" ]; then
        echo -e "${RED}[PENDENTE]${NC} $REPO_NAME"
        # Lista os arquivos com uma pequena indentação e cor cinza
        echo "$CHANGES" | sed 's/^/  └─ /' | while read -r line; do
            echo -e "\033[0;90m$line\033[0m"
        done
    else
        echo -e "${GREEN}[LIMPO]${NC} $REPO_NAME"
    fi
done

echo -e "\n${BLUE}=== Verificação Concluída ===${NC}"
echo "----------------------------------------------"
df -h /
