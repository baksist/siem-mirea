FROM ubuntu:16.04

#Gen Env
ENV LVERS libpcap-1.7.4
ENV DVERS daq-2.0.6
ENV HOST_INT ""
ENV HOST_NAME ""

#Snort Env
ENV SNVERS 2.9.9.0
ENV SNORT_NET ""

# Install Dependencies
RUN apt-get update -qq
RUN apt-get -y install \
        wget \
        build-essential \
        libtool \
        automake \
        gcc \
        flex \
        bison \
        libnet1 \
        libnet1-dev \
        libpcre3 \
        libpcre3-dev \
        autoconf \
        libcrypt-ssleay-perl \
        libwww-perl \
        git \
        zlib1g \
        zlib1g-dev \
        libssl-dev \
        libmysqlclient-dev \
        imagemagick \
        wkhtmltopdf \
        libyaml-dev \
        libxml2-dev \
        libxslt1-dev \
        openssl \
        libreadline6-dev \
        unzip \
        libcurl4-openssl-dev \
        libapr1-dev \
        libaprutil1-dev \
        supervisor \
        net-tools \
        gettext-base

#Install LIBDNET - LIBPCAP
RUN apt-get install -y libdumbnet-dev libpcap-dev

#Install DAQ
RUN cd /tmp \
    && wget https://snort.org/downloads/snort/$DVERS.tar.gz \
    && tar zxf $DVERS.tar.gz \
    && cd $DVERS \
    && ./configure \
    && make && make install \
    && ldconfig

#Install SNORT
RUN cd /tmp \
    && wget https://snort.org/downloads/snort/snort-$SNVERS.tar.gz \
    && tar zxf snort-$SNVERS.tar.gz \
    && cd snort-$SNVERS \
    && ./configure --enable-sourcefire \
    && make && make install

#User/group/dir for Snort
RUN groupadd snort \
    && useradd snort -d /var/log/snort -s /sbin/nologin -c SNORT_IDS -g snort \
    && mkdir -p /var/log/snort \
    && chown snort:snort /var/log/snort -R \
    && mkdir -p /etc/snort \
    && cd /tmp/snort-$SNVERS \
    && cp -r etc/* /etc/snort/
  
#Snort
RUN cd /etc/snort \
    && chown -R snort:snort * \
    && mkdir -p /usr/local/lib/snort_dynamicrules \
    && mkdir /etc/snort/rules \
    && touch /etc/snort/rules/so_rules.rules \
    && touch /etc/snort/rules/local.rules \
    && touch /etc/snort/rules/white_list.rules


#Clean APT
RUN apt-get clean \
    && rm -rf /var/cache/apt/*

RUN rm -rf /tmp/*

COPY docker /docker

CMD ["/bin/bash", "/docker/scripts/entrypoint.sh", "start-stack"]