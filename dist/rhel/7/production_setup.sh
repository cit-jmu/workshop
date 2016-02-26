#!/bin/bash
current=/home/deploy/app/workshop/current
cp -a $current/dist/rhel/7/backup-db /usr/local/bin/
cp -a $current/dist/rhel/7/puma-init /usr/local/bin/
cp -a $current/dist/rhel/7/puma.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl enable puma.service
chmod a+x /usr/local/bin/backup-db /usr/local/bin/puma-init
