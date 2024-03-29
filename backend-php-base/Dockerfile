FROM php:7.4-fpm-alpine

MAINTAINER Roman Lakhtadyr <roman.lakhtadyr@gmail.com>

ARG MAX_UPLOAD_FILESIZE=256
ENV MAX_UPLOAD_FILESIZE=${MAX_UPLOAD_FILESIZE}

RUN apk add curl-dev libpng-dev oniguruma-dev jpeg-dev freetype-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd pdo_mysql

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    rm "$PHP_INI_DIR/php.ini-development" && \
    sed -i "s/^upload_max_filesize\s=.*/upload_max_filesize = ${MAX_UPLOAD_FILESIZE}M/" $PHP_INI_DIR/php.ini && \
    sed -i "s/^variables_order\s=.*/variables_order = \"EGPCS\"/" $PHP_INI_DIR/php.ini && \
    sed -i "s/^post_max_size\s=.*/post_max_size = ${MAX_UPLOAD_FILESIZE}M/" $PHP_INI_DIR/php.ini

# Setup PHP-FPM config settings
RUN echo 'pm.max_children = 500' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.start_servers = 100' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.min_spare_servers = 100' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.max_spare_servers = 200' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.max_requests = 500' >> /usr/local/etc/php-fpm.d/zz-docker.conf

COPY --from=composer:1.10.21 /usr/bin/composer /usr/local/bin/
COPY --from=mwader/static-ffmpeg:5.0.1-3 /ffmpeg /usr/local/bin/
COPY --from=mwader/static-ffmpeg:5.0.1-3 /ffprobe /usr/local/bin/

USER nobody:nogroup
