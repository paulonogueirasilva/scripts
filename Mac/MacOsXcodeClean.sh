#!/usr/bin/env zsh

#
# 20260825 - MacOsXcodeClean.sh - Testado e funcional.
#

# Interrompe o script imediatamente se qualquer comando falhar
set -e

echo "--- Iniciando limpeza profunda do Xcode ---"

# 1. Remove Derived Data (Caches de compilação)
echo "Passo 1: Removendo Derived Data..."
rm -rf ~/Library/Developer/Xcode/DerivedData

# 2. Remove Arquivos de Suporte a Dispositivos (iOS, watchOS, tvOS antigos)
echo "Passo 2: Removendo suporte a dispositivos antigos..."
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/tvOS\ DeviceSupport

# 3. Remove Simuladores antigos ou indisponíveis
echo "Passo 3: Eliminando simuladores indisponíveis..."
xcrun simctl delete unavailable

# 4. Limpa Caches do CoreSimulator (Logs e arquivos temporários)
echo "Passo 4: Limpando caches do CoreSimulator..."
rm -rf ~/Library/Developer/CoreSimulator/Caches

# 5. Limpa arquivos de Archive (OPCIONAL)
# ATENÇÃO: Descomente as duas linhas abaixo APENAS se não precisar de versões antigas para publicar/debuccar
# echo "Passo 5: Limpando arquivos de Archive..."
rm -rf ~/Library/Developer/Xcode/Archives

# Desativa o 'set -e' para a checagem final correr normalmente
set +e

echo "--- Limpeza concluída! ---"
say "Sucesso na execução"

