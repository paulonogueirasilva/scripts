#!/usr/bin/env zsh

#
# 20260825 - MacOsRsyncSh.sh - Testado e funcional.
#

# Origem: Caminho absoluto da pasta do seu repositório local
ORIGEM="$HOME/Documents/GitHub/Scripts/Mac/"

# Destino: Pasta local do sistema macOS
DESTINO="/usr/local/bin/"

echo "Sincronizando os scripts da pasta local para $DESTINO..."

# rsync com múltiplas fontes: sincroniza a raiz de ORIGEM e a raiz de Rclone/ diretamente no DESTINO
# Nota: A inclusão explícita das duas fontes com barra '/' ao final força o achatamento (flatten) no destino.
sudo rsync -av --include="*.sh" --exclude="*/" --exclude="*" "$ORIGEM" "${ORIGEM}Rclone/" "$DESTINO"

STATUS_SYNC=$?

if [ $STATUS_SYNC -eq 0 ]; then
  # O (N) garante que se não houver arquivos, o chmod não quebra o script
  sudo chmod 777 /usr/local/bin/*.sh(N)
  echo "----------------------------------------------------------"
  echo " SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO: MacOsRsyncSh.sh!"
  echo "----------------------------------------------------------"
else
  echo "--------------------------------------------"
  echo " ERRO NA SINCRONIZAÇÃO: MacOsRsyncSh.sh!"
  echo "--------------------------------------------"
fi
