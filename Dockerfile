FROM centos/systemd

USER root

RUN   yum install -y \
        openssh-clients openssh-server \
        perl \
	libsoap-lite-perl \
	perl-Data-Dumper \
	mlocate \
	libfuse2 lvm2 libmagic1 dmidecode  init sudo openssl sysvinit-tools

RUN    mkdir /root/.ssh && \
    chmod 700 /root/.ssh && \
    usermod -p '*' root 

RUN rm -rf /var/log/* && \
    mkdir -p /var/run/sshd

COPY sshd_config /etc/ssh/sshd_config
COPY docker-entrypoint /usr/local/bin/
RUN chmod 775 /usr/local/bin/docker-entrypoint

EXPOSE 22

RUN useradd -rm -d /home/veeam-backup -s /bin/bash -g root -p "$(openssl passwd -1 \#Backup01)" veeam-backup
RUN echo "veeam-backup ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

EXPOSE 10006/tcp 2500-2550/tcp 2500-2550/udp 6162/tcp
VOLUME ["/etc/ssh", "/root/.ssh/authorized_keys"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

CMD ["/lib/systemd/systemd"]
