FROM docker.io/microsoft/dotnet:1.0.0-preview2-sdk

RUN apt-get update && apt-get install -y make && rm -rf /var/lib/apt/lists/*

ADD . /polykube/dotnet
WORKDIR /polykube/dotnet
RUN make build
CMD make -s tar-out
