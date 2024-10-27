# Stage 1: Build the Haskell application
FROM haskell:9.6 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the stack configuration files
COPY stack.yaml package.yaml ./

# Copy the source code
COPY app app
COPY src src

# Copy any additional files, e.g., data files
COPY app/data app/data

# Build the application
RUN stack setup
RUN stack build --copy-bins

# Stage 2: Create a minimal runtime image
FROM debian:bullseye-slim

# Install runtime dependencies for Haskell binaries
RUN apt-get update && apt-get install -y \
    libgmp10 \
 && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the executable from the builder stage
COPY --from=builder /root/.local/bin/backend-exe /usr/local/bin/backend-exe

# Copy the data files needed at runtime
COPY --from=builder /app/app/data app/data

# Expose the port your application listens on
EXPOSE 8005

# Run the application
CMD ["backend-exe"]
