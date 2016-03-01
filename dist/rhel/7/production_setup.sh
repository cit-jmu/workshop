#!/bin/bash
current=/home/deploy/apps/workshop/current
cp $current/dist/rhel/7/backup-db /usr/local/bin/
cp $current/dist/rhel/7/puma-init /usr/local/bin/
cp $current/dist/rhel/7/send-reminders /usr/local/bin/
cp $current/dist/rhel/7/puma.service /usr/lib/systemd/system/
chmod a+x /usr/local/bin/backup-db /usr/local/bin/puma-init /usr/local/bin/send-reminders
crontab -u deploy -l ; echo "0 9 * * * /usr/local/bin/workshop-send-reminders >> /home/deploy/apps/workshop/shared/log/cron.log 2>&1" | sort - | uniq - | crontab -u deploy -
crontab -u postgres -l ; echo "0 0 * * * /usr/local/bin/backup-db workshop >> /var/log/backup-db.log 2>&1" | sort - | uniq - | crontab -u postgres -
systemctl daemon-reload
systemctl enable puma.service