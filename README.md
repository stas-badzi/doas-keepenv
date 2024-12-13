# doas-keepenv
A bash script for running the doas command with keeping environment variables

# usage
Exactly like you would use doas exept changing the conf file (this program relies on editing /etc/doas.conf)

# bugs
Changes to /etc/doas.conf while the subprocess is running will be reverted 
