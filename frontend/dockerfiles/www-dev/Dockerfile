FROM docker.io/ubuntu:16.04

RUN apt-get update && apt-get install -y npm nodejs build-essential autoconf automake python-dev git

# workaround bug that breaks watchman installed via npm
RUN bash -c "\
	git clone https://github.com/facebook/watchman.git; \
	cd watchman; \
	git checkout v4.5.0; \
	./autogen.sh; \
	./configure; \
	make; \
	make install;"

RUN ln -s /usr/bin/nodejs /usr/bin/node

ENV dockersuckscachebuster 1000

RUN npm install -g webpack webpack-dev-server typings typescript ts-node angular-cli


CMD /bin/bash
