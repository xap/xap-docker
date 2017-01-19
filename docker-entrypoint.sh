#!/bin/bash
set -e

readonly first_param=${1#\"}
if [[ "${first_param:0:1}" = '-' || "${first_param:0:3}" = 'gsa' ]]; then
	set -- ./bin/gs-agent.sh "$@"
fi

exec "$@"
