#!/bin/sh

: ${XSECURELOCK_IMAGE_PATH:=/tmp/scrshot-blurred.png}

/usr/bin/feh -. --window-id="${XSCREENSAVER_WINDOW}" -F "${XSECURELOCK_IMAGE_PATH}"
