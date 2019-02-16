#!/bin/sh
passwd root
apt-get install ssh -y
sed -i '/#PermitRootLogin yes/c\PermitRootLogin no' /etc/ssh/sshd_config
service sshd restart
usermod -s /sbin/nologin root && service network-manager restart

iptables -F
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit 2/secon --limit-burst 2 -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "portscan:"
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "portscan:"
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
service iptables save
service iptables restart
usermod -s /bin/false sysadmin
usermod -L sysadmin

# yum update -y
# yum upgrade -y

wget https://tinyurl.com/fjghdlgh
wget https://tinyurl.com/ydyujwnb
wget https://tinyurl.com/y7yy5p9h
tar xzf fjghdlgh && cd maldetect-1.6.3 && ./install.sh && cd
tar xzf ydyujwnb && cd rkhunter-1.4.6 && ./installer.sh -l /usr --install && cd
tar xzf y7yy5p9h && cd lynis && apt-get install lynis -y

chmod 644 /etc/passwd /etc/group && chmod 640 /etc/shadow && chmod 600 /etc/ssh/sshd_config && chmod 555 /boot

exit 0;
