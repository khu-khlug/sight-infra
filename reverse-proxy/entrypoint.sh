#!/usr/bin/env bash
set -euo pipefail

: "${EMAIL:?EMAIL required}"
: "${DOMAINS:?DOMAINS required}" # comma-separated

crond
mkdir -p /var/www/certbot /etc/nginx/conf.d /run/nginx

issue_cert() {
  local domain="$1"
  local live="/etc/letsencrypt/live/${domain}"
  if [ ! -f "${live}/fullchain.pem" ] || [ ! -f "${live}/privkey.pem" ]; then
    certbot certonly --webroot -w /var/www/certbot \
      -d "${domain}" --email "${EMAIL}" --agree-tos --no-eff-email --non-interactive
  fi
}

# 도메인 별 SSL 서버 블록 생성
gen_ssl_server_block() {
  local domain="$1" upstream="${2:-http://your-upstream:8080}"
  cat > "/etc/nginx/conf.d/ssl-${domain}.conf" <<EOF
server {
  listen 80;
  server_name ${domain};
  location /.well-known/acme-challenge/ { root /var/www/certbot; }
  location / { return 301 https://${domain}\$request_uri; }
}

server {
  listen 443 ssl http2;
  server_name ${domain};

  ssl_certificate     /etc/letsencrypt/live/${domain}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${domain}/privkey.pem;
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

  location / {
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_pass ${upstream};
  }
}
EOF
}

# 80만으로 먼저 기동
nginx

# `$DOMAINS`에 저장된 도메인 목록을 `,`로 분리하여 순회
IFS=',' read -r -a arr <<< "$DOMAINS"
for d in "${arr[@]}"; do
  d="$(echo "$d" | xargs)"  # trim
  issue_cert "$d"
  gen_ssl_server_block "$d"
done

nginx -s reload

# 포그라운드
exec nginx -g 'daemon off;'
