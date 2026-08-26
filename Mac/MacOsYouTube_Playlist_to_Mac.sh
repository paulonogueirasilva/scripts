#!/usr/bin/env zsh

#
# 20260825 - MacOsYouTube_Playlist_to_Mac.sh - Testado e funcional.
#
# [1. Terminal Mac]  ---> Conectar.
#
# [2. Terminal Mac]  ---> Atualiza yt-dlp e move para navidrome:
# pipx upgrade yt-dlp
# pipx upgrade-all
# cd "/Users/paulonogueirasilva/Music/Ubuntu/navidrome"
#
# [3. Script zsh]  ---> Baixa playlists com yt-dlp para o diretório navidrome do Mac:
# - MacOsYouTube_Playlist_to_Mac.sh
# - Informa URL
#
# [4. Kid3-qt Script zsh]  ---> Corrige o "NA" e “Album” no álbum/artista:
# - Criar script,
# - No momento é realizado manualmente (20260826).
#
# [5. Navidrome]  ---> Clica em "Quick Scan" no painel (ou aguarda o Auto-Scan):
# - http://macmini6-2:4533/
#
# [6. Sincronização]  ---> Executa Substreamer no celular:
# - Ativa VPN Tailscale,
# - Abre Substreamer e sincroniza com o Navidrome do Ubuntu.
#

# Define o diretório de destino desejado
# DIRETORIO_ALVO="/Users/paulonogueirasilva/Downloads"
DIRETORIO_ALVO="/Users/paulonogueirasilva/Music/Ubuntu/navidrome"

# Verifica se já está no diretório correto. Se não estiver, entra nele.
if [ "$PWD" != "$DIRETORIO_ALVO" ]; then
    echo "Movendo para o diretório correto: $DIRETORIO_ALVO"
    cd "$DIRETORIO_ALVO" || { echo "Erro ao acessar o diretório Ubuntu/navidrome: $DIRETORIO_ALVO"; exit 1; }
else
    echo "Você já está no diretório correto: $DIRETORIO_ALVO"
fi

# Solicita a URL do YouTube Music
# echo -n "Cole a URL do YouTube Music: "
# read -r URL_ORIGINAL
read -r "URL_ORIGINAL?Cole a URL do YouTube Music: "

# Substitui 'music.youtube' por 'www.youtube'
URL_CORRIGIDA=$(echo "$URL_ORIGINAL" | sed 's/music.youtube/www.youtube/g')

echo -e "\nIniciando o download com a URL corrigida:\n$URL_CORRIGIDA\n"

# Executa o seu comando yt-dlp com a nova URL
yt-dlp -f 'ba[ext=m4a]' \
--cookies-from-browser chrome \
--sleep-interval 15 \
--max-sleep-interval 21 \
--embed-thumbnail --embed-metadata \
--parse-metadata "playlist_uploader:%(album_artist)s" \
--parse-metadata "playlist_title:%(album)s" \
--parse-metadata "%(playlist_index)s:%(track_number)s" \
--replace-in-metadata "playlist_uploader" " - Topic" "" \
-o "%(album_artist)s - %(album)s/%(playlist_index)02d - %(title)s.%(ext)s" \
"$URL_CORRIGIDA"
