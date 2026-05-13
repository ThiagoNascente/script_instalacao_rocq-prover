#!/bin/bash

# 1 - O terminal já estará aberto para a execução deste script.

# 3 - Solicita a senha do sudo de forma segura para não deixá-la exposta no código
echo "Digite a senha do sudo para a instalação:"
read -s SUDO_PASS
echo "Senha recebida. Iniciando o processo..."
echo "---------------------------------------------------"

# 2 e 3 - Executa sudo apt update aplicando a senha
echo "$SUDO_PASS" | sudo -S apt update

# 4 - Instala o build-essential (e ferramentas para baixar/extrair)
echo "$SUDO_PASS" | sudo -S apt install -y build-essential wget unzip

# 5 - Baixa o arquivo do link e extrai
URL="https://github.com/coq/platform/archive/refs/tags/2025.08.2.zip"
ARQUIVO_ZIP="2025.08.2.zip"
NOME_DIRETORIO="platform-2025.08.2" # Nome padrão da pasta após extração do GitHub

echo "Baixando a Coq Platform..."
wget -c "$URL" -O "$ARQUIVO_ZIP"

echo "Extraindo o arquivo..."
unzip -q -o "$ARQUIVO_ZIP"

# 6 - Entra no diretório pelo terminal
cd "$NOME_DIRETORIO" || { echo "Erro: Diretório $NOME_DIRETORIO não encontrado."; exit 1; }

# 7 - Executa ulimit -s 131072
ulimit -s 131072

# 8 - Executa export OPAMJOBS=1
export OPAMJOBS=1

# 9 a 13 - Executa a instalação passando as respostas automaticamente
# Utiliza a estrutura Here-Doc (<<EOF) para inserir as respostas: i, 1, s, 1
echo "Iniciando a instalação automática do Coq..."

echo "" | ./coq_platform_make.sh -extent=i -pick=package-pick-9.0~2025.08.sh -parallel=s -jobs=1

echo "---------------------------------------------------"
echo "Processo concluído!"