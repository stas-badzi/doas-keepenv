# doas-keepenv
A bash script for running the doas command with keeping environment variables

# usage
Exactly like you would use doas, but some features might not work (normal `doas dorootthings` works rest is not tested)

# build package from sourse
`make v=1.0`

# install package
(`su -c`/`doas`/`sudo`) `make install v=1.0`

# notice
This script changes to /etc/doas.conf while the subprocess is running and it will will be reverted only after the subprocess exits
