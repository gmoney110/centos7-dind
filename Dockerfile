FROM centos

MAINTAINER Gmoney:Jinlin 

# install tools
RUN yum -y update ;\
    yum -y install epel-release python-pip git make wget sudo vim; \
    yum clean all  

# create user gmoney
RUN set -eux &&\ 
    useradd --create-home --no-log-init --shell /bin/bash gmoney \
    && echo 'gmoney:gmoney' | chpasswd \
    && groupadd docker \
    && usermod -aG docker gmoney \
    && usermod -aG root gmoney \
    && sed -i 's/root	ALL=(ALL) 	ALL/root	ALL=(ALL) 	ALL\gmoney	ALL=(ALL) 	NOPASSWD: ALL/g' /etc/sudoers \
    && echo 'source /etc/profile' >> /home/gmoney/.bashrc 

# install docker client
ARG DOCKERURL=https://download.docker.com/linux/static/stable/x86_64/docker-18.09.0.tgz
RUN set -eux &&\
    curl -fSL "$DOCKERURL" -o docker.tgz \
    && tar -xzvf docker.tgz \
    && mv docker/* /usr/local/bin/ \
    && rmdir docker \
    && rm docker.tgz \
    && chmod +x /usr/local/bin/docker 
   
WORKDIR /home/gmone/ci-gmoney

EXPOSE 8000 
   
CMD ["/bin/bash"]
