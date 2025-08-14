FROM nginx:1.28-alpine

RUN apk update && apk add --no-cache certbot certbot-nginx bash

RUN mkdir -p /var/www/certbot

COPY nginx-http.conf /etc/nginx/conf.d/000-http.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./crontab.txt /etc/crontabs/root

# Let's Encrypt 인증서 대상 설정
ENV DOMAINS="api-v2.khlug.org"
ENV EMAIL=we_are@khlug.org

EXPOSE 80 443

CMD ["/bin/bash", "/entrypoint.sh"]
