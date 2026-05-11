#!/bin/bash
# Este script rodará DENTRO de cada máquina do laboratório.

# A variável SUDO_PASS será injetada pelo script mestre.
echo "---------------------------------------------------"
echo "Iniciando atualização e instalação de dependências..."

echo "$SUDO_PASS" | sudo -S apt update
echo "$SUDO_PASS" | sudo -S apt install -y build-essential wget unzip

URL="https://github.com/coq/platform/archive/refs/tags/2025.08.2.zip"
ARQUIVO_ZIP="2025.08.2.zip"
NOME_DIRETORIO="platform-2025.08.2"

echo "Baixando a Coq Platform..."
wget -c "$URL" -O "$ARQUIVO_ZIP"

echo "Extraindo o arquivo..."
unzip -q -o "$ARQUIVO_ZIP"

cd "$NOME_DIRETORIO" || exit 1

ulimit -s 131072
export OPAMJOBS=1

echo "Iniciando a instalação automática do Coq..."
./coq_platform_make.sh <<EOF
i
1
s
1
EOF

echo "Instalação concluída nesta máquina!"