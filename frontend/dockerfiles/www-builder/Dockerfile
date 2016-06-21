FROM polykube-www-devenv

ADD . /opt/polykube/

WORKDIR /opt/polykube

RUN make build

CMD make -s tar-out
