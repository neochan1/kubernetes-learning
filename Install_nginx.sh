#!/bin/bash
yum -y install wget 
wget https://nginx.org/download/nginx-1.24.0.tar.gz 
tar zxvf nginx-1.24.0.tar.gz 
cd nginx-1.24.0
yum install -y pcre pcre-devel openssl openssl-devel zlib zlib-devel
yum install -y gcc gcc-c++
./configure --prefix=/usr/local/nginx
make && make install 
cat > /usr/lib/systemd/system/nginx.service << EOF
[Unit]
Description=nginx
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx -c  /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
ExecQuit=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nginx
systemctl start nginx
systemctl stop firewalld
systemctl disable firewalld