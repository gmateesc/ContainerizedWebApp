FROM alpine:latest

WORKDIR /sbin

RUN apk update --no-cache && \
    apk --no-cache add wget ca-certificates && \
    wget https://s3.amazonaws.com/ml-sreracha/sreracha

RUN adduser -S -h /var/www -s /bin/sh www &&  \
    chown www /sbin/sreracha   &&  \
    chmod a+x /sbin/sreracha

USER www

EXPOSE 8080
ENV PORT 8080

ENTRYPOINT [ "/sbin/sreracha" ]
