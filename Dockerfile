FROM ubuntu:22.04
LABEL maintainer="Tim Chaubet tim@chaubet.be"
USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y 	apt-utils \
                        openssh-server \
                        gpg \
                        wget
RUN apt-get install -y 	software-properties-common 
RUN apt-get install -y 	curl libcurl4
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | \
    tee /usr/share/keyrings/docker-ce-archive-keyring.gpg >/dev/null && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-ce-archive-keyring.gpg] \
        https://download.docker.com/linux/ubuntu jammy stable" | \
        tee /etc/apt/sources.list.d/docker-ce.list >/dev/null && \
    apt-get update -y && \
    apt-get upgrade -y
RUN apt-get install -y 	vim \
			git \
			tzdata \
			cron \
			logrotate 
RUN apt-get install -y  docker-ce
RUN apt-get install -y 	awscli 
RUN wget http://launchpadlibrarian.net/571591066/amazon-ecr-credential-helper_0.5.0-1build1_amd64.deb \
    && dpkg -i amazon-ecr-credential-helper_0.5.0-1build1_amd64.deb \
    && rm amazon-ecr-credential-helper_0.5.0-1build1_amd64.deb
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get update \
    && apt-get install -y git-lfs \
    && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean

ENV TZ=Europe/Brussels

COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY gitpush /gitpush
RUN chmod +x /gitpush
COPY dockerpush /dockerpush
RUN chmod +x /dockerpush
COPY push /push
RUN chmod +x /push
COPY awspush /awspush
RUN chmod +x /awspush

VOLUME ["/mnt/repos"]
WORKDIR /mnt/repos

CMD ["/start.sh"]
