FROM alpine:latest

#
# To reduce the size of the image, 
# do not download the web application 
# inside the image, but download it 
# on the host and map the host directory 
# to the container /var/Webapp directory.
#
# So the application will be run as 
#  /var/Webapp/sreracha
#
# which will be the entry ENTRYPOINT
#

WORKDIR /sbin

RUN apk update --no-cache && \
    apk --no-cache add wget ca-certificates 

RUN adduser -S -h /var/www -s /bin/sh www &&  \
     mkdir -p /var/Webapp

USER www

EXPOSE 8080
ENV PORT 8080

ENTRYPOINT [ "/var/Webapp/sreracha" ]
