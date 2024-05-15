# note project linux
## partie 1 : partage de fichier
### 1 service partage de fichier
- samba 
- nfs 
- ftp

### securisation du partage de fichier
- clamtav => antivirus
- lynis => outils de scan de securité
- apparmor ou selinux
- permission

### automatisation de creation d'utilisateur
- ssh depuis en dehors du reseaux etc

## partie 2 : serveur web
### 1 service web
- location de serveur donc automatisation -> scripts
- quota
- droit serveur
- base de donnée 
- faire un ftp pour le site web

### virtual host
- utilisation de hote virtuelle
- configuration de dns
- dns master zone
- utilisateur no login

## partie 3 : firewall
### configuration de firewall
pour tous les services reseaux

## partie 4: cronie 
configuration serveur de temps
script d'automatisation

## partie 5: serveur de backup

plan de backup
etc



### partitionnement

- /boot
- /home
- /
- /var
- /web
- /partage xfs
- swap(optionel)


## configuration ssh

- crée utilisateur pour le ssh
- generer la clée sur le client
- transferer la clée publique sur le server `ssh-copy-id <user@ip>`

## idee configuration

- utiliser une piv pour securiser la clée ssh ( stocker dans yubikey )	[https://developers.yubico.com/PIV/Guides/SSH_user_certificates.html]()

- [https://www.fail2ban.org/wiki/index.php/Main_Page]()

## samba 
- crée dirs public
- crée dir private
- config user password

```
smbpasswd -a <smbuser>
```

- config group samba
```
groupadd <smbgroup>
usermod -g <smbgroup> <smbuser>
```
- set partage dir owner to <smbgroug>
```
chown -R root:<smbgroup> <path>
```
- config samba
```CONF
[global]
workgroup = WORKGROUP
server string = Samba
netbios name = AlmaLinux -> nom machine
security = user -> active directory or user
map to guest = bad user
ntlm auth = true -> authorise windows 10 et superieur

[public] -> nom de partage
path = <Path>
browsable = yes
writable = yes
guest ok = yes
read only = no -> read only par defaut

[private]
path = <Path>
browsable = yes
writable = yes
guest ok = no
read only = no -> read only par defaut
valid users = @smbgroup

```
- test de config samba
```
testparm
```
- start smb service
```
systemctl enable --now smb
systemctl enable --now nmb
```

- set and see selinux context
```
ls -Z
chcon -R -t samba <path>
```

## server web nginx ou apache
### apache
- config httpd dans /etc/httpd/conf.d/<site>.conf
```
<VirtualHost *:80>
	ServerName www.tot.lan
	ServerAlias toto.lan
	DocumentRoot /srv/web/toto
	
	<Directory /src/web/toto>
	Options Indexes FollowSymlinks
	AllowOverride All
	Require all granted
	</Directory>
</VirtualHost>
```

- check config
```
apachectl configtest
```

- start apache

- redirect with pour tester
	- /etc/host
```
<ip machine> www.toto.lan
```

## dns
- install bind ( service dns ) et bind-dns-sec ( point supplementaire )

- config /etc/named.conf
```

{
listen-on port { any };

allow-query {any};
};


```
- config /etc/resolf.conf
```
nameserver <ip serv>
```

- test with nslookup

- config zone 
```
zone "lan" IN {
	type master;
	file "named.lan";
	allow-update {none;};
};

# zone inverse 
zone "253.168.192.in-addr-arpa" IN {
	type master;
	file "named.lan.reverse";
	allow-update {none;};
};
```

- config named.lan
	- ne rajoute pas .<nom zone> a la fin du dns

```
$TTL 3H
@ IN SOA <nom serv>.<nom zone>. root.<nom serv>.<nom zone> (
							202303132001 ; serial
							1D           ; refresh
							1H           ; retry
							1W           ; expire
							3H           ; minimum
)

@ IN NS <nom serv>.<nom zone>.
<nom serv> IN A <ip serv>
<domains name 1> IN CNAME <nom de serv>.<nom de zone>.
<domains name 2> IN A <ip serv>
```

	pour rajoute .<nom zone> a la fin du dns on retire le . a la find de <nom serv>.<nom zone>

- config named.lan.reverse
```
$TTL 3H
@ IN SOA <nom serv>.<nom zone>. root.<nom serv>.<nom zone> (
							202303132001 ; serial
							1D           ; refresh
							1H           ; retry
							1W           ; expire
							3H           ; minimum
)

@ IN NS <nom serv>.<nom zone>.
<nom serv> IN A <ip serv>
128 IN PTR <nom serv>.<nom zone>.
```

- tout les name avec les meme droits

- on test avec named-checkzone <ip serv>.in-addr.arpa named.lan.reverse 
- on test avec named-checkzone <domain name x> namde.lan

- on test egalement avec nslookup <ip ou domaine>

- ajouter une regle a firewalld
```
firewall-cmd --add-service=dns --permanent
```

