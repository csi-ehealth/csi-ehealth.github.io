.PHONY: serve/cms

front/serve:
	python -m http.server 8000

cms/local/start:
	./cms/pocketbase serve

cms/remote/connect:
	cd ./cms && ssh -i "ehealth-server.pem" ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com

cms/remote/setup:
	scp -i "cms/ehealth-server.pem" cms/pocketbase ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/

cms/remote/update-data:
	scp -i "cms/ehealth-server.pem" -r cms/pb_migrations ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/
	scp -i "cms/ehealth-server.pem" -r cms/pb_data ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/

cms/remote/update-hooks:
	scp -i "cms/ehealth-server.pem" -r cms/pb_hooks ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/

cms/remote/start:
	cd ./cms && ssh -i "ehealth-server.pem" ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com "./pocketbase serve --http='127.0.0.1:8090' --hooks"

ec2/update/systemmd/pocketbase:
	scp -i "cms/ehealth-server.pem" cms/configs/systemd/pocketbase.service ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/
	ssh -i "cms/ehealth-server.pem" ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com "sudo mv ~/pocketbase.service /etc/systemd/system/pocketbase.service && sudo systemctl daemon-reload && sudo systemctl restart pocketbase"

ec2/update/nginx/sites-enabled/default:
	scp -i "cms/ehealth-server.pem" cms/configs/nginx/sites-enabled/default ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/
	ssh -i "cms/ehealth-server.pem" ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com "sudo mv ~/default /etc/nginx/sites-enabled/default && sudo systemctl reload nginx"


# Variáveis para facilitar a manutenção
UFF_HOST = uff
CMS_DIR = ./cms
SYSTEMD_DIR = ./cms/configs/systemd
PROJECT_REMOTE_SETA_HOME=/home/seta
PROJECT_REMOTE_PATH = ~/ehealth
PROJECT_REMOTE_CMS_PATH = $(PROJECT_REMOTE_PATH)/cms
PROJECT_REMOTE_SYSTEMD_CONFIG_PATH = /etc/systemd/system/pocketbase.service


.PHONY: cms/remote/uff/connect cms/remote/uff/setup cms/remote/uff/update-data cms/remote/uff/start

# Conectar direto (o SSH faz o pulo sozinho, pois configuramos o .ssh/config. Ver mais informações no README)
cms/remote/uff/connect:
	ssh $(UFF_HOST)

# Transferir o executável do PocketBase
cms/remote/uff/setup:
	scp $(CMS_DIR)/pocketbase $(UFF_HOST):$(PROJECT_REMOTE_CMS_PATH)/

# Transferir os dados, migrações e hooks
cms/remote/uff/update-all:
	scp -r $(CMS_DIR)/pb_migrations $(UFF_HOST):$(PROJECT_REMOTE_CMS_PATH)/
	scp -r $(CMS_DIR)/pb_data $(UFF_HOST):$(PROJECT_REMOTE_CMS_PATH)/
	scp -r $(CMS_DIR)/pb_hooks $(UFF_HOST):$(PROJECT_REMOTE_CMS_PATH)/

# Iniciar o PocketBase remotamente de forma não resiliente
cms/remote/uff/start:
	ssh $(UFF_HOST) "$(PROJECT_REMOTE_CMS_PATH)/pocketbase serve --http='0.0.0.0:8090'"

# Configurar o PocketBase como um serviço do systemd
cms/remote/uff/systemd/update:
	@echo "Enviando arquivos de configuração..."
	@scp ./cms/configs/systemd/pocketbase.service $(UFF_HOST):~/
	@scp $(SYSTEMD_DIR)/deploy-pocketbase-systemd.sh $(UFF_HOST):~/
	@echo "Executando script de instalação..."
	ssh -t $(UFF_HOST) "sudo bash ~/deploy-pocketbase-systemd.sh"
	
cms/remote/uff/systemd/status:
	ssh $(UFF_HOST) "sudo systemctl status pocketbase"

cms/remote/uff/systemd/start:
	ssh $(UFF_HOST) "sudo systemctl start pocketbase"

cms/remote/uff/systemd/logs:
	ssh $(UFF_HOST) "sudo journalctl -u pocketbase -f"

cms/remote/uff/tunnel:
	ssh -L 8090:192.168.1.67:8090 uff-jumpbox