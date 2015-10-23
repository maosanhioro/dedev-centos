if grep -q -i "release 6" /etc/redhat-release ; then
    rm /etc/udev/rules.d/70-persistent-net.rules
    mkdir /etc/udev/rules.d/70-persistent-net.rules
    rm /lib/udev/rules.d/75-persistent-net-generator.rules
fi

if grep -q -i "release 7" /etc/redhat-release ; then
    rm /etc/udev/rules.d/98-kexec.rules
fi

if [ -r /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
    sed -i 's/^HWADDR.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i 's/^UUID.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
fi

if [ -r /etc/sysconfig/network-scripts/ifcfg-enp0s3 ]; then
    sed -i 's/^HWADDR.*$//' /etc/sysconfig/network-scripts/ifcfg-enp0s3
    sed -i 's/^UUID.*$//' /etc/sysconfig/network-scripts/ifcfg-enp0s3
fi

yum -y remove gcc cpp kernel-devel kernel-headers perl
yum -y clean all

rm -rf /dev/.udev/
rm -rf /tmp/* || ! false
