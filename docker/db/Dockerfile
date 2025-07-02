FROM mariadb:10.6.21

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=magento
ENV MYSQL_USER=magento
ENV MYSQL_PASSWORD=magento

RUN rm -f /var/log/faillog && rm -f /var/log/lastlog
RUN usermod -u 501 -o mysql && groupmod -g 20 -o mysql
