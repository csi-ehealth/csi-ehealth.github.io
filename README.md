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


## Subindo para o servidor remoto

- Passar arquivos para servidor
´´´
### Transferir o executável do PocketBase
make cms/remote/setup

### Transferir os dados (migrations e pb_data)
make cms/remote/update-data

### Iniciar CMS no servidor
make cms/remote/start

### Conectar no servidor 
make cms/remote/connect


## Urls
### Remoto
- CMS: https://ehealth-uff.duckdns.org/_/
- Site: https://csi-ehealth.github.io/index.html

### Local
- CMS: http://localhost:8090/_/
- Site: http://localhost:8000/index.html