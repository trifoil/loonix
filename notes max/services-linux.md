#######
# SSH #
#######

Configurer le ssh - LINUX
-------------------------

1) génération de la clé RSA

[user@srv ~]$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/user/.ssh/id_rsa):   # Enter or input changes if you want
Created directory '/home/user/.ssh'.
Enter passphrase (empty for no passphrase):   # set passphrase (if set no passphrase, Enter with empty)


2) Copie de la clef publique dans ~/.ssh/authorized_keys

[user@srv ~]$ ll ~/.ssh
total 8
-rw-------. 1 user user 2655 Jan  7 19:07 id_rsa
-rw-r--r--. 1 user user  575 Jan  7 19:07 id_rsa.pub

[user@srv ~]$ mv ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

3) Transfert de la clé privé créée sur le serveur au client (scp)

# Si le fichier .ssh n'est pas créé

[user@client ~]$ mkdir ~/.ssh
[user@client ~]$ chmod 700 ~/.ssh

# Sinon

[user@client ~]$ scp user@ip_or_domain:/home/user/.ssh/id_rsa ~/.ssh/
user@ip_or_domain's password:
id_rsa                                        100% 1876   193.2KB/s   00:00

4) Sécurisation supplémentaires 

[root@srv ~]# vi /etc/ssh/sshd_config 
# line 65 : change to [no]
PasswordAuthentication no

# line 69 : if it's enabled, change it to [no], too
# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes
--> KbdInteractiveAuthentication no

# Supprimer l'accès à root ssh 
Modifier fichier /etc/ssh/sshd_config & vi /etc/ssh/sshd_config.d/01-permitrootlogin.conf 
- PermitRootLogin no

Configurer le SSH - Windows - Putty
-----------------------------------

1) Installation de PuttyGen 
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

2) Copie du fichier id_rsa dans Windows 
scp user@ip_or_domain:/home/user/.ssh/id_rsa C:\Dossier\Que\Vous\Préférez

3) Génération de la clé privée RSA

Après avoir démarré [Puttygen.exe], cliquez sur le bouton [Load] et choisissez le fichier que vous avez copié sur votre machine depuis le serveur Linux(*Tout type de fichier "/!\")
Ensuite, [Save private key]


4) Choisir la clé dans Putty 
[Connection] - [SSH] - [Auth] - [Credentials (dernière version)] - Private key file for authentification - Browse 

Choisir la clé privée que vous avez créée précédement 

5) Connection SSH
Allez dans session - [Host-Name] - Mettez votre adresse ip

Ensuite -> [open]

Configurer le SSH - Windows 11 - Terminal
-----------------------------------------

Mettez le fichier id_rsa que vous avez récupéré dans votre serveur Linux puis ajoutez le dans : C:\Users\username\.ssh\

Connectez vous dans votre shell -> ssh user@ip_or_domain

################
# BIND - DNS # #
################

# Commandes utiles 

hostnamectl : cette commande montre quelques caractéristiques de la machine Linux.

# fichiers utiles 

/etc/resolv.conf --> résolution DNS 
/etc/NetworkManager/system-connections/ --> dossier comprenant le fichier de votre carte réseau
/var/named/ --> dossier utile pour le BIND (DNS)
/etc/named.conf --> fichier de configuration de BIND en général 

1) Installation de BIND 

dnf -y install bind 
systemctl start named
systemctl enable named

2) Configuration de base de /etc/named.conf 

options {
        listen-on port 53 { ip_serveur; }; 
        listen-on-v6 port 53 { none; }; --> ip_serveur si besoin à la place de none; 
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { any; }; --> autorisation des requêtes DNS (exterieur)
        recursion yes; --> Si le serveur a besoin de faire des requêtes DNS ext, mettez "yes" sinon "no". No --> + sécurisé

        dnssec-enable no;
        dnssec-validation no;

        forwarders {
                8.8.8.8;  // Serveur DNS Google
                1.1.1.1;  // Serveur DNS Cloudflare
        }; --> Redirection vers une autre adresse IP

        managed-keys-directory "/var/named/dynamic";
        geoip-directory "/usr/share/GeoIP";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

# Créations des zones (forward et reversed)

zone "[nom_du_serveur].[domaine_que_vous_voulez]" IN {
        type master; --> zone authoritaire
        file "ns1.forward"; --> nom du fichier de zone
        allow-update {none; }; --> mises à jour dynamiques désactivées
};

zone "200.168.192.in-addr.arpa" IN {
        type master; --> zone authoritaire
        file "ns1.reversed"; --> nom du fichier de zone
        allow-update {none;}; --> mises à jour dynamiques désactivées
};

200.168.192 vient de 192.168.200.0 sauf qu'on enlève le 0 et qu'on le met à l'envers


3) Configuration de base des fichiers de zone

ns1.forward 
-----------

$TTL 86400
@   IN  SOA     [domaine]. root.[nom_du_serv].[domaine]. (
        2023022101  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      [nom_du_serv].[domaine].
        IN  A       192.168.200.3 --> adresse ip du serveur

[nom_du_serv].[domaine]     IN  A       192.168.200.3 --> adresse ip du serveur

ns1.reversed 
------------

$TTL 86400
@   IN  SOA    [domaine]. root.[nom_du_serv].[domaine]. (
        2023022101  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      [nom_du_serv].[domaine].

3      IN  PTR     [nom_du_serv].[domaine].

le 3 vient de 192.168.200.[3] 


# définir bind juste pour l'IPv4
vi /etc/sysconfig/named
# Mettez à la fin 
OPTIONS="-4"

4) Recharger named 
systemctl restart named 

5) Ajouter une règle de pare-feu dns 
firewall-cmd --add-service=dns
firewall-cmd --runtime-to-permanent

6) Changer le fichier /etc/resolv.conf 

Mettez uniquement 
nameserver [ip_du_serveur]

7) Tester si ça marche 

nslookup [votre_domaine]

# REMARQUE 

Il est possible que vous ayez une erreur avec le serveur root b 
changez dans /var/named/named.ca 

ipv4 de root b : 170.247.170.2
ipv6 de root b : 2801:1b8:10::b


#########
# SAMBA #
#########

1) Installation 

dnf -y install samba

2) Création des dossiers et mise en place des permissions
mkdir -p [DEST]/[VOTRE_DOSSIER_DE_PARTAGE]
chmod -R 755 [DEST]/[VOTRE_DOSSIER_DE_PARTAGE]

[PARTAGE_PUBLIC]

chown nobody:nobody [DEST]/[VOTRE_DOSSIER_DE_PARTAGE]

Fichier de configuration = /etc/samba/smb.conf

----------
[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = lama
security = user
map to guest = bad user
dns proxy = yes
ntlm auth = true

[Public]
path = /srv/samba/data
writable = yes
browsable = yes
guest ok = yes
read only = no
----------

--> SELinux 
1 - semanage fcontext -a -t samba_share_t [DEST]/[VOTRE_DOSSIER_DE_PARTAGE]
2 - restorecon -Rv [DEST]/[VOTRE_DOSSIER_DE_PARTAGE]

setsebool -P samba_enable_home_dirs on 
Il faut regarder les commandes setsebool pour samba pour la sécurité ++

--> Firewall 
firewall-cmd --add-service=samba
firewall-cmd --runtime-to-permanent

Commande pour se connecter au partage public = 
dnf -y install smbclient

smbclient '\\[ip_du_serveur]\[Nom que vous avez mis entre crochet dans smb.conf]'

[PARTAGE_PRIVÉ]

[Private]
path = /srv/samba/private
valid users = @smbgroup --> group que vous allez créer
guest ok = no
writable = yes
browsable = yes
read only = no

création de l'utilisateur
ici par exemple

useradd smbuser
passwd smbuser

groupadd smbgroup
usermod -g smbgroup smbuser -> ajout de l'utilisateur dans le grp

ajout du passwd pour le serveur samba 
smbpasswd -a smbuser

smbclient '\\[ip_du_serveur]\[Nom que vous avez mis entre crochet dans smb.conf]' -U smbuser --> Puis mettez le passwd que vous avez initialisé avec smbpasswd

Exemple : smbclient '\\192.168.200.3\private' -U smbuser