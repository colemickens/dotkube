FROM docker.io/nginx:1.11.1

ADD dockerfiles/aspnet-nginx/default.template /etc/nginx/conf.d/default.template

CMD bash -c "envsubst '\${BACKEND_LOCATION} \${LISTEN_PORT}' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf \
    && nginx -g 'daemon off;'"
