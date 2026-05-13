#!/bin/bash

# Configurações do laboratório
HOSTS_FILE="hosts.txt"
USUARIO_SSH="aluno" 

# Verifica se o arquivo de hosts existe antes de continuar
if [[ ! -f "$HOSTS_FILE" ]]; then
    echo "Erro: O arquivo '$HOSTS_FILE' não foi encontrado!"
    exit 1
fi

# Solicita a senha do sudo uma única vez de forma segura
echo -n "Digite a senha do sudo das máquinas do laboratório: "
read -s SUDO_PASS
echo ""

echo "Iniciando deploy a partir de: $HOSTS_FILE"

# Loop para ler o arquivo linha por linha
while IFS= read -r IP || [[ -n "$IP" ]]; do
    # Ignora linhas que são apenas comentários (#) ou que estão vazias
    [[ "$IP" =~ ^#.*$ || -z "$IP" ]] && continue

    echo "==================================================="
    echo "Acessando máquina: $IP..."
    
    # Envia a variável de senha e injeta o script bash local na máquina remota
    # O parâmetro -o ConnectTimeout evita que o script trave em máquinas offline
    ssh -o ConnectTimeout=5 "$USUARIO_SSH@$IP" "SUDO_PASS='$SUDO_PASS' bash -s" < instalador_geral.sh
    
    if [ $? -eq 0 ]; then
        echo "=========Processo finalizado com sucesso em $IP ========="
    else
        echo "========= Falha ao processar $IP ========="
    fi

done < "$HOSTS_FILE"

echo "==================================================="
echo "Deploy em todo o laboratório concluído!"