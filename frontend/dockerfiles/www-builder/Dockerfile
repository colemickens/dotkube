FROM polykube-www-devenv

ADD . /polykube/

WORKDIR /polykube

RUN make build

CMD make -s tar-out
