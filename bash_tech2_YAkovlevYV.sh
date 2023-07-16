#!/bin/bash
#YakovlevYV
echo "Задание 2"
tar cpf /archive/home-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / home
tar cpf /archive/ssh-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / etc/ssh/sshd_config
sudo tar cpf /archive/xrdp-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / etc/xrdp/xrdp.ini
sudo tar cpf /archive/vsftpd-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / etc/vsftpd.conf
sudo tar cpf /archive/varlog-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / var/log
find /archive/* -mtime +15 -delete