#!/bin/bash
current=/home/deploy/apps/workshop/current
cp $current/dist/rhel/7/backup-db /usr/local/bin/
cp $current/dist/rhel/7/puma-init /usr/local/bin/
cp $current/dist/rhel/7/puma.service /usr/lib/systemd/system/
chmod a+x /usr/local/bin/backup-db /usr/local/bin/puma-init
systemctl daemon-reload
systemctl enable puma.service