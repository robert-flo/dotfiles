FROM archlinux:latest

WORKDIR /app

COPY dockerfile.sh /app/dockerfile.sh
RUN chmod +x /app/dockerfile.sh

ENTRYPOINT ["/app/dockerfile.sh"]
