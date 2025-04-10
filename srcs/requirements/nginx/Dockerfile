FROM debian:oldstable

ARG DOMAIN_NAME
ARG CERTS_CRT_PATH
ARG CERTS_KEY_PATH

RUN apt update && \
    apt install -y nginx openssl gettext-base

RUN openssl req -x509 -newkey rsa:4096 -nodes \
    -keyout ${CERTS_KEY_PATH} -out ${CERTS_CRT_PATH} \
    -days 365 -subj "/C=BR/ST=SP/L=Sao Paulo/O=42/OU=Inception/CN=${DOMAIN_NAME}"

COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template

RUN envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]