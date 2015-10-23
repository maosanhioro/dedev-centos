#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
mount -o loop /home/$SSH_USER/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt
rm -rf /home/$SSH_USER/VBoxGuestAdditions_$VBOX_VERSION.iso
