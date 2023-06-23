FROM redis:6.2

RUN rm -f /var/log/faillog && rm -f /var/log/lastlog

RUN usermod -u 501 -o redis && groupmod -g 20 -o redis
