FROM caddy:2.9.1-alpine

RUN apk add --no-cache curl

COPY Caddyfile /etc/caddy/Caddyfile

RUN CF_IPS=$(curl -sf https://www.cloudflare.com/ips-v4/ | tr '\n' ' '); \
    if [ -n "$CF_IPS" ]; then \
        sed -i "s|.*TRUSTED_PROXIES_CLOUDFLARE_IPS_V4.*|\t\ttrusted_proxies ${CF_IPS}|" /etc/caddy/Caddyfile; \
    else \
        echo "WARNING: Cloudflare IP 목록을 가져오지 못했습니다. 동방 와이파이 감지 기능이 비활성화됩니다." >&2; \
    fi
RUN apk del curl

EXPOSE 80 443

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
