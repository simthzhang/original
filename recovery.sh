#!/bin/sh
#not installed
#qemu-kvm-tools
#qemu-kvm-common

#installed
#qemu-img qemu-kvm
#qemu-kvm-common 
package_dir=/home/qemu_replace_packs/RPMS/x86_64

remove_ori()
{
echo rpm -e jemalloc-3.6.0-1.el7.x86_64 --nodeps
rpm -e jemalloc-3.6.0-1.el7.x86_64 --nodeps
sleep 1
echo rpm -e qemu-img-10:2.5.1-1.2.el7.es.x86_64 --nodeps
rpm -e qemu-img-10:2.5.1-1.2.el7.es.x86_64 --nodeps
sleep 1
echo rpm -e qemu-kvm-common-10:2.5.1-1.2.el7.es.x86_64 --nodeps
rpm -e qemu-kvm-common-10:2.5.1-1.2.el7.es.x86_64 --nodeps
sleep 1
echo rpm -e qemu-kvm-2.5.1-1.2.el7.es.x86_64 --nodeps
rpm -e qemu-kvm-2.5.1-1.2.el7.es.x86_64 --nodeps
sleep 1
echo ======================================================

}

remove_lr()
{
echo rpm -e qemu-img-2.5.1-1.2.el7.centos.x86_64 --nodeps
rpm -e qemu-img-2.5.1-1.2.el7.centos.x86_64 --nodeps
echo rpm -e qemu-kvm-common --nodeps
rpm -e qemu-kvm-common --nodeps
echo rpm -e qemu-kvm-2.5.1-1.2.el7.centos.x86_64 --nodeps
rpm -e qemu-kvm-2.5.1-1.2.el7.centos.x86_64 --nodeps
echo rpm -e qemu-kvm-debuginfo qemu-kvm-tools --nodeps
rpm -e qemu-kvm-debuginfo qemu-kvm-tools --nodeps

}
install_lr()
{
rpm -Uvh /home/qemu_replace_packs/DEPS/jemalloc-3.6.0-1.el7.x86_64.rpm --force 

echo rpm -ivh $package_dir/qemu-img-2.5.1-1.2.el7.centos.x86_64.rpm
rpm -ivh $package_dir/qemu-img-2.5.1-1.2.el7.centos.x86_64.rpm

echo rpm -ivh $package_dir/qemu-kvm-common-2.5.1-1.2.el7.centos.x86_64.rpm
rpm -ivh $package_dir/qemu-kvm-common-2.5.1-1.2.el7.centos.x86_64.rpm

echo rpm -ivh $package_dir/qemu-kvm-2.5.1-1.2.el7.centos.x86_64.rpm
rpm -ivh $package_dir/qemu-kvm-2.5.1-1.2.el7.centos.x86_64.rpm

rpm -ivh $package_dir/qemu-kvm-debuginfo-2.5.1-1.2.el7.centos.x86_64.rpm
rpm -ivh $package_dir/qemu-kvm-tools-2.5.1-1.2.el7.centos.x86_64.rpm
}


recovery()
{

#rpm -e jemalloc-3.6.0-1.el7.x86_64 --nodeps
yum remove -y jemalloc-3.6.0-1.el7.x86_64
yum install -y jemalloc-3.6.0-1.el7.x86_64

#rpm -e qemu-img-10:2.5.1-1.2.el7.es.x86_64
rpm -e qemu-img-2.5.1-1.2.el7.centos.x86_64 --nodeps
yum install -y qemu-img-10:2.5.1-1.2.el7.es.x86_64


rpm -e qemu-kvm-2.5.1-1.2.el7.centos.x86_64 
yum install -y qemu-kvm-2.5.1-1.2.el7.es.x86_64

rpm -e qemu-kvm-common --nodeps
yum install -y qemu-kvm-common-10:2.5.1-1.2.el7.es.x86_64

#rpm -e qemu-kvm-debuginfo qemu-kvm-tools --nodeps
#rpm -ivh $package_dir/qemu-kvm-debuginfo-2.5.1-1.2.el7.centos.x86_64.rpm
#rpm -ivh $package_dir/qemu-kvm-tools-2.5.1-1.2.el7.centos.x86_64.rpm
}
remove_ori
install_lr
#remove_lr
#recovery
