yum install -y wget curl unzip

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers

yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl nfs-utils
