#!/bin/bash
current=/home/deploy/apps/workshop/current
cp $current/dist/rhel/6/backup-db /usr/local/bin/
cp $current/dist/rhel/6/run-puma /usr/local/bin/
cp $current/dist/rhel/6/send-reminders /usr/local/bin/
cp $current/dist/rhel/6/puma /etc/init.d/
chmod a+x /usr/local/bin/backup-db /usr/local/bin/run-puma /usr/local/bin/send-reminders /etc/init.d/puma
crontab -u deploy -l ; echo "0 9 * * * /usr/local/bin/workshop-send-reminders >> /home/deploy/apps/workshop/shared/log/cron.log 2>&1" | sort - | uniq - | crontab -u deploy -
crontab -u postgres -l ; echo "0 0 * * * /usr/local/bin/backup-db workshop >> /var/log/backup-db.log 2>&1" | sort - | uniq - | crontab -u postgres -
chkconfig puma on