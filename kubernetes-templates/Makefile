DOCKER_IMAGE=<XAP DOCKER IMAGE>
DOCKER_REGISTRY_SERVER=<DOCKER REGISTRY>
DOCKER_USER=<REGISTRY USERNAME>
DOCKER_PASSWORD=<REGISTRY PASSWORD>
DOCKER_EMAIL=<EMAIL>

IMAGE_PULL_SECRET=xap12-registry-key

XAP_LICENSE_KEY=<XAP LICENSE KEY>

XAP_MGT_GSC_COUNT=0
#XAP_MGT_GSM_OPTIONS="-Xms128m -Xmx128m"
#XAP_MGT_GSC_OPTIONS="-Xms128m -Xmx128m -Dcom.gs.zones=zone1"
#XAP_MGT_LUS_OPTIONS="-Xms128m -Xmx128m"

XAP_NODE_REPLICA=4
XAP_NODE_GSC_COUNT=1
#XAP_NODE_GSC_OPTIONS="-Xms128m -Xmx128m -Dcom.gs.zones=zone2"

create-image-pull-secret:
	-kubectl create secret docker-registry $(IMAGE_PULL_SECRET) --docker-server=$(DOCKER_REGISTRY_SERVER) --docker-username=$(DOCKER_USER) --docker-password=$(DOCKER_PASSWORD) --docker-email=$(DOCKER_EMAIL)
create-xap-datagrid:
	@echo 'Creating XAP license secret'
	@echo -n "$(XAP_LICENSE_KEY)" > xap-license
	@-kubectl create secret generic xap-license-secret --from-file=./xap-license
	@echo 'Creating XAP configuration maps'
	@echo -n "$(XAP_MGT_GSC_OPTIONS)" > xap-gsc-options
	@echo -n "$(XAP_MGT_GSM_OPTIONS)" > xap-gsm-options
	@echo -n "$(XAP_MGT_LUS_OPTIONS)" > xap-lus-options
	@-kubectl create configmap xap-mgt-config-map --from-literal=gsc-count=$(XAP_MGT_GSC_COUNT) --from-file=./xap-gsc-options --from-file=./xap-gsm-options --from-file=./xap-lus-options
	@echo -n "$(XAP_NODE_GSC_OPTIONS)" > xap-gsc-options
	@-kubectl create configmap xap-node-config-map --from-literal=gsc-count=$(XAP_NODE_GSC_COUNT) --from-file=./xap-gsc-options
	@echo 'Creating XAP GSM/LUS Service'
	@kubectl create -f xap-mgt-node-svc.yaml
	@echo 'Creating XAP GSM/LUS Deployment'
	@sed -e 's|<image>|$(DOCKER_IMAGE)|g' -e 's|<imagePullSecret>|$(IMAGE_PULL_SECRET)|g' xap-mgt-node.yaml | kubectl create -f -
	@echo 'Creating XAP GSC(s) Deployment'
	@sed -e 's|<num>|$(XAP_NODE_REPLICA)|g' -e 's|<image>|$(DOCKER_IMAGE)|g' -e 's|<imagePullSecret>|$(IMAGE_PULL_SECRET)|g' xap-compute-node.yaml | kubectl create -f -
	@echo 'Creating GS Webui Service'
	@kubectl create -f gs-webui-svc.yaml
	@echo 'Creating GS Webui Deployment'
	@sed -e 's|<image>|$(DOCKER_IMAGE)|g' -e 's|<imagePullSecret>|$(IMAGE_PULL_SECRET)|g' gs-webui.yaml | kubectl create -f -
