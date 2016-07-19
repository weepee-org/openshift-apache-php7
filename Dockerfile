FROM alpine:3.4
MAINTAINER Joeri van Dooren <ure@mororless.be>

RUN apk --no-cache add --update tar rsync openssl python ca-certificates openssl ssmtp nodejs git mysql-client openssh-client && update-ca-certificates && apk --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ --allow-untrusted --update add icu-libs libwebp && apk --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --update add icu-libs libwebp php7-apache2 curl php7 php7-curl php7-zip php7-common php7-wddx php7-xmlrpc php7-xml php7 php7-zlib php7-tidy php7-xsl php7-xmlreader php7-sysvmsg php7-sysvsem php7-pgsql php7-pdo_pgsql php7-session php7-pspell php7-shmop php7-sqlite3 php7-posix php7-sysvshm php7-snmp php7-sockets php7-phar php7-soap php7-odbc php7-pdo_mysql php7-pcntl php7-json php7-ldap php7-mcrypt php7-pdo_odbc php7-openssl php7-mysqli php7-intl php7-pdo_dblib php7-mysqlnd php7-opcache php7-pdo php7-mbstring php7-gmp php7-gettext php7-ctype php7-dom php7-calendar php7-enchant php7-dba php7-bz2 php7-gd php7-iconv && rm -f /var/cache/apk/* && \

apk upgrade && \

curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/local/bin --filename=composer && \
mkdir /app && chmod a+rwx /app && \
mkdir /run/apache2/ && \
chmod a+rwx /run/apache2/ && \
npm install -g bower && \
mkdir /.composer && chmod a+rwx /.composer && \
ln -s /usr/bin/php7 /usr/bin/php

# Apache config
ADD httpd.conf /etc/apache2/httpd.conf

# ADD ssmtp
COPY ssmtp /etc/ssmtp

# Run scripts
ADD scripts/run.sh /scripts/run.sh

RUN mkdir /scripts/pre-exec.d && \
mkdir /scripts/pre-init.d && \
chmod -R 755 /scripts && chmod -R a+rw /etc/ssmtp && chmod a+rw /etc/passwd

# Your app
ADD app/index.php /app/index.php

# Exposed Port
EXPOSE 8080

# VOLUME /app
WORKDIR /app

ENTRYPOINT ["/scripts/run.sh"]

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Alpine linux based Apache PHP7 Container" \
      io.k8s.display-name="alpine apache php7" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,apache,php7" \
      io.openshift.min-memory="1Gi" \
      io.openshift.min-cpu="1" \
      io.openshift.non-scalable="false"
