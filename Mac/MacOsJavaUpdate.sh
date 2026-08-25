#!/usr/bin/env zsh

#
# 20260825 - MacOsJavaUpdate.sh - Testado e funcional.
#

# Versão atual instalada (extrai apenas o número principal)
INSTALLED_VER=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}' | cut -d'.' -f1)

# Consulta a última versão LTS disponível na API do Adoptium
LATEST_LTS=$(curl -s https://api.adoptium.net/v3/info/release_names?release_type=ga\&status=all | grep -oE "jdk-[0-9]+" | head -1 | sed 's/jdk-//')

echo "-----------------------------------"
echo "Versão instalada: $INSTALLED_VER"
echo "Última LTS disponível: $LATEST_LTS"

if [ "$INSTALLED_VER" -lt "$LATEST_LTS" ]; then
    echo "Sua versão está desatualizada! Acesse adoptium.net para baixar o novo .pkg."
else
    echo "Seu OpenJDK está atualizado."
fi
echo "-----------------------------------"

#Verificar se o comando anterior falhou
if [ $? -eq 0 ]; then
  say "Sucesso na execução"
  else
    say "Erro! Erro! Erro! Script mal sucedido!"
fi

