FROM ubuntu:latest

RUN apt-get update \
  && apt-get install --yes --no-install-recommends bash ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/ravn-cli
COPY . /opt/ravn-cli
RUN chmod +x ravn-cli runtime/scripts/* \
  && test -x runtime/scripts/config \
  && test -f runtime/templates/git/config \
  && runtime/scripts/help --help > /dev/null

ENTRYPOINT ["/opt/ravn-cli/ravn-cli"]
