DOCKER_IMAGE=<XAP DOCKER IMAGE>
DOCKER_REGISTRY_SERVER=<DOCKER REGISTRY>
DOCKER_USER=<REGISTRY USERNAME>
DOCKER_PASSWORD=<REGISTRY PASSWORD>
DOCKER_EMAIL=<EMAIL>

IMAGE_PULL_SECRET=xap12-registry-key

XAP_GSC_COUNT=4

create-image-pull-secret:
	-kubectl create secret docker-registry $(IMAGE_PULL_SECRET) --docker-server=$(DOCKER_REGISTRY_SERVER) --docker-username=$(DOCKER_USER) --docker-password=$(DOCKER_PASSWORD) --docker-email=$(DOCKER_EMAIL)

create-xap-datagrid:
	@echo 'Creating XAP GSM/LUS Service'
	kubectl create -f xap-mgt-node-svc.yaml
	@echo 'Creating XAP GSM/LUS Deployment'
	sed -e 's|<image>|$(DOCKER_IMAGE)|g' -e 's|<imagePullSecret>|$(IMAGE_PULL_SECRET)|g' xap-mgt-node.yaml | kubectl create -f -
	@echo 'Creating XAP GSC(s) Deployment'
	sed -e 's|<num>|$(XAP_GSC_COUNT)|g' -e 's|<image>|$(DOCKER_IMAGE)|g' -e 's|<imagePullSecret>|$(IMAGE_PULL_SECRET)|g' xap-compute-node.yaml | kubectl create -f -
	@echo 'Creating GS Webui Service'
	kubectl create -f gs-webui-svc.yaml
	@echo 'Creating GS Webui Deployment'
	sed -e 's|<image>|$(DOCKER_IMAGE)|g' -e 's|<imagePullSecret>|$(IMAGE_PULL_SECRET)|g' gs-webui.yaml | kubectl create -f -