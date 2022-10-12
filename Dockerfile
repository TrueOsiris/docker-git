FROM ubuntu:22.04
LABEL maintainer="Tim Chaubet tim@chaubet.be"
USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt-get upgrade -y && \
    apt-get install -y 	apt-utils \
                        openssh-server       
RUN apt-get install -y 	software-properties-common 
RUN apt-get install -y 	curl libcurl4
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key --keyring /etc/apt/trusted.gpg.d/docker-apt-key.gpg add && \
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | \
    tee /usr/share/keyrings/docker-ce-archive-keyring.gpg 
RUN echo "deb [arch=amd64] signed-by=/usr/share/keyrings/docker-ce-archive-keyring.gpg \
        https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker-ce.list && \
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
