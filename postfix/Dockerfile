FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    libsasl2-modules \
    postfix \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/postfix-entrypoint
RUN chmod +x /usr/local/bin/postfix-entrypoint

EXPOSE 587

CMD ["/usr/local/bin/postfix-entrypoint"]
