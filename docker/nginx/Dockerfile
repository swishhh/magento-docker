FROM nginx:1.21.4

RUN rm -f /var/log/faillog && rm -f /var/log/lastlog

RUN usermod -u 501 -o nginx && groupmod -g 20 -o nginx
