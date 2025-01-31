#!/usr/bin/env bash

echo "Provisioning guest VM..."

sudo apt-get update
sudo apt-get -y upgrade

# ----- Essential packages -----
echo "******************************************"
echo "*** Installing common network packages ***"
echo "******************************************"
sudo apt-get install -y --no-install-recommends --fix-missing \
  bridge-utils \
  curl \
  git \
  iperf \
  iproute2 \
  net-tools \
  openvswitch-switch \
  patch \
  python3 \
  python3-pip \
  python3-virtualenv \
  tcpdump \
  traceroute \
  unzip \
  vim \
  virtualenv \
  wget \
  xauth \
  xterm

# ---- Python utils ----
sudo pip3 install scapy ipaddr psutil grpcio

# ----- Mininet -----
echo "**************************"
echo "*** Installing Mininet ***"
echo "**************************"
cd ~
git clone https://github.com/mininet/mininet.git
cd mininet
# Install Mininet itself (-n), the OpenFlow reference controller (-f),
# and Open vSwitch (-v)
PYTHON=python3
sudo util/install.sh -fnv

# ---- RYU SDN controller ----
echo "**********************"
echo "*** Installing RYU ***"
echo "**********************"
cd ~

# Python 3.9 needed for ryu
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.9
sudo apt install python3.9-distutils

virtualenv -p /usr/bin/python3.9 ryuenv
source ~/ryuenv/bin/activate
pip install ryu
# Downgrade eventlet lib (otherwise bug with Ryu...)
pip install eventlet==0.30.2
deactivate

# ----- P4 tools -----
echo "******************************"
echo "*** Installing P4 packages ***"
echo "******************************"
cd ~
# Add repository with P4 packages
# https://build.opensuse.org/project/show/home:p4lang

echo "deb https://download.opensuse.org/repositories/home:/p4lang/xUbuntu_22.04/ /" | sudo tee /etc/apt/sources.list.d/home:p4lang.list
wget -qO - "http://download.opensuse.org/repositories/home:/p4lang/xUbuntu_22.04/Release.key" | sudo apt-key add -

sudo apt-get update

sudo apt-get install -q -y --no-install-recommends --fix-missing \
  p4lang-p4c \
  p4lang-bmv2 \
  p4lang-pi

echo "*****************************************"
echo "*** Installing P4-Mininet environment ***"
echo "*****************************************"
cd ~
git clone https://github.com/sdn-labs-ut3/p4-mininet.git

# ---- End ----
cd ~
echo "**** DONE PROVISIONING VM ****"

sudo reboot
