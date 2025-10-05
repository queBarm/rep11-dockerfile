# Сборка
FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

# Копируем 
COPY . .

# Прогоняем тесты
RUN go test ./...

# Сборка трекера
RUN go build -o tracker .

# Этап запуска
FROM gcr.io/distroless/base-debian12

WORKDIR /app

# Копируем базу из builder-а
COPY --from=builder /app/tracker .
COPY --from=builder /app/tracker.db .

# Запуск 
CMD ["./tracker"]