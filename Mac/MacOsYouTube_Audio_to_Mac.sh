#!/usr/bin/env zsh

#
# MacOsYouTube_Audio_to_Mac.sh
#
# [1. Terminal Mac]  ---> Conectar.
#
# [2. Terminal Mac]  ---> Atualiza yt-dlp e move para Downloads:
# pipx upgrade yt-dlp
# pipx upgrade-all
# cd /Users/paulonogueirasilva/Downloads/
#
# [3. Script zsh]  ---> Baixa músicas com yt-dlp para a pasta Downloads:
# - MacOsYouTube_Audio_to_Mac.sh
# - Informa URL
#
# Define a pasta de destino desejada
# DIRETORIO_ALVO="/Users/paulonogueirasilva/Downloads"
DIRETORIO_ALVO="/Users/paulonogueirasilva/Music"

# Verifica se já está no diretório correto. Se não estiver, entra nele.
if [ "$PWD" != "$DIRETORIO_ALVO" ]; then
    echo "Movendo para o diretório correto: $DIRETORIO_ALVO"
    cd "$DIRETORIO_ALVO" || { echo "Erro ao acessar a pasta!"; exit 1; }
else
    echo "Você já está na pasta correta: $DIRETORIO_ALVO"
fi

# Solicita a URL do vídeo do YouTube (usando read/print nativos do Zsh)
read -r "URL_VIDEO?Cole a URL do vídeo do YouTube: "

print "\nAguardando o intervalo de segurança e iniciando o download...\n"

# Executa o yt-dlp usando os cookies do navegador para evitar o bloqueio (HTTP 429/bot)
# Altere 'chrome' para 'safari', 'firefox' ou 'brave' se utilizar outro navegador.
yt-dlp -f 'ba[ext=m4a]/ba' \
  --cookies-from-browser chrome \
  --sleep-interval 15 --max-sleep-interval 21 \
  --extract-audio \
  --audio-format m4a \
  --embed-thumbnail \
  --embed-metadata \
  -o "%(uploader)s - %(title)s.%(ext)s" \
  "$URL_VIDEO"

# O '$?' verifica se o yt-dlp terminou com sucesso (código 0) antes de exibir a mensagem
if [ $? -eq 0 ]; then
    print "\nDownload do áudio concluído com sucesso!"
else
    print "\nOcorreu um erro durante o download do áudio."
fi
