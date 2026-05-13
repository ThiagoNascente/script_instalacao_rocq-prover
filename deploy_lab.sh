#!/bin/bash

# Configurações do laboratório
USUARIO_SSH="aluno" # Substitua pelo usuário padrão das máquinas do laboratório

# Coloque aqui os IPs ou Hostnames de todas as máquinas do seu lab
MAQUINAS=(
    "192.168.1.101"
    "192.168.1.102"
    "192.168.1.103"
    # Adicione quantos IPs precisar...
)

# Solicita a senha do sudo uma única vez de forma segura
echo -n "Digite a senha do sudo das máquinas do laboratório: "
read -s SUDO_PASS
echo ""

# Loop para acessar cada máquina via SSH e rodar o script
for IP in "${MAQUINAS[@]}"; do
    echo "==================================================="
    echo "Acessando máquina: $IP..."
    
    # Envia a variável de senha e injeta o script bash local na máquina remota
    ssh "$USUARIO_SSH@$IP" "SUDO_PASS='$SUDO_PASS' bash -s" < instalador_geral.sh
    
    echo "Processo finalizado em $IP."
done

echo "==================================================="
echo "Deploy em todo o laboratório concluído!"