#!/bin/sh

echo "Stopping all docker services"
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker system prune -y

echo 'Mounting all volumes...'
mount -a

echo "Unlocking LUKS volumes..."
if df -h | grep -q '/pass'; then
	echo '  Unlocking with password from /pass...'
	cat /pass/luks.pass | cryptsetup luksOpen /dev/md127 data -
else
	echo '  /pass is not mounted! Help!' >&2
	exit 1
fi
sleep 2s

echo "Mounting volumes..."
df -h | grep -q '/opt/data' || mount /dev/mapper/data-shared /opt/data
df -h | grep -q '/opt/apps' || mount /dev/mapper/data-config /opt/apps
df -h | grep -q '/opt/backup' || mount /dev/mapper/data-backup /opt/backup

echo "Starting containers"
#chown -R www-data:www-data /opt/apps
docker-compose -f @dockerComposeFile@ up -d --remove-orphans

echo 'Un-mounting /pass'
umount /pass
