#!/usr/bin/env zsh

#
# MacOsYouTube_Video_to_Mac.sh
#
# [1. Terminal Mac]  ---> Conectar.
#
# [2. Terminal Mac]  ---> Atualiza yt-dlp e move para Downloads:
# pipx upgrade yt-dlp
# pipx upgrade-all
# cd /Users/paulonogueirasilva/Downloads/
#
# [3. Script zsh]  ---> Baixa vídeos com yt-dlp para a pasta Downloads:
# - MacOsYouTube_Video_to_Mac.sh
# - Informa URL
#
# Define a pasta de destino desejada
# DIRETORIO_ALVO="/Users/paulonogueirasilva/Downloads"
DIRETORIO_ALVO="/Users/paulonogueirasilva/Movies"

# Verifica se já está no diretório correto. Se não estiver, entra nele.
if [ "$PWD" != "$DIRETORIO_ALVO" ]; then
    echo "Movendo para o diretório correto: $DIRETORIO_ALVO"
    cd "$DIRETORIO_ALVO" || { echo "Erro ao acessar a pasta Downloads"; exit 1; }
else
    echo "Você já está na pasta correta: $DIRETORIO_ALVO"
fi

# Solicita a URL do vídeo do YouTube
read -r "URL_VIDEO?Cole a URL do vídeo do YouTube: "

print "\nAguardando o intervalo de segurança e iniciando o download do vídeo...\n"

# Executa o yt-dlp para baixar o VÍDEO COMPLETO (Vídeo + Áudio)
# Junta o melhor vídeo e melhor áudio preferencialmente em MP4/M4A
yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
  --cookies-from-browser chrome \
  --sleep-interval 15 --max-sleep-interval 21 \
  --embed-thumbnail \
  --embed-metadata \
  --embed-subs \
  --sub-langs "pt,en" \
  -o "%(uploader)s - %(title)s.%(ext)s" \
  "$URL_VIDEO"

# Validação do status do download
if [ $? -eq 0 ]; then
    print "\nDownload do vídeo concluído com sucesso!"
else
    print "\nOcorreu um erro durante o download do vídeo."
fi
