FROM ubuntu:20.04
LABEL maintainer="Tim Chaubet tim@chaubet.be"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt-get upgrade -y && \
    apt install -y 	vim \
			git \
			tzdata \
			cron \
			logrotate \
    && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

ENV TZ=Europe/Brussels

COPY start.sh /start.sh
RUN chmod +x /start.sh
WORKDIR ["/mnt/github"]
VOLUME ["/mnt/github"]
CMD ["/start.sh"]
