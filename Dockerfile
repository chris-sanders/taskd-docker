#
# Dockerfile for taskd
#
FROM alpine

ENV TASKDDATA /var/taskd

RUN apk add --update build-base \
                     cmake \
                     gnutls \
                     gnutls-dev \
                     gnutls-utils \
                     libstdc++ \
    && wget -O- http://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz | tar xz \
        && cd libuuid-1.0.3 \
        && ./configure --prefix=/usr \
        && make install \
        && cd .. \
        && rm -rf libuuid-1.0.3 \
    && wget -O- http://taskwarrior.org/download/taskd-1.1.0.tar.gz | tar xz \
        && cd taskd-1.1.0 \
        && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=release . \
        && make install \
	&& cd ../ \
        && rm -rf taskd-1.1.0 \
    && apk del --purge build-base \
                       cmake \
                       gnutls-dev \
    && rm -rf /var/cache/apk/* 

COPY ./pki $TASKDDATA/pki
COPY ./start.sh /start.sh

RUN taskd init \
    && taskd config --force client.cert $TASKDDATA/pki/api.cert.pem \
    && taskd config --force client.key $TASKDDATA/pki/api.key.pem \
    && taskd config --force server.cert $TASKDDATA/pki/server.cert.pem \
    && taskd config --force server.key $TASKDDATA/pki/server.key.pem \
    && taskd config --force server.crl $TASKDDATA/pki/server.crl.pem \
    && taskd config --force ca.cert $TASKDDATA/pki/ca.cert.pem \
    && taskd config --force log /dev/stdout \
    && taskd config --force pid.file /run/taskd.pid \
    && taskd config --force server 0.0.0.0:53589

VOLUME $TASKDDATA
EXPOSE 53589

CMD ["./start.sh"]
