FROM phusion/baseimage:focal-1.0.0

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

COPY veeam-nosnap_5.0.0.4318_amd64.deb /tmp

RUN apt-get update && apt-get install -y libfuse2 lvm2 libmagic1 dmidecode

RUN dpkg -i /tmp/veeam-nosnap_5.0.0.4318_amd64.deb 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/my_init.d
COPY veeamservice /etc/my_init.d/veeamservice.sh
RUN chmod +x /etc/my_init.d/veeamservice.sh


EXPOSE 10006/tcp 2500-3500

VOLUME ["/mnt"]

#CMD ["cd /etc/init.d && service veeamservice start && cd && bash"]

