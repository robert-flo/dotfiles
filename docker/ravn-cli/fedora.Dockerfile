FROM fedora:latest

RUN dnf install -y bash \
  && dnf clean all

WORKDIR /opt/ravn-cli
COPY . /opt/ravn-cli
RUN chmod +x ravn-cli runtime/scripts/* \
  && test -x runtime/scripts/config \
  && test -f runtime/templates/git/config \
  && runtime/scripts/help --help > /dev/null

ENTRYPOINT ["/opt/ravn-cli/ravn-cli"]
