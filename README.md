# Code_Dashboard

## Local

### Iniciar o CMS
```
    make serve/cms
```

Acesse o CMS atraves da url http://127.0.0.1:8090/_/

### Iniciar servidor para prover js
Rode o comando na raiz do projeto
```
    python -m http.server 8000
```

Acesse http://localhost:8000/index.html


# Subindo para o servidor remoto na uff

Passo a passo:
1. Explicar o que é cada ferramenta utilizada aqui
2. Configurar ssh para utilizar jumpbox automaticamente
3. Configurar chave ssh para remover necessidade de senha
4. Passar arquivos do CMS para servidor na uff 
5. Configurar CMS para rodar dentro da rede da uff
6. Configurar Tunnel para acesso individual fora da rede da uff
7. Configurar CMS de forma resiliente 
8. Configurar Acesso geral de fora da rede da uff 

## 1. Explicar o que é cada ferramenta utilizada aqui
- Jumpbox: Servico intermediario utilizado para acessa uma rede interna
- ssh: ferramenta para acessar remotamente computadores
- Pocketbase: cms feito em go, utiliza o banco em arquivo SQLite
- SQLlite: banco em arquivos que não precisamos subir infra estrutura
- scp: lib utilizada para trafegar de forma segura dados entre computadores
- tunnel: explicar o que é tunnet
- systemd: explicar o que é e cm funciona 
- nginx: gateway de entrada 

## 2. Configurar ssh para utilizar jumpbox automaticamente
Criar arquivo ~/.ssh/config:

Host uff-jumpbox
    HostName 200.156.91.194
    Port 2288
    User tiagoespanha

Host uff
    HostName 192.168.1.67
    User seta
    ProxyJump uff-jumpbox

## 3. Configurar chave ssh para remover necessidade de senha
ssh-copy-id -i ~/.ssh/tiagoespanhauff.pub sossego
colocar senha
agora pode logar diretamente via ssh sossego

repetir o processo para acesso final
ssh-copy-id -i ~/.ssh/tiagoespanhauff.pub seta-uff

## 4.  Passar arquivos do CMS para servidor na uff 

- no servidor, criar pasta
mkdir ~/ehealth
cd ehealth
mkdir ~/cms

- Localmente
Rodar comando para migrar arquivos do pocketbase (importante checar se está no mesmo tipo de arquitetura rodando o comando  uname -m)
make cms/remote/uff/setup

roda comando para passar dados
make cms/remote/uff/update-all
explicar o que esse comando esta fazendo e o que o pocketbase é 

## 5. Configurar CMS para rodar dentro da rede da uff
Agora que já temos os arquivos, precisamos colocar para rodar 

make cms/remote/uff/start localmente ou
~/ehealth/cms/pocketbase serve --http='0.0.0.0:8090' dentro do servidor

Com isso, já deve ser possível acessar o sistema dentro da rede da uff. 
Dentro do servidor jumpbox (sossego) ou dentro do proprio servidor da uff, rode o comando:
curl http://192.168.1.67:8090/api/collections/members/records
deve retornar uma lista de membros

## 6. Tunnel 

Explicar o que é um tunnel
explicar que 192.168.1.67 é o endereco interno
ssh -L 8090:192.168.1.67:8090 uff-jumpbox
Esse comando também existe no makefile como make cms/remote/uff/tunnel

## 7. Configurar CMS de forma resciliente 
Porém, as configuracoes que fizemos nao sao rescilientes. 
se por algum motivo o servidor reiniciar, o nosso serviço irá parar de funcionar, o que fara o frontend ficar sem dados para mostrar. 
Então vamos precisar garantir que, se o servidor está de pé, o serviço está de pé. 
Vamos utilizar o systemd para isso
Nos arquivos do projeto temos a pasta systemd, e nele temos o arquivo de configuração. 
Para subir esse arquivos, vamos manualmente criar o arquivo no pc remoto

ssh uff
sudo touch /etc/systemd/system/pocketbase.service

Agora, no pc local, basta rodar o comando para configurar o serviço
make cms/remote/uff/systemd/update

## 8. Configurar Acesso geral de fora da rede da uff 



## Urls
### Remoto
- CMS: https://ehealth-uff.duckdns.org/_/
- Site: https://csi-ehealth.github.io/index.html

### Local
- CMS: http://localhost:8090/_/
- Site: http://localhost:8000/index.html