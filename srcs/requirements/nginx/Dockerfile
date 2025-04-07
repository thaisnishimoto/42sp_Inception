FROM debian:oldstable

ARG DOMAIN_NAME
ARG CERTS_CRT
ARG CERTS_KEY

RUN apt update && \
    apt install -y nginx openssl gettext-base

RUN openssl req -x509 -newkey rsa:4096 -nodes -keyout ${CERTS_KEY} -out ${CERTS_CRT} -days 365 -subj "/CN=${DOMAIN_NAME}"

COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template

RUN envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]