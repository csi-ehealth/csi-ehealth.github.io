.PHONY: serve/cms

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
    scp -i "cms/ehealth-server.pem" configs/systemd/pocketbase.service ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/
    ssh -i "cms/ehealth-server.pem" ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com "sudo mv ~/pocketbase.service /etc/systemd/system/pocketbase.service && sudo systemctl daemon-reload && sudo systemctl restart pocketbase"

ec2/update/nginx/sites-enabled/default:
    scp -i "cms/ehealth-server.pem" configs/nginx/sites-enabled/default ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com:~/
    ssh -i "cms/ehealth-server.pem" ubuntu@ec2-13-59-167-175.us-east-2.compute.amazonaws.com "sudo mv ~/default /etc/nginx/sites-enabled/default && sudo systemctl reload nginx"