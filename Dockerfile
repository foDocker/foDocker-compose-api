FROM phusion/baseimage

COPY start.sh /start.sh

RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get install -y perl docker-engine make
RUN curl -L -k https://git.io/cpanm | perl - App::cpanminus

RUN cpanm Carton
COPY cpanfile /app/cpanfile
WORKDIR /app
RUN carton

RUN curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

VOLUME /var/run/docker.sock:/var/run/docker.sock:ro

COPY . /app
ENTRYPOINT [ "/start.sh" ]
CMD ["hypnotoad", "-f", "compose_api.pl"]
