FROM ubuntu:20.04
LABEL maintainer="Tim Chaubet tim@chaubet.be"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt-get upgrade -y && \
    apt-get install -y 	apt-utils 
RUN apt-get install -y 	software-properties-common 
RUN apt-get install -y 	curl libcurl4
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
    apt update -y && \
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
COPY push /push
RUN chmod +x /push
WORKDIR /mnt/github
VOLUME ["/mnt/github"]
CMD ["/start.sh"]
