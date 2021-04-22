FROM nginx:stable-alpine

ARG MAX_UPLOAD_FILESIZE=256
ENV MAX_UPLOAD_FILESIZE=${MAX_UPLOAD_FILESIZE}

ARG PHP_FPM_HOSTNAME=backend-php-fpm
ENV PHP_FPM_HOSTNAME=${PHP_FPM_HOSTNAME}

COPY default.conf.template /etc/nginx/templates/
COPY status.conf.template /etc/nginx/templates/

EXPOSE 80
