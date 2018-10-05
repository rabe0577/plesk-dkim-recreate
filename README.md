# plesk-dkim-recreate
Script to recreate the DKIM Publickey and save it in customers document root

This script allows you to automatically get the DKIM public key if the Plesk DNS service is not installed.

Installation
------

The installation is quite simple because the script already gets all the information from Plesk. Variables and paths can be optionally adjusted at your own discretion.


If you have customized your Plesk document root, you will need to script the script to determine the correct path. To do this, execute this command on your Plesk server and replace the domain with a domain added to your server:
```
/usr/local/psa/bin/domain --info your-domain.tld | grep "WWW-Root" | cut -d/ -f2-5
```
The output must be displayed from the root directory to the first standard domain of your subscription, without the first and last slash. This looks like this `var/www/vhosts/your-domain.tld`.
If this is not the case, change the numbers after the cut command at `-f2-5` until the output path looks the same.

To add the script to Plesk, create the event "Domain created" in Tools & Settings > Event Manager and specify the full path to the script plesk-dkim-recreate.sh in Command field. For example: `bash /opt/scripts/plesk-dkim-recreate.sh`
In addition, create a new event "Default domain created (the first domain added to a subscription or webspace)" with the same information, so that the script also runs when the first standard domain is created.

Now every time you create a new domain, DKIM should automatically activate and save the public key in the customer directory in the folder specified in the script.
Note: automatic script should be executed only via Tools & Settings > Event Manager, manual execution of the script via the command line will not work.

Source: https://support.plesk.com/hc/en-us/articles/115000214973-How-to-get-the-DKIM-public-key-from-Plesk-if-DNS-is-not-installed