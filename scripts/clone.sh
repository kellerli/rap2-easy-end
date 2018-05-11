#!/bin/bash

set -e

sh /opt/src/rap2-easy-end/scripts/clean.sh

cd /opt/src/rap2-easy-end/
mkdir -p ./source/
cd ./source/

git clone https://github.com/thx/rap2-dolores.git

git clone https://github.com/thx/rap2-delos.git
