FROM ubuntu

USER root
# Enable apt repositories.

RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# Enable systemd.
RUN apt-get update ; \
    apt-get install -y systemd systemd-sysv ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    cd /lib/systemd/system/sysinit.target.wants/ ; \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/* ; \
    rm -f /lib/systemd/system/plymouth* ; \
    rm -f /lib/systemd/system/systemd-update-utmp*

VOLUME [ "/sys/fs/cgroup" ]

#RUN sed -i 's/override_install_langs/#override_install_langs/g' /etc/yum.conf
#RUN yum update -y glibc-common
RUN apt-get update && apt-get install -y libfuse2 lvm2 libmagic1 dmidecode openssh-server cron lvm2-dbusd

COPY veeam-nosnap_5.0.0.4318_amd64.deb /tmp

#RUN localedef -i en_US -f UTF-8 en_US.UTF-8

#ENV LC_ALL en_US.UTF-8
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US.UTF-8

RUN dpkg -i /tmp/veeam-nosnap_5.0.0.4318_amd64.deb 

#RUN   yum install -y \
#        openssh-clients openssh-server \
#        perl \
#	libsoap-lite-perl \
#	perl-Data-Dumper \
#	mlocate \
#	libfuse2 lvm2 libmagic1 dmidecode  init sudo openssl sysvinit-tools

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

CMD ["/usr/sbin/init"]
