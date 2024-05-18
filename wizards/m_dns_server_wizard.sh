#!/bin/bash

sudo dnf -y install bind bind-utils 

cp -f config_files/dns/named.conf /etc/named.conf