FROM ghcr.io/9seconds/mtg:2 AS builder
FROM alpine:latest

# Сертификаты критически важны для связи mtg с серверами конфигурации Telegram
RUN apk add --no-cache ca-certificates
COPY --from=builder /mtg /usr/local/bin/mtg

# Фиксируем внутренний порт, чтобы Railway корректно его замапил
EXPOSE 3128

# Генерируем config.toml при старте и запускаем прокси
CMD printf "secret = \"%s\"\nbind-to = \"0.0.0.0:3128\"\n" "${MTG_SECRET}" > /config.toml && mtg run /config.toml
