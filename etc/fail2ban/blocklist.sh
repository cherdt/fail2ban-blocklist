#!/bin/bash

# Gets a blocklist of IPs from the Internet
# and bans them via fail2ban


# define constants
BLOCKLIST_URL="https://lists.blocklist.de/lists/ssh.txt"
BLOCKLIST_URL_HASH="https://lists.blocklist.de/lists/ssh.txt"
BLOCKLIST_FILE="/etc/fail2ban/ssh-blocklist.txt"


# Get the list of IP addresses to ban
# We need to retrieve a URL. Do we have wget or curl?
if [ -e /usr/bin/wget ];
then
    /usr/bin/wget --quiet --output-document=$BLOCKLIST_FILE $BLOCKLIST_URL
elif [ -e /usr/bin/curl ];
then
    /usr/bin/curl --silent --output $BLOCKLIST_FILE $BLOCKLIST_URL
else
	echo "This script requires either curl or wget"
	exit 1
fi


# iterate over the list of IP addresses and ban each
while read IP_ADDRESS
do
	# make sure the line contains an IP address
	if echo $IP_ADDRESS | grep --quiet '^[1-9][0-9]\{0,2\}\.[1-9][0-9]\{0,2\}\.[1-9][0-9]\{0,2\}\.[1-9][0-9]\{0,2\}$';
	then
	    /usr/bin/fail2ban-client set blocklist banip $IP_ADDRESS
	fi
done < $BLOCKLIST_FILE