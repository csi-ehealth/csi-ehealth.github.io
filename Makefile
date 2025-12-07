.PHONY: serve/cms

serve/cms:
	./cms/pocketbase serve

connect/cms:
	cd ./cms && ssh -i "ehealth_ssh.pem" ec2-user@ec2-3-138-193-102.us-east-2.compute.amazonaws.com