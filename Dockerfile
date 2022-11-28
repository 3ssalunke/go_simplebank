# BUILD STAGE
FROM golang:1.19-alpine3.15 AS builder
WORKDIR /app
COPY . .
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz
RUN go build -o main main.go

#RUN STAGE
FROM alpine:3.15
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migrations ./migrations

EXPOSE 8080
CMD ["/app/main"]
ENTRYPOINT [ "/app/start.sh" ]