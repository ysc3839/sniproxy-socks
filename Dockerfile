FROM alpine:latest

COPY entrypoint.sh https-dns-proxy.conf proxychains.conf sniproxy.conf /

RUN apk upgrade --no-cache && \
    apk add --no-cache --upgrade \
      c-ares curl libev openssl sniproxy proxychains-ng \
      # temporal build dependencies
      c-ares-dev curl-dev libev-dev openssl-dev \
      git build-base cmake && \
    git clone https://github.com/aarond10/https_dns_proxy.git && \
    cd https_dns_proxy && \
    cmake -D CMAKE_BUILD_TYPE=Release . && \
    make && \
    mv https_dns_proxy /usr/bin && \
    cd .. && \
    rm -rf https_dns_proxy && \
    apk del \
      c-ares-dev curl-dev libev-dev openssl-dev \
      git build-base cmake && \
    delgroup sniproxy nogroup && \
    addgroup sniproxy sniproxy && \
    rm -f /etc/group- /etc/passwd- /etc/shadow- && \
    cd /var/log/sniproxy && \
    touch access.log error.log && \
    chown sniproxy:sniproxy . *

ENTRYPOINT ["/entrypoint.sh"]
