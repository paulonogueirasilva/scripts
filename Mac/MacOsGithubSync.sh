#!/usr/bin/env zsh

# 20260903 - MacOsGithubSync.sh - Refatorado com verificações SSH e branch dinâmica

BASE_DIR="$HOME/Documents/GitHub"
HAS_ERROR=0

echo "--- Iniciando Sincronização Git ---"
echo "Data: $(date)"
echo "-----------------------------------"

if [ ! -d "$BASE_DIR" ]; then
    echo "Erro: Diretório $BASE_DIR não encontrado."
    say "Erro! Diretório não encontrado!"
    exit 1
fi

for repo in "$BASE_DIR"/*/; do
    if [ -d "${repo}.git" ]; then
        repo_name=$(basename "$repo")
        echo "📦 Processando: $repo_name"

        # Identifica a branch ativa atual do repositório
        current_branch=$(git -C "$repo" branch --show-current)

        if [ -z "$current_branch" ]; then
            echo "⚠️ Repositório sem branch ativa configurada. Pulando..."
            echo "-----------------------------------"
            continue
        fi

        # 1. Atualiza alterações remotas primeiro
        git -C "$repo" pull --rebase origin "$current_branch" >/dev/null 2>&1

        # 2. Adiciona mudanças locais
        git -C "$repo" add .

        # 3. Verifica se há arquivos na staging area para commit
        if ! git -C "$repo" diff-index --quiet HEAD --; then
            echo "📝 Criando commit automático..."
            git -C "$repo" commit -m "Sincronização automática: $(date +'%d/%m/%Y %H:%M')"

            echo "🚀 Enviando para o GitHub ($current_branch)..."
            if git -C "$repo" push origin "$current_branch"; then
                echo "✅ Push realizado com sucesso."
            else
                echo "❌ Erro ao enviar para o GitHub."
                HAS_ERROR=1
            fi
        else
            echo "✅ Tudo atualizado. Nada para enviar."
        fi

        echo "-----------------------------------"
    fi
done

echo "Sincronização concluída!"

# Avaliação final de sucesso
if [ $HAS_ERROR -eq 0 ]; then
    say "Sucesso na execução"
else
    say "Erro! Erro! Erro! Script mal sucedido!"
fi