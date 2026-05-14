#!/bin/bash

# Configurações do laboratório
HOSTS_FILE="hosts.txt"
USUARIO_SSH="aluno" 

# Verifica se o arquivo de hosts existe antes de continuar
if [[ ! -f "$HOSTS_FILE" ]]; then
    echo "Erro: O arquivo '$HOSTS_FILE' não foi encontrado!"
    exit 1
fi

# Solicita a senha do SSH uma única vez
echo -n "Digite a senha do usuário SSH ($USUARIO_SSH): "
read -s SSH_PASS
echo ""

# Solicita a senha do sudo uma única vez de forma segura
echo -n "Digite a senha do sudo das máquinas do laboratório: "
read -s SUDO_PASS
echo ""

# Exporta a variável SSHPASS. A flag '-e' do sshpass vai ler essa variável automaticamente.
export SSHPASS="$SSH_PASS"

echo "Iniciando deploy a partir de: $HOSTS_FILE"
# Limpa ou cria o arquivo de resumo
> resumo_deploy.log 

# Loop para ler o arquivo linha por linha
while IFS= read -r IP || [[ -n "$IP" ]]; do
    [[ "$IP" =~ ^#.*$ || -z "$IP" ]] && continue

    echo "Disparando instalação na máquina: $IP..."
    
    # Agrupamos a execução e a validação em um subshell "( ... )" 
    # e colocamos o "&" no final para rodar em segundo plano
    (
        # Executa o sshpass e joga toda a saída (logs e erros) para um arquivo de texto específico do IP
        sshpass -e ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USUARIO_SSH@$IP" "SUDO_PASS='$SUDO_PASS' bash -s" < instalador_geral.sh > "log_${IP}.txt" 2>&1
        
        # Verifica se o comando anterior (o ssh) deu certo
        if [ $? -eq 0 ]; then
            echo "Sucesso: $IP" >> resumo_deploy.log
        else
            echo "Falha: $IP (Verifique log_${IP}.txt)" >> resumo_deploy.log
        fi
    ) & 

done < "$HOSTS_FILE"

echo "==================================================="
echo "Comandos enviados para todas as máquinas!"
echo "Aguardando a conclusão das instalações em background..."

# O comando 'wait' faz o script pausar aqui e esperar todos os processos com '&' terminarem
wait 

# Limpa a variável de ambiente por segurança no final do script
unset SSHPASS

echo "==================================================="
echo "Deploy em todo o laboratório concluído!"
echo "Resumo das instalações:"
cat resumo_deploy.log