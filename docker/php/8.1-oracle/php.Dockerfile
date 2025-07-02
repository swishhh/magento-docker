FROM ubuntu:20.04

ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NOWARNINGS="yes"

RUN ln -snf /usr/share/zoneinfo/Europe/Kiev /etc/localtime && echo Europe/Kiev > /etc/timezone

RUN apt-get clean && apt-get -y update && apt-get install -y locales \
    curl \
    ca-certificates \
    software-properties-common \
    git \
    zip \
    gzip \
    mc \
    mariadb-client \
    telnet \
    libmagickwand-dev \
    imagemagick \
    libmcrypt-dev \
    procps \
    openssh-client \
    lsof \
    openssl \
    msmtp \
    alien \
    wget \
    libaio1 \
    libyaml-dev \
    && locale-gen en_US.UTF-8 \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y php8.1-bcmath \
    php8.1-cli \
    php8.1-common \
    php8.1-curl \
    php8.1-dev \
    php8.1-fpm \
    php8.1-gd \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-opcache \
    php8.1-soap \
    php8.1-sqlite3 \
    php8.1-xml \
    php8.1-xmlrpc \
    php8.1-xsl \
    php8.1-zip \
    php8.1-imagick \
    php8.1-ctype \
    php8.1-dom \
    php8.1-fileinfo \
    php8.1-iconv \
    php8.1-simplexml \
    php8.1-sockets \
    php8.1-tokenizer \
    php8.1-xmlwriter

RUN if [ "8.1" < "8.0" ]; then apt-get install -y php8.1-json; fi

# Oracle client ARM64 on Ubuntu
RUN wget -O basic.rpm https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux-arm64.rpm && \
    wget -O sdk.rpm https://download.oracle.com/otn_software/linux/instantclient/instantclient-sdk-linux-arm64.rpm && \
    fakeroot alien --target=arm64 --install basic.rpm && \
    fakeroot alien --target=arm64 --install sdk.rpm && \
    export LD_LIBRARY_PATH=/usr/lib/oracle/19.24/client64/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} && \
    touch /etc/ld.so.conf.d/oracle.conf && \
    echo -e '/usr/lib/oracle/19.24/client64/lib/' >> /etc/ld.so.conf.d/oracle.conf  && \
    ldconfig && \
    touch /etc/profile.d/oracle.sh && chmod o+r /etc/profile.d/oracle.sh && \
    echo -e 'export ORACLE_HOME=/usr/lib/oracle/19.24/client64 \n export PATH=$PATH:$ORACLE_HOME/bin' >> /etc/profile.d/oracle.sh && \
    echo -e '\n export ORACLE_HOME=/usr/lib/oracle/19.24/client64' >> ~/.bash_profile && \
    ln -s /usr/include/oracle/19.24/client64 $ORACLE_HOME/include

#instantclient,/usr/lib/oracle/19.22/client64/lib
RUN echo 'instantclient,/usr/lib/oracle/19.24/client64/lib' | pecl install -f oci8-3.2.1 && \
    touch /etc/php/8.1/mods-available/oci8.ini && \
    echo "extension=oci8.so" > /etc/php/8.1/mods-available/oci8.ini \
    && ln -s /etc/php/8.1/mods-available/oci8.ini /etc/php/8.1/cli/conf.d/666-oci8.ini \
    && ln -s /etc/php/8.1/mods-available/oci8.ini /etc/php/8.1/fpm/conf.d/666-oci8.ini

RUN pecl install -f yaml && \
    touch /etc/php/8.1/mods-available/yaml.ini && \
    echo "extension=yaml.so" > /etc/php/8.1/mods-available/yaml.ini \
    && ln -s /etc/php/8.1/mods-available/yaml.ini /etc/php/8.1/cli/conf.d/777-yaml.ini \
    && ln -s /etc/php/8.1/mods-available/yaml.ini /etc/php/8.1/fpm/conf.d/777-yaml.ini

RUN sed -i -e "s/pid =.*/pid = \/var\/run\/php8.1-fpm.pid/" /etc/php/8.1/fpm/php-fpm.conf \
    && sed -i -e "s/error_log =.*/error_log = \/proc\/self\/fd\/2/" /etc/php/8.1/fpm/php-fpm.conf \
    && sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/8.1/fpm/php-fpm.conf \
    && sed -i "s/listen = .*/listen = 9000/" /etc/php/8.1/fpm/pool.d/www.conf \
    && sed -i "s/;catch_workers_output = .*/catch_workers_output = yes/" /etc/php/8.1/fpm/pool.d/www.conf

RUN if [ "false" = "true" ]; then set -eux && EXTENSION_DIR="$( php -i | grep ^extension_dir | awk -F '=>' '{print $2}' | xargs )" \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz \
    && tar xvfz ioncube.tar.gz \
    && cd ioncube \
    && cp ioncube_loader_lin_8.1.so ${EXTENSION_DIR}/ioncube.so \
    && cd ../ \
    && rm -rf ioncube \
    && rm -rf ioncube.tar.gz \
    && echo "zend_extension=ioncube.so" >> /etc/php/8.1/mods-available/ioncube.ini \
    && ln -s /etc/php/8.1/mods-available/ioncube.ini /etc/php/8.1/cli/conf.d/10-ioncube.ini \
    && ln -s /etc/php/8.1/mods-available/ioncube.ini /etc/php/8.1/fpm/conf.d/10-ioncube.ini; fi

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN pecl install -f xdebug-3.2.1 \
    && ln -s /etc/php/8.1/mods-available/xdebug.ini /etc/php/8.1/cli/conf.d/11-xdebug.ini \
    && ln -s /etc/php/8.1/mods-available/xdebug.ini /etc/php/8.1/fpm/conf.d/11-xdebug.ini;

RUN apt-get install -y unixodbc-dev \
    && pecl config-set php_ini /etc/php/8.1/fpm/php.ini \
    && pecl install -f sqlsrv \
    && pecl install -f pdo_sqlsrv \
    && printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.1/mods-available/sqlsrv.ini \
    && printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.1/mods-available/pdo_sqlsrv.ini \
    && phpenmod -v 8.1 sqlsrv pdo_sqlsrv;

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18;

RUN sed -i 's/session.cookie_lifetime = 0/session.cookie_lifetime = 2592000/g' /etc/php/8.1/fpm/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 80M/g' /etc/php/8.1/fpm/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php/8.1/fpm/php.ini \
    && sed -i 's/;sendmail_path =/sendmail_path = "\/usr\/bin\/msmtp -t --port=1025 --host=host.docker.internal"/g' /etc/php/8.1/fpm/php.ini

WORKDIR /var/www

RUN if [ "false" = "true" ]; then curl -sS https://accounts.magento.cloud/cli/installer | php \
    && cp -r /root/.magento-cloud/ /var/www/ && chown -R 501:20 /var/www/.magento-cloud && ln -s /var/www/.magento-cloud/bin/magento-cloud /usr/bin/magento-cloud; fi

RUN apt-get install cron
RUN mkdir /var/www/scripts/ && mkdir /var/www/scripts/php && mkdir /var/www/patches/ && mkdir /var/www/var/ && mkdir /var/www/var/log/ && touch /var/www/var/log/xdebug.log && chmod 0777 /var/www/var/log/xdebug.log
RUN if [ "false" = "true" ]; then mkdir /var/www/.npm && chown 501:20 /var/www/.npm && apt install nodejs npm -y && apt install chromium-bsu -y && npm install -g grunt-cli && npm install -g bower && npm install -g livereload; fi
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /var/log/faillog && rm -f /var/log/lastlog

RUN usermod -u 501 -o www-data && groupmod -g 20 -o www-data
RUN chown 501:20 /var/www/patches
RUN chown 501:20 /var/www/scripts/php
RUN chown 501:20 /usr/bin/composer
RUN if [ "false" = "true" ]; then chown 501:20 /usr/bin/magento-cloud; fi
WORKDIR /var/www/html

EXPOSE 9001 9003 35729
CMD "php-fpm8.1"