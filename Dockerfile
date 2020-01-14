FROM golang:1.13-alpine

WORKDIR /go/src/github.com/abutaha/aws-es-proxy
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -mod readonly -o aws-es-proxy

FROM alpine:3.10
LABEL name="aws-es-proxy" \
      version="latest"

RUN apk --no-cache add ca-certificates
WORKDIR /home/
COPY --from=0 /go/src/github.com/abutaha/aws-es-proxy/aws-es-proxy /usr/local/bin/

ENV PORT_NUM 9200
EXPOSE ${PORT_NUM}
USER nobody

ENTRYPOINT ["aws-es-proxy"] 
CMD ["-h"]
