# Kadena Node Installation

**Note**: this guide assumes your machine is running Ubuntu 20.04, that you have
`sudo` privileges, that you've bought a proper Domain Name and are pointing it
at the Public IP Address of your machine.

### Installation 

```bash
wget https://raw.githubusercontent.com/kadena-community/node-setup/master/installnode.sh
sudo bash installnode.sh
```
### Installation without proper Domain Name

```bash
wget https://raw.githubusercontent.com/kadena-community/node-setup/master/installnodeip.sh
sudo bash installnodeip.sh
```

And follow the instructions.

A log of the install is stored in `/tmp/install.log` if there were any errors.

### Update

```bash
cd /root/kda
systemctl stop kadena-node
rm chainweb-node
wget https://github.com/kadena-io/chainweb-node/releases/download/2.11/chainweb-2.11.ghc-8.10.7.ubuntu-20.04.65becb6.tar.gz
tar -xvf chainweb-2.11.ghc-8.10.7.ubuntu-20.04.65becb6.tar.gz
systemctl start kadena-node
```
