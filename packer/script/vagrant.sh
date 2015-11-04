#!/bin/bash -eux

date > /etc/vagrant_box_build_time

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}
VAGRANT_KEY_URL=https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub

if ! id -u $SSH_USER >/dev/null 2>&1; then
    /usr/sbin/groupadd $SSH_USER
    /usr/sbin/useradd $SSH_USER -g $SSH_USER -G wheel
    echo "${SSH_PASSWORD:-vagrant}"|passwd --stdin $SSH_USER
fi

echo "${SSH_USER}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

mkdir -pm 700 $SSH_USER_HOME/.ssh
wget --no-check-certificate "${VAGRANT_KEY_URL}" -O $SSH_USER_HOME/.ssh/authorized_keys
chmod 0600 $SSH_USER_HOME/.ssh/authorized_keys
chown -R $SSH_USER:$SSH_USER $SSH_USER_HOME/.ssh
