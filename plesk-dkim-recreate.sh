#!/bin/bash

##path for temp file
tmp_path=/tmp/dkim_tmp
##temp filename prefix
tmp_prefix=dkim_tmpfile_
##temp file ending
tmp_fe=.txt

##path for dkim file
dkim_rec_path=/tmp/dkim_keys
##dkim filename prefix
dkim_rec_prefix=dkim_key_
##dkim file ending
dkim_rec_fe=.txt

## create directories if they do not exist yet
mkdir -p $tmp_path
mkdir -p $dkim_rec_path

## enable DKIM on the domain
/usr/local/psa/bin/domain_pref --update ${NEW_DOMAIN_NAME} -sign_outgoing_mail true

## recreate key
openssl rsa -in /etc/domainkeys/${NEW_DOMAIN_NAME}/default -pubout -out public.key

## crop first and last line of keyfile
sed '1d;$d' public.key > $tmp_path/$tmp_prefix${NEW_DOMAIN_NAME}$tmp_fe
## remove newlines from the key
dkim_key=$(tr -d '\n' < $tmp_path/$tmp_prefix${NEW_DOMAIN_NAME}$tmp_fe)
rm $tmp_path/$tmp_prefix${NEW_DOMAIN_NAME}$tmp_fe

## generate domainkey record and store to text file
echo "default._domainkey.${NEW_DOMAIN_NAME} IN TXT \"v=DKIM1; k=rsa; p=$dkim_key" > $dkim_rec_path/$dkim_rec_prefix${NEW_DOMAIN_NAME}$dkim_rec_fe