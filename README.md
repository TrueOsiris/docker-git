# docker-git<br>
Minimal Ubuntu 20.04 sandbox container with git functionalities, with some simplified commands.<br>
Functionality: minimal container with vim & git to work on docker images.<br>
Use at own risk, as the username/pass are docker parameters.

![Trueosiris Rules](https://img.shields.io/badge/trueosiris-rules-f08060) 
[![Docker Pulls](https://badgen.net/docker/pulls/trueosiris/git?icon=docker&label=pulls)](https://hub.docker.com/r/trueosiris/git/) 
[![Docker Stars](https://badgen.net/docker/stars/trueosiris/git?icon=docker&label=stars)](https://hub.docker.com/r/trueosiris/git/) 
[![Docker Image Size](https://badgen.net/docker/size/trueosiris/git?icon=docker&label=image%20size)](https://hub.docker.com/r/trueosiris/git/) 
![Github stars](https://badgen.net/github/stars/trueosiris/docker-git?icon=github&label=stars) 
![Github forks](https://badgen.net/github/forks/trueosiris/docker-git?icon=github&label=forks) 
![Github issues](https://img.shields.io/github/issues/TrueOsiris/docker-git)
![Github last-commit](https://img.shields.io/github/last-commit/TrueOsiris/docker-git)

### setup
- At first start of the container, a credentials file will be created in your volume mounted to container path /mnt/github<br>
  The container will be automatically stopped.<br>
- Complete the credentials.txt file<br>
- Restart the container
- Run the docker container and the generated ssh key will be in the docker log.
    
    docker logs -f git

- add this to your github.com account via Settings -> SSH and GPG keys<br>

Now you can connect to the container:

    docker exec -it git /bin/bash

and use commands gitpush & dockerpush<br>
First, clone your git repository and edit/modify

    git clone https://github.com/yourgituser/yourgitrepo
    cd yourgitrepo

Then you can use 

    gitpush [comment] [tag]

e.g.

    gitpush
    gitpush "upgraded python" 1.3	
    gitpush "adapted the README.md" main

Create your docker repository on the docker hub.<br>
After that you can build + push from this container

    dockerpush <repository>[:tag]

e.g.

    dockerpush yourdockerrepo
    dockerpush yourdockerrepo:1.0

Or do it all at once with push

    push <docker-repository>[:docker-tag]

e.g.

    push yourdockerrepo:1.0


### environment variables

| Environment Variable | Key | Description |
| -------------------- | ---------------------------- | ------------------------------------------------------------------------------- |
| TZ | Europe/Brussels | timezone for ntpdate |

### credentials.txt file will contain the following variables (do not add spaces!)

| credentials.txt variable | Description |
| ------------------------ | ---------------------------------------------------------------------------------------------------------- |
| GITUSER | your github username / repository name |
| GITMAIL | your github email / signin account |
| DOCKERUSER | your docker user account |
| DOCKERPASS | your docker password |

### volumes

| Volume                    | Container path                                                   |
| ------------------------- | ---------------------------------------------------------------- |
| github                    | /mnt/github |
| /var/run/docker.sock | /var/run/docker.sock |

### links

github repo: https://github.com/TrueOsiris/docker-git <br>
dockerhub repo: https://hub.docker.com/repository/docker/trueosiris/git <br>

### log

log arrives in /var/log/git.log.<br>
README.md will be updated on the docker hub using peterevans/dockerhub-description, so a shoutout to him!
