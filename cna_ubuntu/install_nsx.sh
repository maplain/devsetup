#!/bin/bash
git clone https://gitreview.eng.vmware.com/nsx-ujo
pushd nsx-ujo
# install python-dev
sudo apt-get install -y python-dev
# install pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
# install dependencies
sudo pip install -r requirements.txt
sudo python setup.py install
popd
