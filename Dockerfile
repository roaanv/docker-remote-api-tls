FROM nginx:alpine
MAINTAINER Roaan Vos <roaanv@0112.io>
EXPOSE 443
ADD resources/nginx-cert.conf /etc/nginx/conf.d/nginx-cert.conf
