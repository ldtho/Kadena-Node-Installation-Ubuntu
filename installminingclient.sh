
echo 'Start installing Mining-client to connect to your node'

read -e -p "Please enter your node's external IP adress: " whereami
if [[ $whereami == "" ]]; then
    decho "WARNING: No IP given, exiting!"
    exit 3
fi

read -e -p "Please enter your Public Key (the part after the 'k:' in your account: " publickey
if [[ $publickey == "" ]]; then
    decho "WARNING: No public key given, exiting!"
    exit 3
fi

sudo apt install cabal-install
cabal update

# Clone code
cd /root/kda | git clone https://github.com/kadena-io/chainweb-mining-client/
cd chainweb-mining-client
cabal update
sudo apt-get install libghc-zlib-dev  libghc-zlib-bindings-dev

cabal build
cabal install chainweb-mining-client --overwrite-policy=always
ln -s ~/.cabal/bin/chainweb-mining-client chainweb-mining-client

# Generate config
./chainweb-mining-client --public-key $publickey --node whereami:1848 --stratum-port 1917 --account k:$publickey --print-config > config.yml
#./chainweb-mining-client --config-file config.yml

# Generate systemd service
touch /etc/systemd/system/kadena-mining-client.service
cat <<EOF > /etc/systemd/system/kadena-mining-client.service
[Unit]
Description=Kadena Mining Client

[Service]
User=root
KillMode=control-group
KillSignal=SIGINT
WorkingDirectory=/root/kda/chainweb-mining-client
ExecStart=cabal run chainweb-mining-client -- --config-file=/root/kda/chainweb-mining-client/config.yml
Restart=always
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kadena-mining-client
systemctl stop kadena-mining-client
systemctl start kadena-mining-client
echo 'Type "journalctl -fu kadena-mining-client" to see the node log.'
