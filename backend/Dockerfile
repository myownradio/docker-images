FROM ubuntu:18.04

MAINTAINER Roman Lakhtadyr <roman.lakhtadyr@gmail.com>

ENV DEBIAN_FRONTEND         noninteractive
ENV MAX_UPLOAD_FILESIZE     256
ENV PORT                    8080
ENV PHP_VERSION             7.2
ENV NODE_VERSION            10

# Install container dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        curl \
        git \
        apt-transport-https \
        ca-certificates \
        && \
    (curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash) && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        nginx \
        php${PHP_VERSION} \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-dom \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-mysql \
        composer \
        supervisor \
        nodejs \
        ffmpeg \
        mediainfo \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
\n\
[program:fpm]\n\
command=/usr/sbin/php-fpm'${PHP_VERSION}' -F\n\
stdout_logfile=/dev/fd/1\n\
stdout_logfile_maxbytes=0\n\
stderr_logfile=/dev/fd/2\n\
stderr_logfile_maxbytes=0\n\
' > /etc/supervisor/conf.d/services.conf

# nginx
RUN echo '\
server {\n\
    listen       '${PORT}';\n\
    server_name  localhost default;\n\
    root         /usr/app/public;\n\
    access_log   /dev/stderr combined;\n\
    client_max_body_size '${MAX_UPLOAD_FILESIZE}';\n\
    location / {\n\
        index            index.html index.htm index.php;\n\
        try_files        $uri $uri/ @rewrites;\n\
        error_page 403 = @rewrites;\n\
        error_page 404 = @rewrites;\n\
        error_page 405 = @rewrites;\n\
    }\n\
    location ~ \.php$ {\n\
        fastcgi_pass     unix:/run/php/php'${PHP_VERSION}'-fpm.sock;\n\
        fastcgi_index    index.php;\n\
        fastcgi_param    SCRIPT_FILENAME  $document_root$fastcgi_script_name;\n\
        include          fastcgi_params;\n\
        error_page 404 = @rewrites;\n\
        error_page 405 = @rewrites;\n\
    }\n\
    location @rewrites {\n\
        rewrite ^/(.*)$ /index.php;\n\
    }\n\
    location ~ /\.ht {\n\
        deny  all;\n\
    }\n\
}\n\
' > /etc/nginx/sites-available/default

RUN mkdir -p /run/php

# Patch PHP configuration files
RUN sed -i "s/^upload_max_filesize\s=.*/upload_max_filesize = ${MAX_UPLOAD_FILESIZE}M/" /etc/php/$PHP_VERSION/fpm/php.ini && \
    sed -i "s/^post_max_size\s=.*/post_max_size = ${MAX_UPLOAD_FILESIZE}M/" /etc/php/$PHP_VERSION/fpm/php.ini && \
    sed -i 's/^variables_order\s=.*/variables_order = "EGPCS"/' /etc/php/$PHP_VERSION/fpm/php.ini && \
    sed -i "s/^error_log\s=.*/error_log = \/proc\/self\/fd\/2\n/" /etc/php/$PHP_VERSION/fpm/php-fpm.conf && \
    echo "catch_workers_output = on" >> /etc/php/$PHP_VERSION/fpm/pool.d/www.conf && \
    echo "php_admin_flag[log_errors] = on" >> /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

RUN mkdir -p /usr/app/public && echo '<?php phpinfo();\n' > /usr/app/public/index.php

VOLUME /tmp
VOLUME /var/tmp

CMD ["/usr/bin/supervisord"]
