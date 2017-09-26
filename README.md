# fail2ban-blocklist
Block IP addresses provided by blocklist.de via fail2ban

## Install via Ansible
You can install this integration by:

* Cloning this git repository to the target host
* `cd fail2ban-blocklist/ansible`
* `ansible-playbook -i hosts -k install.yml`

## Further Details
Related blog post: https://osric.com/chris/accidental-developer/2017/09/using-blocklist-de-with-fail2ban/

Largely based on this forum post:
https://forum.blocklist.de/viewtopic.php?f=11&t=107
