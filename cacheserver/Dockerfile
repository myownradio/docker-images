FROM ubuntu:18.04

ENV DEBIAN_FRONTEND         noninteractive

MAINTAINER Roman Lakhtadyr <roman.lakhtadyr@gmail.com>

# Install container dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        supervisor \
        nginx \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG UPSTREAM_HOST=https://s3.eu-central-1.amazonaws.com
ARG CACHE_EXPIRE_MINUTES=60
ARG MAX_UPLOAD_FILESIZE=256


# Create configuration files
# supervisor
RUN mkdir -p /etc/supervisor/conf.d/ && echo '\
[supervisord]\n\
nodaemon=true\n\
logfile=/dev/null\n\
logfile_maxbytes=0\n\
\n\
[program:nginx]\n\
command=/usr/sbin/nginx -g "daemon off; error_log /dev/stderr;"\n\
stdout_logfile=/dev/fd/1\n\
stdout_logfile_maxbytes=0\n\
stderr_logfile=/dev/fd/2\n\
stderr_logfile_maxbytes=0\n\
' > /etc/supervisor/conf.d/services.conf

# nginx
RUN echo '\
proxy_cache_methods GET HEAD;\n\
proxy_cache_path /var/cache/nginx/one levels=1:2 keys_zone=one:10m\n\
                            max_size=10g inactive='${CACHE_EXPIRE_MINUTES}'m\n\
                            use_temp_path=off;\n\
server {\n\
    listen       8080;\n\
    access_log   /dev/stderr combined;\n\
    client_max_body_size '${MAX_UPLOAD_FILESIZE}'M;\n\
    location / {\n\
        add_header X-Cache-Status $upstream_cache_status;\n\
        proxy_pass '${UPSTREAM_HOST}';\n\
        proxy_read_timeout 5m;\n\
        proxy_cache one;\n\
        proxy_cache_valid 200 '${CACHE_EXPIRE_MINUTES}'m;\n\
    }\n\
}\n\
' > /etc/nginx/sites-available/default

VOLUME /var/cache/nginx

CMD ["/usr/bin/supervisord"]

EXPOSE 8080
