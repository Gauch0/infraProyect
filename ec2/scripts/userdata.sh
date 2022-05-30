#!/bin/bash -v

# UPDATE

sudo apt-get upgrade
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl tree

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# #INSTALL DOCKER
curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker ubuntu
sudo systemctl enable docker
cat <<EOF >/etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

#GET IMAGE

docker pull gauch0/endava-api
docker run -d --name endava -p 8080:8080 gauch0/endava-api
