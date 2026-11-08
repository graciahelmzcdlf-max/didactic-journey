FROM ghcr.io/9seconds/mtg:2 AS builder
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /mtg /usr/local/bin/mtg

# Формируем конфиг с использованием переменной $PORT с фоллбеком
CMD printf "secret = \"%s\"\nbind-to = \"0.0.0.0:%s\"\n" "${MTG_SECRET}" "${PORT:-3128}" > /config.toml && cat /config.toml && mtg run /config.toml
