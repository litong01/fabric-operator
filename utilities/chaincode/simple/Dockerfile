FROM alpine:3.13 as base

# Add CA certificates and timezone data files
RUN apk add -U --no-cache ca-certificates tzdata

# Add unprivileged user
RUN adduser -s /bin/true -u 1000 -D -h /app app \
    && sed -i -r "/^(app|root)/!d" /etc/group /etc/passwd \
    && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

FROM golang:1.15.8-alpine AS build

COPY ./src /go/src/github.com/simple
WORKDIR /go/src/github.com/simple

# Build application
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -trimpath -ldflags '-extldflags "-static" -w -s' -o chaincode -v .

# Production ready image
# Pass the binary to the prod image
# To make the image even smaller, use the scratch as base image
# FROM scratch
FROM alpine:3.13

# Add the timezone data files
COPY --from=base /usr/share/zoneinfo /usr/share/zoneinfo

# Add the CA certificates
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Add-in our unprivileged user
COPY --from=base /etc/passwd /etc/group /etc/shadow /etc/

COPY --from=build /go/src/github.com/simple/chaincode /chaincode

USER app

ENTRYPOINT ["/chaincode"]