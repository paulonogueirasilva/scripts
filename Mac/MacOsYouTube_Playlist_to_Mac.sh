#!/usr/bin/env zsh

#
# MacOsYouTube_Playlist_to_Mac.sh
#
# [1. Terminal Mac]  ---> Conectar.
#
# [2. Terminal Mac]  ---> Atualiza yt-dlp e move para Downloads:
# pipx upgrade yt-dlp
# pipx upgrade-all
# cd /Users/paulonogueirasilva/Downloads/
#
# [3. Script zsh]  ---> Baixa playlists com yt-dlp para a pasta Downloads:
# - MacOsYouTube_Playlist_to_Mac.sh
# - Informa URL
#
# [4. Kid3-qt Script zsh]  ---> Corrige o "NA" e “Album” no álbum/artista:
# - Criar script.
#
# [5. Navidrome]  ---> Clica em "Quick Scan" no painel (ou aguarda o Auto-Scan):
# - http://macmini6-2:4533/
#
# [6. Sincronização]  ---> Executa Substreamer no celular.
#

# Define a pasta de destino desejada
# DIRETORIO_ALVO="/Users/paulonogueirasilva/Downloads"
DIRETORIO_ALVO="/Users/paulonogueirasilva/Music/Ubuntu/navidrome"

# Verifica se já está no diretório correto. Se não estiver, entra nele.
if [ "$PWD" != "$DIRETORIO_ALVO" ]; then
    echo "Movendo para o diretório correto: $DIRETORIO_ALVO"
    cd "$DIRETORIO_ALVO" || { echo "Erro ao acessar a pasta Ubuntu/navidrome"; exit 1; }
else
    echo "Você já está na pasta correta: $DIRETORIO_ALVO"
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
--sleep-interval 15 \
--max-sleep-interval 21 \
--embed-thumbnail --embed-metadata \
--parse-metadata "playlist_uploader:%(album_artist)s" \
--parse-metadata "playlist_title:%(album)s" \
--parse-metadata "%(playlist_index)s:%(track_number)s" \
--replace-in-metadata "playlist_uploader" " - Topic" "" \
-o "%(album_artist)s - %(album)s/%(playlist_index)02d - %(title)s.%(ext)s" \
"$URL_CORRIGIDA"
