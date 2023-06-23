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
    && locale-gen en_US.UTF-8 \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y php7.4-bcmath \
    php7.4-cli \
    php7.4-common \
    php7.4-curl \
    php7.4-dev \
    php7.4-fpm \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-opcache \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-xsl \
    php7.4-zip \
    php7.4-imagick \
    php7.4-ctype \
    php7.4-dom \
    php7.4-fileinfo \
    php7.4-iconv \
    php7.4-simplexml \
    php7.4-sockets \
    php7.4-tokenizer \
    php7.4-xmlwriter

RUN if [ "7.4" < "8.0" ]; then apt-get install -y php7.4-json; fi

RUN sed -i -e "s/pid =.*/pid = \/var\/run\/php7.4-fpm.pid/" /etc/php/7.4/fpm/php-fpm.conf \
    && sed -i -e "s/error_log =.*/error_log = \/proc\/self\/fd\/2/" /etc/php/7.4/fpm/php-fpm.conf \
    && sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.4/fpm/php-fpm.conf \
    && sed -i "s/listen = .*/listen = 9000/" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i "s/;catch_workers_output = .*/catch_workers_output = yes/" /etc/php/7.4/fpm/pool.d/www.conf

RUN if [ "false" = "true" ]; then set -eux && EXTENSION_DIR="$( php -i | grep ^extension_dir | awk -F '=>' '{print $2}' | xargs )" \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz \
    && tar xvfz ioncube.tar.gz \
    && cd ioncube \
    && cp ioncube_loader_lin_7.4.so ${EXTENSION_DIR}/ioncube.so \
    && cd ../ \
    && rm -rf ioncube \
    && rm -rf ioncube.tar.gz \
    && echo "zend_extension=ioncube.so" >> /etc/php/7.4/mods-available/ioncube.ini \
    && ln -s /etc/php/7.4/mods-available/ioncube.ini /etc/php/7.4/cli/conf.d/10-ioncube.ini \
    && ln -s /etc/php/7.4/mods-available/ioncube.ini /etc/php/7.4/fpm/conf.d/10-ioncube.ini; fi

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN if [ "true" = "true" ]; then pecl install -f xdebug-3.1.6 \
    && touch /etc/php/7.4/mods-available/xdebug.ini \
    && echo "zend_extension=xdebug.so" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.mode=debug" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.start_with_request=on" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.remote_port=9003" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.client_port=9003" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.log=/var/www/var/log/xdebug.log" >> /etc/php/7.4/mods-available/xdebug.ini \
    && echo "xdebug.log_level=7" >> /etc/php/7.4/mods-available/xdebug.ini \
    && ln -s /etc/php/7.4/mods-available/xdebug.ini /etc/php/7.4/cli/conf.d/11-xdebug.ini \
    && ln -s /etc/php/7.4/mods-available/xdebug.ini /etc/php/7.4/fpm/conf.d/11-xdebug.ini; fi

RUN sed -i 's/session.cookie_lifetime = 0/session.cookie_lifetime = 2592000/g' /etc/php/7.4/fpm/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 80M/g' /etc/php/7.4/fpm/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php/7.4/fpm/php.ini \
    && sed -i 's/;sendmail_path =/sendmail_path = "\/usr\/bin\/msmtp -t --port=1025 --host=host.docker.internal"/g' /etc/php/7.4/fpm/php.ini

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
CMD "php-fpm7.4"