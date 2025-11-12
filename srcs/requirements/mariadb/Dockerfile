FROM debian:latest

RUN apt-get update && apt-get install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh

CMD ["/tmp/setup.sh"]