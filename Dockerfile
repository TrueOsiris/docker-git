FROM ubuntu:20.04
LABEL maintainer="Tim Chaubet tim@chaubet.be"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt-get upgrade -y 
RUN apt install -y 	vim \
			git \
			tzdata \
			cron \
			logrotate \
			docker-ce \
    && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

ENV TZ=Europe/Brussels

COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY gitpush /gitpush
RUN chmod +x /gitpush
COPY dockerpush /dockerpush
RUN chmod +x /dockerpush
WORKDIR /mnt/github
VOLUME ["/mnt/github"]
CMD ["/start.sh"]
