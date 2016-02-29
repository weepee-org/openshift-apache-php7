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

# set apache as owner/group
if [ "$FIX_OWNERSHIP" != "" ]; then
	chown -R apache:apache /app
fi

# execute any pre-exec scripts, useful for images
# based on this image
for i in /scripts/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[${STAMP}] pre-exec.d - processing $i"
		. "${i}"
	fi
done

echo "openshift-wordpress:x:`id -u`:0:openshift-wordpress:/:/sbin/nologin" >> /etc/passwd

echo "[${STAMP}] Starting daemon..."
# run apache httpd daemon
httpd -D FOREGROUND
