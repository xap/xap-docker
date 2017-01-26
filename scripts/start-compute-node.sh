#!/bin/bash
set -e

readonly dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

echo $1 > $dir/xap-license.txt

docker build -t gigaspaces/xap:12.0.1 $dir

docker run --name xap-node -d --net=host -e XAP_LOOKUP_LOCATORS=${2}:4174 gigaspaces/xap:12.0.1 gsa.global.lus 0 gsa.lus 0 gsa.global.gsm 0 gsa.gsm 0 gsa.gsc 1
