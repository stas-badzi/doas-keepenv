# doas-keepenv
A bash script for running the doas command with keeping environment variables

# usage
Exactly like you would use doas exept changing the conf file (this program relies on editing /etc/doas.conf)

# notice
This script changes to /etc/doas.conf while the subprocess is running and it will will be reverted only after the subprocess exits
