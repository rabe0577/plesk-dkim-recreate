#!/bin/bash

##path for temp file
tmp_path=/tmp/dkim_tmp
##temp filename prefix
tmp_prefix=dkim_tmpfile_
##temp file ending
tmp_fe=.txt

##path in customer www-root for dkim file
dkim_rec_path=/dkim_keys
##dkim filename prefix
dkim_rec_prefix=dkim_key_
##dkim file ending
dkim_rec_fe=.txt

##go to sleep, because plesk is not so fast...
sleep 15

##find customer www-root
customer_root=$(/usr/local/psa/bin/domain --info ${NEW_DOMAIN_NAME} | grep "WWW-Root" | cut -d/ -f2-5)

## create directories if they do not exist yet
mkdir -p $tmp_path
mkdir -p /$customer_root$dkim_rec_path

## enable DKIM on the domain
/usr/local/psa/bin/domain_pref --update ${NEW_DOMAIN_NAME} -sign_outgoing_mail true

## recreate key
openssl rsa -in /etc/domainkeys/${NEW_DOMAIN_NAME}/default -pubout -out $tmp_path/public_${NEW_DOMAIN_NAME}.key

## crop first and last line of keyfile
sed '1d;$d' $tmp_path/public_${NEW_DOMAIN_NAME}.key > $tmp_path/$tmp_prefix${NEW_DOMAIN_NAME}$tmp_fe
rm $tmp_path/public_${NEW_DOMAIN_NAME}.key
## remove newlines from the key
dkim_key=$(tr -d '\n' < $tmp_path/$tmp_prefix${NEW_DOMAIN_NAME}$tmp_fe)
rm $tmp_path/$tmp_prefix${NEW_DOMAIN_NAME}$tmp_fe

## generate domainkey record and store to text file
echo "default._domainkey.${NEW_DOMAIN_NAME} IN TXT \"v=DKIM1; k=rsa; p=$dkim_key" > /$customer_root$dkim_rec_path/$dkim_rec_prefix${NEW_DOMAIN_NAME}$dkim_rec_fe