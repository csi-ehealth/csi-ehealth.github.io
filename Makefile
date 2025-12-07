.PHONY: serve/cms

serve/cms:
	./cms/pocketbase serve


cms/connect:
	cd ./cms && ssh -i "ehealth_ssh.pem" ec2-user@ec2-3-138-193-102.us-east-2.compute.amazonaws.com

cms/update-data:
	scp -i "cms/ehealth_ssh.pem" -r cms/pb_migrations ec2-user@ec2-3-138-193-102.us-east-2.compute.amazonaws.com:~/
	scp -i "cms/ehealth_ssh.pem" -r cms/pb_data ec2-user@ec2-3-138-193-102.us-east-2.compute.amazonaws.com:~/


