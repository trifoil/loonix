#!/bin/bash
install_nfs_server(){
dnf install -y libnfsidmap
dnf install -y sssd-nfs-idmap
dnf install -y nfs-utils
}