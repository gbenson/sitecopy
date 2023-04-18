set -exu

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install automake gettext
