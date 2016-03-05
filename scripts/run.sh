#!/bin/sh

STAMP=$(date)

# execute any pre-init scripts, useful for images
# based on this image
for i in /scripts/pre-init.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[${STAMP}] pre-init.d - processing $i"
		. "${i}"
	fi
done

# execute any pre-exec scripts, useful for images
# based on this image
for i in /scripts/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[${STAMP}] pre-exec.d - processing $i"
		. "${i}"
	fi
done

echo "oc:x:`id -u`:0:oc:/:/sbin/nologin" >> /etc/passwd

# set apache as owner/group
if [ "$FIX_OWNERSHIP" != "" ]; then
	chown -R 1000060000:0 /app
fi

if [ -f /build/run.sh ]; then
   echo "Running /build/run.sh"
	 /build/run.sh
fi

echo "[${STAMP}] Starting daemon..."
# run apache httpd daemon
httpd -D FOREGROUND
