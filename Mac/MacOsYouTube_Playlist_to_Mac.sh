#!/usr/bin/env zsh

#
# 20260825 - MacOsYouTube_Playlist_to_Mac.sh - Testado e funcional.
#
echo -e "\nPROCEDIMENTO DE USO\n"
# [1. Terminal Mac]  ---> Conectar.
echo -e "\n[1. Terminal Mac]  ---> Conectar.\n"
#
# [2. Terminal Mac]  ---> Atualiza yt-dlp e move para navidrome:
echo -e "\n[2. Terminal Mac]  ---> Atualiza yt-dlp e move para navidrome.\n"
# pipx upgrade yt-dlp
# pipx upgrade-all
# cd "/Users/paulonogueirasilva/Music/Ubuntu/navidrome"
#
# [3. Script zsh]  ---> Baixa playlists com yt-dlp para o diretório navidrome do Mac:
echo -e "\n[3. Script zsh]  ---> MacOsYouTube_Playlist_to_Mac.\n"
# - MacOsYouTube_Playlist_to_Mac.sh
# - Informa URL
#
# [4. Kid3-qt Script zsh]  ---> Corrige o "NA", “Album” e "Date" no álbum/artista:
echo -e "\n[4. Kid3-qt] ---> Realizado manualmente.\n"
# - Criar script,
# - No momento é realizado manualmente (20260826).
#
# [5. Agrupar as músicas por artista do álbum]
echo -e "\n[5. Agrupar as músicas por artista do álbum] ---> Realizado manualmente.\n"
# Exemplo: diretório "Gilberto Gil" com o álbum "Gilberto Gil" e as músicas do álbum dentro do diretório do artista.
#
# - Criar script,
# - No momento é realizado manualmente (20260906).

# 2. TRAVA DE CONFIRMAÇÃO (Sintaxe Nativa Zsh)
if [ -t 0 ]; then
  echo -n "Deseja iniciar o MacOsYouTube_Playlist_to_Mac? [y/n]: "
  
  # Zsh: -k 1 (lê 1 caractere), -r (raw input)
  read -r -k 1 resposta
  echo "" # Quebra de linha visual necessária após a captura do caractere

  if [[ ! "$resposta" =~ ^[Yy]$ ]]; then
    echo "Baixa da lista de reprodução cancelada pelo usuário."
    exit 0
  fi
fi

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

# Executa o seu comando yt-dlp atualizado com suporte a SABR e fallback de metadados
# --extractor-args "youtube:player_client=android,web" \
yt-dlp \
  --cookies-from-browser chrome \
  --extractor-args "youtube:player_client=mweb,web" \
  -f "ba[ext=m4a]/ba/b" \
  --sleep-interval 15 \
  --max-sleep-interval 21 \
  --embed-thumbnail \
  --embed-metadata \
  --parse-metadata "%(playlist_uploader,uploader)s:%(album_artist)s" \
  --parse-metadata "playlist_title:%(album)s" \
  --parse-metadata "%(playlist_index)s:%(track_number)s" \
  --replace-in-metadata "album_artist" " - Topic" "" \
  --replace-in-metadata "playlist_uploader" " - Topic" "" \
  -o "%(album_artist)s - %(album)s/%(playlist_index)02d - %(title)s.%(ext)s" \
  "$URL_CORRIGIDA"

# Verificar se o comando yt-dlp falhou
if [ $? -eq 0 ]; then
  say "Sucesso!"
else
  say "Erro! Erro! Erro!"
fi

echo -e "\nTransfira para o Ubuntu navidrome com MacOsMac_to_Ubuntu_navidrome(.sh)...\n"
