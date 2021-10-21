#!/bin/bash

sed -i 's/ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ --containerd=\/run\/containerd\/containerd.sock/ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ -H tcp:\/\/0.0.0.0:2375 --containerd=\/run\/containerd\/containerd.sock/g' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker
