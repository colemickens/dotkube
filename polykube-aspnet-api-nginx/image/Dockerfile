FROM docker.io/nginx:1.11

ADD default.template /polykube-aspnet-api-nginx/

CMD bash -c "\
	envsubst '\${BACKEND_HOST} \${BACKEND_PORT} \${LISTEN_PORT}' </polykube-aspnet-api-nginx/default.template >/etc/nginx/conf.d/default.conf \
    && cat /etc/nginx/conf.d/default.conf \
    && nginx -g 'daemon off;'"
