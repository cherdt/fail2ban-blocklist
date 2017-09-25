#!/bin/bash

# Gets a blocklist of IPs from the Internet
# and bans them via fail2ban


# define constants
BLOCKLIST_URL="https://lists.blocklist.de/lists/ssh.txt"
BLOCKLIST_HASH_URL="https://lists.blocklist.de/lists/ssh.txt.md5"
BLOCKLIST_FILE="/etc/fail2ban/ssh-blocklist.txt"
BLOCKLIST_HASH="/etc/fail2ban/ssh-blocklist.txt.md5"


# Get the list of IP addresses to ban
# We need to retrieve a URL. Do we have wget or curl?
if [ -e /usr/bin/wget ];
then
    /usr/bin/wget --quiet --output-document=$BLOCKLIST_FILE $BLOCKLIST_URL
    /usr/bin/wget --quiet --output-document=$BLOCKLIST_HASH $BLOCKLIST_HASH_URL
elif [ -e /usr/bin/curl ];
then
    /usr/bin/curl --silent --output $BLOCKLIST_FILE $BLOCKLIST_URL
    /usr/bin/curl --silent --output $BLOCKLIST_HASH $BLOCKLIST_HASH_URL
else
	echo "ERROR: This script requires either curl or wget"
	exit 1
fi


# Verify MD5 hash
if ! echo "$(cat $BLOCKLIST_HASH)  $BLOCKLIST_FILE" | md5sum --status --check -
then
    echo "ERROR: MD5 checksum did not match"
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


exit 0