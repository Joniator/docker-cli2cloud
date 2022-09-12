FROM alpine:3.16.2 as BUILD

ARG VERSION

WORKDIR /go/src

RUN apk add --no-cache --upgrade \
    git \
    go
RUN git clone https://github.com/leonwind/cli2cloud.git .
WORKDIR /go/src/service

RUN git checkout "${VERSION}"

RUN go mod download 
RUN go build -o /go/bin/cli2cloud

FROM alpine:3.16.2

LABEL maintainer="Jonathan Boeckel <jonnyb@jonnyb.name>"

COPY --from=BUILD /go/bin/cli2cloud /usr/bin/cli2cloud
COPY --from=BUILD /go/src/service/config.yaml /config/config.yaml

WORKDIR /config
EXPOSE 50051

ENTRYPOINT [ "/usr/bin/cli2cloud" ]
