set -exuo pipefail

echo 'assumeyes=1' >> /etc/yum.conf

yum install deltarpm
yum update

yum install neon

yum clean all
rm -rf /usr/share/doc/*
