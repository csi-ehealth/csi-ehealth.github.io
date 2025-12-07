# Code_Dashboard

## Local

### Iniciar o CMS
```
    make serve/cms
```
<<<<<<< Updated upstream
<<<<<<< Updated upstream
Acesse o CMS atraves da url http://127.0.0.1:8090/_/

### Iniciar servidor para prover js
Rode o comando na raiz do projeto
```
    python -m http.server 8000
```

Acesse http://localhost:8000/index.html
=======
=======
>>>>>>> Stashed changes


## Subindo para o servidor remoto

- Passar arquivos para servidor
´´´
### Transferir o executável do PocketBase
scp -i "cms/ehealth_ssh.pem" cms/pocketbase ec2-user@ec2-3-138-193-102.us-east-2.compute.amazonaws.com:~/

### Transferir os dados (migrations e pb_data)
scp -i "cms/ehealth_ssh.pem" -r cms/pb_migrations ec2-user@ec2-3-138-193-102.us-east-2.compute.amazonaws.com:~/

scp -i "cms/ehealth_ssh.pem" -r cms/pb_data ec2-user@ec2-3-138-193-102.us-east-2.compute.amazonaws.com:~/
<<<<<<< Updated upstream
´´´
>>>>>>> Stashed changes
=======
´´´
>>>>>>> Stashed changes
