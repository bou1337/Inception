FROM debian:bullseye
RUN apt-get update && apt-get install -y nginx openssl && \
mkdir -p /etc/ssl/certs/ && \
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/certs/iait-bou.42.fr.key -out /etc/ssl/certs/iait-bou.42.fr.cert \
-subj "/CN=iait-bou.42.fr"

WORKDIR /var/www/html

COPY conf/nginx.conf /etc/nginx/sites-enabled/nginx.conf

RUN chmod 777 /etc/nginx/sites-enabled/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
