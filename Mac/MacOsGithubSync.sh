#!/usr/bin/env zsh

#
# 20260825 - MacOsGithubSync.sh - Testado e funcional.
#

# Caminho da sua pasta de projetos
BASE_DIR="$HOME/Documents/GitHub"

echo "--- Iniciando Sincronização Git ---"
echo "Data: $(date)"
echo "-----------------------------------"

# Entra na pasta base
cd "$BASE_DIR" || exit

# Percorre todas as subpastas que possuem um repositório Git
for repo in */; do
    if [ -d "$repo/.git" ]; then
        echo "📦 Processando: ${repo%/}"
        cd "$repo"

        # Adiciona todas as mudanças
        git add .

        # Verifica se há algo para commitar (evita commits vazios)
        if ! git diff-index --quiet HEAD --; then
            echo "📝 Criando commit automático..."
            git commit -m "Sincronização automática: $(date +'%d/%m/%Y %H:%M')"

            echo "🚀 Enviando para o GitHub..."
            git push origin main
        else
            echo "✅ Tudo atualizado. Nada para enviar."
        fi

        echo "-----------------------------------"
        cd ..
    fi
done

echo "Sincronização concluída!"

#Verificar se o comando anterior falhou
if [ $? -eq 0 ]; then
  say "Sucesso na execução"
  else
    say "Erro! Erro! Erro! Script mal sucedido!"
fi

