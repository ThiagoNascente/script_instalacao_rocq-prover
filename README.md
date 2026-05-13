# Única máquina

- Clonar repositório

```bash
git clone https://github.com/ThiagoNascente/script_instalacao_rocq-prover.git
```

- Entrar na pasta

```bash
cd script_instalacao_rocq-prover
```

- Dar permissão ao arquivo de teste

```bash
sudo chmod +x maquina_unica.sh
```

- Executar script de instalação

```bash
./maquina_unica.sh
```

> Preferível instalar na pasta raiz [`cd`]

> Testado e funcional

# Multiplas maquinas (Openssh)

## Preparando o Terreno (Instalacao)

- No terminal de cada máquina, executar

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl enable --now ssh
```

## Autenticação sem Senha (SSH Keys)

- Na maquina que vai controlar as outras, gere uma chave:

```bash
ssh-keygen -t ed25519
```

- Prosseguir com `Enter` em tudo (cfg padrao)

- Dar permissao ao deploy

```bash
chmod +x deploy_file.sh
```

- Executar

```bash
./deploy_file.sh
```