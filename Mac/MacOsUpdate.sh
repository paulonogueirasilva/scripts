#!/usr/bin/env zsh
#
# 20261006 - macOSUpdate.sh
# Apple Maintenance
#
echo #
echo Mac Os Update
echo #
sudo softwareupdate --list
echo #
#Verificar se o comando anterior falhou
if [ $? -eq 0 ]; then
  say "Sucesso!"
  else
    say "Erro! Erro! Erro!"
fi
