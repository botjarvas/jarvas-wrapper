FROM alpine:3.18
RUN apk add --no-cache bash ca-certificates curl git
COPY . /src
WORKDIR /src
CMD ["/bin/sh"]
