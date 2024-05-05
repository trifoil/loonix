#!/bin/bash
# get the domain and password from user
read -r -p "Enter subdomain: " subdomain
read -r -s -p "Enter password: " pass

domain="${subdomain}.linoux"

# check if domain si alwready taken since username is the domain
if grep "${domain}" /etc/passwd >/dev/null 2>&1; then
  echo "subdomain already used"
  exit 1
fi

# hardcode soft and hard limit
readonly B_SOFT="500m"
readonly B_HARD="750M"

function is_root() {
  if [ "$(id -u)" -eq 0 ]; then # you are root, set prompt password
    return
  else # normal
    sudo -v
  fi
}

is_root

# TODO : check if domain is valid
#while [[ $domain =~ /^[a-z][a-z0-9_.]*\w ]]; do
#while [[ $domain =~ ^(?:\p{L}\p{M}*|[\-])*$ ]]; do
#  domain="$(read -r)"
#  echo "Bad domain name:"
#done

## setup user and quota
sudo useradd --create-home -s /usr/sbin/nologin -p "${pass}" "$domain" -d "/www/${domain}"
#sudo xfs_quota -x -c "limit bsoft=${B_SOFT} bhard=${B_HARD} $domain" "/www/${domain}"
#sudo xfs_quota -x -c "'limit bsoft=${B_SOFT} bhard=${B_HARD} ${domain}'" "/www/${domain}"

## setup dns record
echo "include \"/etc/named.${domain}.zones\";" | sudo tee -a /etc/named.conf

sudo touch "/etc/named.${domain}.zones"
echo "
zone \"${domain}\" {
 type master;
 file \"/etc/named/${domain}.frw\";
};
" | sudo tee "/etc/named.${domain}.zones"

sudo touch "/etc/named/${domain}.frw"
FORWARD_SERIAL=$(date +%s)
echo "\$TTL    86400
@       IN      SOA     ${domain}. www.${domain}. (
 ${FORWARD_SERIAL}      ;Serial
 3600            ;Refresh
 1800            ;Retry
 604800          ;Expire
 86400           ;Minimum TTL
)
@               IN      NS      ns1.${domain}.
@               IN      NS      ns2.${domain}.
@               IN      A       10.42.0.64
ns1             IN      A       10.42.0.64
ns2             IN      A       10.42.0.64
www             IN      CNAME   ${domain}.
" | sudo tee "/etc/named/${domain}.frw"

echo "64      IN      PTR     ${domain}." | sudo tee -a "/etc/named/reverse"

# TODO finir dnssec
#sudo dnssec-keygen -a RSASHA256 -b 4096 -n ZONE "${domain}"
#sudo dnssec-keygen -a RSASHA256 -b 4096 -n ZONE 0.42.10.in-addr.arpa
#sudo dnssec-keygen -f KSK -a RSASHA256 -b 4096 -n ZONE "${domain}"
#sudo dnssec-keygen -f KSK -a RSASHA256 -b 4096 -n ZONE 0.42.10.in-addr.arpa

#for key in ls "/var/named/K${domain}${*}.key"; do
#  echo "\$INCLUDE $key" >>${domain}.frw
#done

#for key in ls "/var/named/K0.42.10.in-addr.arpa${*}.key"; do
#  echo "\$INCLUDE $key" >>${domain}.frw
#done
#chown root:named "/var/named/K${domain}${*}.key"
#chown root:named "/var/named/K0.42.10.in-addr.arpa${*}.key"
#dnssec-signzone -A -3 "$(head -c 1000 /dev/random | sha1sum | cut -b 1-16)" -N INCREMENT -o "${domain}" -t "/var/named/K${domain}${*}.key"
#dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) -N INCREMENT -o 0.42.10.in-addr.arpa -t "/var/named/K0.42.10.in-addr.arpa${*}.key"

sudo systemctl restart named.service

## setup samba share
echo "[${domain}]
path = /www/${domain}
browsable = yes
writable = yes
guest ok = no
read only = no
server smb encrypt = required
vfs objects = full_audit catia fruit streams_xattr
full_audit:priority = notice
full_audit:facility = local5
full_audit:success = connect disconnect mkdir rmdir read write rename
full_audit:failure = connect
full_audit:prefix = %u|%I|%S
fruit:encoding = native
fruit:metadata = stream
fruit:zero_file_id = yes
fruit:nfs_aces = no
valid users = ${domain}" | sudo tee -a "/etc/samba/smb.d/${domain}.conf"
sudo chcon -t samba_share_t "/www/${domain}"
sudo smbpasswd -a smbuser
(
  echo "$pass"
  echo "$pass"
) | smbpasswd -s -a test.lan
echo "include = /etc/samba/smb.d/${domain}.conf" | sudo tee -a "/etc/samba/smb.conf"
sudo smbcontrol all reload-config

## setup apache
sudo mkdir "/www/${domain}/html"
sudo touch "/www/${domain}/html/index.html"
echo "<h1>${domain}</h1>" | sudo tee "/www/${domain}/html/index.html"
sudo mkdir "/www/${domain}/icons"
sudo chown apache:apache --recursive "/www/${domain}"
semanage fcontext -a -e /var/www "/www/${domain}"
restorecon -Rv "/www/${domain}"
touch "/etc/httpd/sites-availible/${domain}"
echo "
<VirtualHost *:80>
        ServerName ${domain}
        DocumentRoot /www/${domain}/html
        DirectoryIndex index.php index.htm index.html
        #Alias /icons/ /www/${domain}/icons/

        <Directory /www/${domain}/html>
                Require all granted
		            AllowOverride all
		            Options -ExecCGI -Indexes
                Satisfy all
        </Directory>
</VirtualHost>
" | sudo tee "/etc/httpd/sites-availible/${domain}"
sudo ln -s "/etc/httpd/sites-availible/${domain}" "/etc/httpd/sites-enabled/${domain}"
sudo apachectl -k graceful

## mariad db setup
sudo mariadb -e "CREATE DATABASE IF NOT EXISTS \`${subdomain}\`;"
sudo mariadb -e "GRANT ALL PRIVILEGES ON ${subdomain}.* TO ${subdomain} IDENTIFIED BY '${pass}';"
sudo mariadb -e "FLUSH PRIVILEGES;"

## ftp
# TODO: FIX MOI CA
#echo ${domain} | sudo tee -a /etc/vsftpd/vusers.txt
#echo ${pass} | sudo tee -a /etc/vsftpd/vusers.txt
#db_load -T -t hash -f /etc/vsftpd/vusers.txt /etc/vsftpd/vsftpd-virtual-user.db
#truncate --size 0 /etc/vsftpd/vusers.txt
#touch "/etc/vsftpd/vsftpd_user_conf/${domain}"
#echo local_root="/www/${domain}" | sudo tee "/etc/vsftpd/vsftpd_user_conf/${domain}"
