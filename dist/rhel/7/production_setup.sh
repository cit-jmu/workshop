#!/bin/bash
current=/home/deploy/app/workshop/current
ln -s $current/dist/rhel/7/backup-db /usr/local/bin/backup-db
ln -s $current/dist/rhel/7/puma-init /usr/local/bin/puma-init
ln -s $current/dist/rhel/7/puma.service /usr/lib/systemd/system/puma.service
