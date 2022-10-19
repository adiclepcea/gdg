FROM golang:1.18
WORKDIR /go/src/gdg
COPY . /go/src/gdg
RUN useradd -u 1000 scratchuser
RUN go mod tidy \
  && CGO_ENABLED=0 GOOS=linux go build -o gdg .

FROM scratch
WORKDIR /app
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=0 /go/src/gdg/gdg /app
COPY --from=0 /etc/passwd /etc/passwd
USER scratchuser
ENTRYPOINT [ "./gdg" ]
