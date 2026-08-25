#!/usr/bin/env zsh

#
# 20260825 - MacOsUpdate.sh - Testado e funcional.
# Apple Maintenance
#
echo #
echo Mac Os Update
echo #
sudo softwareupdate --list
echo #
#Verificar se o comando anterior falhou
if [ $? -eq 0 ]; then
  say "Sucesso na execução"
  else
    say "Erro! Erro! Erro! Script mal sucedido!"
fi

