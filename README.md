# loonix

Linux project repo (for Space Marines only!)

## TODO list

### Multiustilisateurs

- [ ] Partage NFS
- [ ] Partage SAMBA
- [ ] Serveur web
- [ ] Serveur FTP
- [ ] Serveur MySQL
- [ ] Serveur DNS

- [ ] DNS agit comme cache pour le réseau local
- [ ] Zone DNS pour chaque site

- [ ] Serveur de temps pour syncro les machines dans le réseau
- [ ] connnection sécurisée en ssh pour effectuer les configs




DNS CACHE

Enable the zone-statistics yes; directive in the named.conf file to monitor server performance and activity1.
Generate a current snapshot of server statistics by issuing the rndc stats command1.
The data is dumped into the /var/cache/bind/named.stats file by default1.
To view the cached DNS records, dump the in-memory cache to a file for analysis using the command sudo rndc dumpdb -cache1.
The cache is typically located at /var/cache/bind/named_dump.db for Debian-based systems, and /var/named/data/ directory is used by RedHat-based systems1.