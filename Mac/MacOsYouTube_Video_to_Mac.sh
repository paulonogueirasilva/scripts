#!/usr/bin/env zsh
#
# 20261006 - macOSYouTube_Video_to_Mac.sh
#
# [1. Terminal Mac]  ---> Conectar.
#
# [2. Terminal Mac]  ---> Atualiza yt-dlp e move para Movies:
# pipx upgrade yt-dlp
# pipx upgrade-all
# cd /Users/paulonogueirasilva/Movies/
#
# [3. Script zsh]  ---> Baixa vídeos com yt-dlp para o diretório Movies:
# - MacOsYouTube_Video_to_Mac.sh
# - Informa URL
#
# Define o diretório de destino desejado
DIRETORIO_ALVO="/Users/paulonogueirasilva/Movies"
#
# Verifica se já está no diretório correto. Se não estiver, entra nele.
if [ "$PWD" != "$DIRETORIO_ALVO" ]; then
    echo "Movendo para o diretório correto: $DIRETORIO_ALVO"
    cd "$DIRETORIO_ALVO" || { echo "Erro ao acessar o diretório: $DIRETORIO_ALVO"; exit 1; }
else
    echo "Você já está no diretório correto: $DIRETORIO_ALVO"
fi
#
# Solicita a URL do vídeo do YouTube
read -r "URL_VIDEO?Cole a URL do vídeo do YouTube: "
#
print "\nAguardando o intervalo de segurança e iniciando o download do vídeo...\n"
#
# Executa o yt-dlp forçando a conversão compatível com QuickTime (H.264 + AAC)
# yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
#   --postprocessor-args "ffmpeg:-c:v libx264 -crf 20 -preset medium -c:a aac -b:a 192k" \
yt-dlp -f 'bv*+ba/b' \
  --cookies-from-browser chrome \
  --sleep-interval 15 --max-sleep-interval 21 \
  --embed-thumbnail \
  --embed-metadata \
  --embed-subs \
  --sub-langs "pt,en" \
  --merge-output-format mp4 \
  -o "%(uploader)s - %(title)s.%(ext)s" \
  "$URL_VIDEO"
#
# Validação do status do download
if [ $? -eq 0 ]; then
    print "\nDownload e conversão do vídeo concluídos com sucesso!"
    say "Sucesso!"
else
    print "\nOcorreu um erro durante o download ou pós-processamento."
    say "Erro! Erro! Erro!"
fi
