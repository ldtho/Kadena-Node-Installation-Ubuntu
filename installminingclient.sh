
echo 'Start installing Mining-client to connect to your node'
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
./chainweb-mining-client --public-key $publickey --node whereami:1848 --stratum-port 1917 --account $publickey --print-config > config.yml
#./chainweb-mining-client --config-file config.yml

# Generate systemd service
touch /etc/systemd/system/kadena-mining-client.service
cat <<EOF > /etc/systemd/system/kadena-mining-client.service
[Unit]
Description=Kadena Mining Client

[Service]
User=root
KillMode=process
KillSignal=SIGINT
WorkingDirectory=/root/kda/chainweb-mining-client
ExecStart=/root/kda/chainweb-mining-client/chainweb-mining-client --config-file=/root/kda/chainweb-mining-client/config.yml
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
