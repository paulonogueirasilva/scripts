#!/usr/bin/env zsh

#
# 20260825 - MacOsHomebrewUpdate.sh - Testado e funcional.
# Brew maintenance script
#

echo #
echo "PASTA DE CASKS ATUAIS"
echo ---------------------
echo "/opt/homebrew/Caskroom"

echo #
echo "ATUALIZANDO LISTAS (UPDATE)"
echo ---------------------------
brew update

echo #
echo "ATUALIZANDO PACOTES E CASKS (UPGRADE)"
echo -------------------------------------
# Forca a atualizacao de todos os casks (greedy)
# brew upgrade --cask --greedy
brew upgrade --greedy

echo #
echo "LIMPEZA (CLEANUP)"
echo -----------------
brew cleanup

# Bloco opcional (comentado)
# if [ -d "/usr/local/lib" ]; then
#   for f in /usr/local/lib/libASAF*.*; do
#     if [ -e "$f" ]; then
#       echo ----------------------------------------------
#       echo Delete libASAF files in /usr/local/lib/ folder
#       echo ----------------------------------------------
#       sudo rm -rf /usr/local/lib/libASAF*.*
#     fi
#   done
# fi

echo #
echo "CONFIGURACAO DO HOMEBREW"
echo ------------------------
brew config

echo #
echo "DIAGNOSTICO (DOCTOR)"
echo --------------------
brew doctor

echo #
echo "LISTA DE PACOTES INSTALADOS"
echo ---------------------------
brew list
echo #

# Verificar se o comando de upgrade falhou
if [ $? -eq 0 ]; then
  say "Sucesso!"
else
  say "Erro! Erro! Erro!"
fi
