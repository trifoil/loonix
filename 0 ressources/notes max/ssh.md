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