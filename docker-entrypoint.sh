#!/bin/bash
set -e

readonly first_param=${1#\"}
if [[ "${first_param:0:1}" = '-' || "${first_param:0:3}" = 'gsa' ]]; then
	set -- ./bin/gs-agent.sh "$@"
fi

if [[ -z "$XAP_LICENSE_KEY" ]]; then
	echo "Please set 'XAP_LICENSE_KEY' environment variable"
else
	exec env EXT_JAVA_OPTIONS="-Dcom.gs.licensekey=$XAP_LICENSE_KEY $EXT_JAVA_OPTIONS" "$@"
fi
