#!/usr/bin/env zsh

#
# 20260825 - MacOsActivityClean.sh - Testado e funcional.
#

echo "--- Iniciando Faxina de Desenvolvimento (macOS Tahoe) ---"

# Verifica se há scripts antigos rodando como root
ls -lah /usr/local/bin/MacOs*.* 2>/dev/null

# --- Seção 1: Desenvolvimento Apple ---
if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
    echo "[+] Removendo DerivedData (Xcode)..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/*
fi

echo "[+] Limpando caches dos simuladores ativos..."
xcrun simctl delete unavailable 2>/dev/null
xcrun simctl erase all 2>/dev/null

# --- Seção 2: JetBrains & IntelliJ (Gerenciado via Brew) ---
# Verifica se o IntelliJ está rodando antes de tentar fechar ou limpar
if pgrep -f "IntelliJ IDEA" > /dev/null; then
    echo "[+] IntelliJ IDEA detectado em execução. Fechando graciosamente..."
    osascript -e 'quit app "IntelliJ IDEA"' 2>/dev/null
    sleep 2 # Aguarda um momento para o encerramento seguro
fi

echo "[+] Iniciando limpeza segura da JetBrains..."
if [ -d ~/Library/Logs/JetBrains ]; then
    echo "    -> Removendo logs de IDEs..."
    rm -rf ~/Library/Logs/JetBrains/*
fi

# Limpa caches gerais da JetBrains que o Homebrew não remove sozinho
if [ -d ~/Library/Caches/JetBrains ]; then
    echo "    -> Refinando caches da JetBrains (preservando índices)..."
    # Remove tudo dentro de Caches/JetBrains, EXCETO as pastas 'index' e 'caches' de dentro das IDEs
    find ~/Library/Caches/JetBrains -type f -delete 2>/dev/null
fi

# --- Seção 3: Otimização do Homebrew ---
if command -v brew &> /dev/null; then
    echo "[+] Limpando downloads antigos e caches do Homebrew..."
    brew cleanup -s 2>/dev/null
    rm -rf "$(brew --cache)" 2>/dev/null
fi

# --- Seção 4: Otimização do Gradle (Preservando bibliotecas) ---
if [ -d "$HOME/.gradle" ]; then
    echo "[+] Refinando caches do Gradle..."
    find "$HOME/.gradle/caches" -type d -name "scripts" -exec rm -rf {} + 2>/dev/null
    find "$HOME/.gradle/caches" -type d -name "scripts-remapped" -exec rm -rf {} + 2>/dev/null
    find "$HOME/.gradle" -name "*.log" -type f -delete 2>/dev/null
fi

# --- Seção 5: Joplin & OnlyOffice ---
if [ -d ~/Library/Application\ Support/Joplin/cache ]; then
    echo "[+] Limpando miniaturas do Joplin..."
    # O (N) evita o erro "no matches found" se a pasta já estiver vazia
    rm -rf ~/Library/Application\ Support/Joplin/cache/*(N)
    rm -f ~/Library/Application\ Support/Joplin/log.txt
fi

if [ -d ~/Library/Application\ Support/asc.onlyoffice.DesktopEditors/data/cache ]; then
    echo "[+] Removendo caches do OnlyOffice..."
    rm -rf ~/Library/Application\ Support/asc.onlyoffice.DesktopEditors/data/cache/*(N)
fi

# --- Seção 6: Android & Emuladores ---
echo "[+] Limpando resíduos Android..."
if [ -d "$HOME/.android/avd" ]; then
    find "$HOME/.android/avd" -name "*.log" -type f -delete 2>/dev/null
    find "$HOME/.android/avd" -name "*.png" -type f -delete 2>/dev/null
fi

# --- Seção 7: Workspace & Java (Maven/Gradle Build) ---
WORKSPACE_DIR="$HOME/Documents/workspace"

if [ -d "$WORKSPACE_DIR" ]; then
    echo "[+] Limpando pastas de build Java no Workspace..."
    find "$WORKSPACE_DIR" -name "target" -type d -exec rm -rf {} + 2>/dev/null
    find "$WORKSPACE_DIR" -name "build" -type d -exec rm -rf {} + 2>/dev/null
    
    # Limpeza segura do banco H2 (mv.db) com mais de 7 dias
    find "$WORKSPACE_DIR" -name "*.mv.db" -type f -atime +7 -delete 2>/dev/null
    find "$WORKSPACE_DIR" -name "*.trace.db" -type f -delete 2>/dev/null
fi

STATUS_FAXINA=$?

echo "--- Faxina Concluída! ---"
echo "Dica: Para atualizar o IntelliJ e seus outros pacotes, use: brew upgrade"
echo "-------------------------"
df -h /

# Verifica se a última operação de limpeza foi bem-sucedida
if [ $STATUS_FAXINA -eq 0 ]; then
    say "Sucesso na execução"
else
    say "Erro! Erro! Erro! Script mal sucedido!"
fi
