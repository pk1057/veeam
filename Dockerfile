FROM centos:centos7

USER root

# Use baseimage-docker's init system.
#CMD ["/sbin/my_init"]libfuse2 lvm2 libmagic1 dmidecode  init sudo openssl


#COPY veeam-nosnap_5.0.0.4318_amd64.deb /tmp

#ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"

RUN   yum install -y \
        openssh-server \
        perl \
	libsoap-lite-perl \
	perl-Data-Dumper \
	mlocate \
	augeas \
	libfuse2 lvm2 libmagic1 dmidecode  init sudo openssl

RUN    mkdir /root/.ssh && \
    chmod 700 /root/.ssh && \
    usermod -p '*' root 

RUN    augtool set /etc/ssh/sshd_config/Ciphers/1 aes256-cbc && \
    augtool set /etc/ssh/sshd_config/Ciphers/2 aes192-cbc && \
    augtool set /etc/ssh/sshd_config/Ciphers/3 aes128-cbc && \
    augtool set /etc/ssh/sshd_config/Ciphers/4 aes256-ctr && \
    augtool set /etc/ssh/sshd_config/Ciphers/5 aes192-ctr && \
    augtool set /etc/ssh/sshd_config/Ciphers/6 aes128-ctr && \
    augtool set /etc/ssh/sshd_config/KexAlgorithms/1 diffie-hellman-group-exchange-sha256 && \
    augtool set /etc/ssh/sshd_config/KexAlgorithms/2 diffie-hellman-group-exchange-sha1 && \
    augtool set /etc/ssh/sshd_config/KexAlgorithms/3 diffie-hellman-group14-sha1 && \
    augtool set /etc/ssh/sshd_config/KexAlgorithms/4 diffie-hellman-group1-sha1 && \
    augtool set /etc/ssh/sshd_config/MACs/1 hmac-sha2-512 && \
    augtool set /etc/ssh/sshd_config/MACs/2 hmac-sha2-256 && \
    augtool set /etc/ssh/sshd_config/MACs/3 hmac-md5 && \
    augtool set /etc/ssh/sshd_config/MACs/4 hmac-sha1 && \
    augtool set /etc/ssh/sshd_config/PasswordAuthentication yes && \
    augtool set /etc/ssh/sshd_config/PermitRootLogin yes

RUN rm -rf /var/log/* && \
    mkdir -p /var/run/sshd


COPY docker-entrypoint /usr/local/bin/
RUN chmod 775 /usr/local/bin/docker-entrypoint

EXPOSE 22

RUN useradd -rm -d /home/veeam-backup -s /bin/bash -g root -p "$(openssl passwd -1 \#Backup01)" veeam-backup
run echo "veeam-backup ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#RUN dpkg -i /tmp/veeam-nosnap_5.0.0.4318_amd64.deb 

#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN touch /usr/share/doc/veeam/3rdPartyNotices.txt
#RUN touch /usr/share/doc/veeam/EULA

EXPOSE 10006/tcp 2500-2600

VOLUME ["/mnt"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

CMD [ "/usr/sbin/sshd", "-D", "-e"]

