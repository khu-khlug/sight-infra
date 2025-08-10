FROM nginx:1.28-alpine

RUN apk update && apk add --no-cache certbot certbot-nginx bash curl

# HTTPS 포함 nginx.conf 복사
COPY ./nginx.conf /etc/nginx/nginx.conf

# 최초 인증서 발급 스크립트
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# certbot 자동 갱신 cron 등록
COPY ./crontab.txt /etc/crontabs/root

EXPOSE 80 443

CMD ["/bin/bash", "/entrypoint.sh"]
