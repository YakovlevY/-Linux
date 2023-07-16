#!/bin/bash
#YakovlevYV
echo "Задание 1"
if grep -R "jammy-backports" /etc/apt/sources.list
then 
   echo -n "Backports Repository в списке! \n"
   sleep 1
else
   echo -n "Backports Repository отсутствует! \n"; sleep 2; echo "Adding /etc/apt/sources.list \n"
   echo "deb http://archive.ubuntu.com/ubuntu dists jammy-backports main" | sudo sh -c 'cat >> /etc/apt/sources.list'
   sleep 1
   echo "Backports Repository добавлена"
fi

sudo apt update

if ! apache2 -v 2>/dev/null
then 
   sleep 1
   echo -n "Apache не установлен! \n" 
   sudo apt install apache2 apache2-doc apache2-utils -y
   sleep 1
   apache2 -v
else
   echo -n "Apache установлен!\n"
fi
sleep 1
if systemctl is-active -q apache2
then 
   echo "Служба Apache запущена"
else
   echo "Служба Apache остановлена"
fi

sudo apt install python3.10
python3 --version

if ! ssh -V 2>/dev/null
then 
   sudo apt install openssh-server -y
   sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
   sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
   sudo sed -i -e 's/#Port 22/Port 2222\n#Port 22/g' /etc/ssh/sshd_config
   sudo sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no\n#PasswordAuthentication yes/g' /etc/ssh/sshd_config
   sudo systemctl start ssh
else
   ssh -V
   echo "SSH установлен!"
fi

sudo systemctl start ssh

sleep 2
if ! vsftpd -version 2>/dev/null
then
   echo -n "VSFTPD Не установлен"
sleep 2
   sudo apt install vsftpd -y
   sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.backup
   sudo sed -i -e 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
   sudo sed -i -e 's/#local_enable=YES/local_enable=YES/' /etc/vsftpd.conf
   sudo sed -i -e 's/#local_umask=022/local_umask=022/' /etc/vsftpd.conf
   sudo service vsftpd restart
   vsftpd -version
else
   echo "VSFTPD установлен"
   vsftpd -version
fi

Sleep 2
DIRECTORIES="/home /var/log"
echo "Top 10"
for DIR in $DIRECTORIES
do
   echo "The $DIR Directory:"
   du -S $DIR 2>/dev/null |
   sort -rn |
   sed '{11,$D; =}' |
   sed 'N; s/\n/ /' |
   awk '{printf $1 ":" "\t" $2 "\t" $3 "\n"}'
done

sudo apt autoclean
sudo apt clean
sudo apt autoremove
