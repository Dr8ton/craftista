# Stage 1: Build the Go application
FROM golang:1.22-alpine AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy go.mod and go.sum for caching dependencies separately
COPY go.mod go.sum ./

# Install dependencies (will be cached unless go.mod or go.sum changes)
RUN go mod download

# Copy the entire source code
COPY . .

# Run tests
RUN go test ./...

# Build the Go application
RUN go build -o app .

# Stage 2: Create the runtime image
FROM alpine:latest

# Install ca-certificates to allow secure HTTPS connections
RUN apk --no-cache add ca-certificates

# Set the working directory inside the container
WORKDIR /app

# Copy ONLY the compiled binary from the builder stage
COPY --from=builder /usr/src/app/app /app/app

# Expose port 8080
EXPOSE 8080

# Set the command to run the application
ENTRYPOINT ["/app/app"]Natural Grocers"