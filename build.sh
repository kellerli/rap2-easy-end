#!/bin/bash

set -e

rebuild="$1"

if test -n "$rebuild"; then

    /opt/src/rap2-easy-end/scripts/clone.sh

    /opt/src/rap2-easy-end/scripts/build-back-end.sh

    /opt/src/rap2-easy-end/scripts/build-front-end.sh

fi

docker build \
-t \
sayhub/rap2-easy-end:20180513 \
.
