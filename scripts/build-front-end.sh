#!/bin/bash

set -e

cp -R /opt/src/rap2-easy-end/config/rap2-dolores/config.prod.js \
/opt/src/rap2-easy-end/source/rap2-dolores/src/config/

docker run --rm -it \
-v="/opt/src/rap2-easy-end/config/npm/setting.npmrc:/root/.npmrc" \
-v="/opt/src/rap2-easy-end/source/rap2-dolores/:/opt/src/rap2-dolores/" \
-v="/opt/src/rap2-easy-end/scripts/npm-front-end.sh:/tmp/npm-front-end.sh" \
sayhub/node:8.9.3 \
/tmp/npm-front-end.sh
