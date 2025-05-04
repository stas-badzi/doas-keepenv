# doas-keepenv
A bash script for running the doas command with keeping environment variables

# usage
Exactly like you would use doas, but some features might not work (standard `doas dorootthings` works rest is not tested)

# build package from sourse
make v=1.0

# install package
(`su -c`/`doas`/`sudo`) make install v=1.0 

# bugs
Changes to /etc/doas.conf while the subprocess is running will be reverted 
