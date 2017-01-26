#!/bin/bash
set -e

readonly dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

echo $1 > $dir/xap-license.txt

docker build -t gigaspaces/xap:12.0.1 $dir

readonly LOOKUP_LOCATORS="$(/sbin/ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'):4174"

docker run --name xap-mgt-node -d --net=host -e XAP_LOOKUP_LOCATORS=$LOOKUP_LOCATORS gigaspaces/xap:12.0.1 gsa.global.lus 0 gsa.lus 1 gsa.global.gsm 0 gsa.gsm 1 gsa.gsc 0

docker run --name gs-webui -d --net=host -e XAP_LOOKUP_LOCATORS=$LOOKUP_LOCATORS gigaspaces/xap:12.0.1 ./bin/gs-webui.sh