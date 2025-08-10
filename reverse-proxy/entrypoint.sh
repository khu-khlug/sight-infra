#!/bin/bash
set -e

# 백그라운드에서 nginx 시작
nginx &

# 인증서 없으면 발급
if [ ! -f /etc/letsencrypt/live/khlug.org/fullchain.pem ]; then
    echo ">>> Issuing initial certificate..."
    certbot certonly --nginx --non-interactive --agree-tos \
        -m we_are@khlug.org \
        -d khlug.org \
        -d www.khlug.org
    echo ">>> Certificate issued. Reloading nginx..."
    nginx -s reload
else
    echo ">>> Certificate already exists. Skipping issuance."
fi

# nginx 포그라운드 유지
nginx -g 'daemon off;'
