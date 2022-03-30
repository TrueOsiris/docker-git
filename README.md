# docker-git<br>
Minimal Ubuntu 20.04 container with git functionalities, with some simplified commands

![Trueosiris Rules](https://img.shields.io/badge/trueosiris-rules-f08060) 
[![Docker Pulls](https://badgen.net/docker/pulls/trueosiris/git?icon=docker&label=pulls)](https://hub.docker.com/r/trueosiris/git/) 
[![Docker Stars](https://badgen.net/docker/stars/trueosiris/git?icon=docker&label=stars)](https://hub.docker.com/r/trueosiris/git/) 
[![Docker Image Size](https://badgen.net/docker/size/trueosiris/git?icon=docker&label=image%20size)](https://hub.docker.com/r/trueosiris/git/) 
![Github stars](https://badgen.net/github/stars/trueosiris/docker-git?icon=github&label=stars) 
![Github forks](https://badgen.net/github/forks/trueosiris/docker-git?icon=github&label=forks) 
![Github issues](https://img.shields.io/github/issues/TrueOsiris/docker-git)
![Github last-commit](https://img.shields.io/github/last-commit/TrueOsiris/docker-git)

### environment variables

| Environment Variable | Key | Description |
| -------------------- | ---------------------------- | ------------------------------------------------------------------------------- |
| TZ | Europe/Brussels | timezone for ntpdate |
| GITUSER | your_github_username | your github username |
| GITPASS | your_github_pass | your github password |

### volumes

| Volume                    | Container path                                                   |
| ------------------------- | ---------------------------------------------------------------- |
| github                    | /mnt/github

### links

github repo: https://github.com/TrueOsiris/docker-git <br>
dockerhub repo: https://hub.docker.com/repository/docker/trueosiris/git <br>

### log

log arrives in /var/log/git.log.<br>
