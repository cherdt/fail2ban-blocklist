# Ansible playbook for fail2ban-blocklist

## Install

Run the playbook to install the fail2ban blocklist integration. This will install fail2ban if it is not already present:

`ansible-playbook -i hosts -k install.yml`

## Uninstall

Run the uninstall playbook to remove the files. This does not remove fail2ban:

`ansible-playbook -i hosts -k uninstall.yml`