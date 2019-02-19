FROM alpine:3.9
RUN apk add --update mysql-client bash findutils coreutils && rm -rf /var/cache/apk/*
COPY dump.sh /
RUN chmod +x /dump.sh
ENTRYPOINT ["/dump.sh"]
