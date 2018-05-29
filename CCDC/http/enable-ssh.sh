#!/usr/bin/env bash

PASSWORD=$(/usr/bin/openssl passwd -crypt 'password')

echo "==> Enabling SSH"
# Admin user config
/usr/bin/useradd --password ${PASSWORD} --comment 'administrator User' --create-home --user-group administrator
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/10_administrator
echo 'administrator ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_administrator
/usr/bin/chmod 0440 /etc/sudoers.d/10_administrator
/usr/bin/systemctl start sshd.service