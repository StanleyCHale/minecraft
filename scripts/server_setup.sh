#!/bin/bash
cat >/etc/systemd/system/minecraft_server.service <<EOL
[Unit]
Description=PaperMC 1.20.4 Server
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
WorkingDirectory=/home/ec2-user
SuccessExitStatus=143
TimeoutStopSec=10
Restart=always
RestartSec=1
User=ec2-user
ExecStart=/bin/bash /home/ec2-user/scripts/launch.sh

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload

systemctl enable minecraft_server
systemctl start minecraft_server
