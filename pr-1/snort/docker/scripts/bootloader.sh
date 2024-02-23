#!/bin/bash

#Copy config file of Snort / Pulledpork
cp /docker/configuration/snort/snort.conf /etc/snort/snort.conf
chown snort.snort /etc/snort -R
mkdir -p /var/log/snort

#create some needed files
mkdir -p /etc/snort/rules/iplists/
touch /etc/snort/rules/iplists/default.blacklist
touch /etc/snort/rules/iplists/default.whitelist
touch /etc/snort/sid-msg.map

#if you do not have oinkcode yet # ATTENTION ! these rules could be outdated #
cp -r /docker/rules/* /etc/snort/rules/

#example snort rule
# comment to keep original rules
echo 'alert tcp !62.217.187.130 any -> $HOME_NET 22 (msg:"SSH traffic from unknown source"; sid:2000001;)' > /etc/snort/rules/snort.rules

for var in $(printenv); do

    #explode vars to retrive key/value pairs
    IFS='=' read -r -a array <<< $var

    export KEY=${array[0]}

    if [[ $KEY =~ SNORT_|PPORK_|BARN_|HOST_ ]]; then

        export VALUE=${array[1]}

        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/snort/snort.conf'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/docker/configuration/supervisord/supervisor.conf'

    fi

done
