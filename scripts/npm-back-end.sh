#!/bin/bash

set -e

cd /opt/src/rap2-delos/

yum -y groupinstall "Development Tools"

npm install cross-env pm2

npm install

npm run build
