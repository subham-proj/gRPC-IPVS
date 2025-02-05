#!/bin/bash
set -euo pipefail

# Configuration
PROJECT_ROOT=$(pwd)
TARGET_DIR="$PROJECT_ROOT/target"
JAR_FILE="$TARGET_DIR/grpc-demo-1.0-SNAPSHOT.jar"
CLIENT_CLASS="com.example.grpc.GrpcClient"
SERVER_CLASS="com.example.grpc.GrpcServer"
CLIENT_REQUESTS=12
SERVER_PORT=8080

# Ensure the project is built and the JAR file exists
build_project() {
    if [ ! -f "$JAR_FILE" ]; then
        echo "Jar file not found. Building the project..."
        mvn clean install
    else
        echo "Jar file found: $JAR_FILE"
    fi
}

# Start the server in the background
start_server() {
    echo "Starting the gRPC server on port $SERVER_PORT..."
    java -cp "$JAR_FILE" "$SERVER_CLASS" &
    SERVER_PID=$!
    echo "Server started with PID: $SERVER_PID"
}

# Wait for the server to become ready
wait_for_server() {
    echo "Waiting for the server to start..."
    for i in {1..10}; do
        if lsof -i :$SERVER_PORT > /dev/null; then
            echo "Server is running on port $SERVER_PORT"
            return 0
        fi
        sleep 1
    done
    echo "Server did not start within the expected time. Exiting."
    exit 1
}

# Run the client
run_client() {
    echo "Running client with $CLIENT_REQUESTS requests..."
    java -cp "$JAR_FILE" "$CLIENT_CLASS" "$CLIENT_REQUESTS"
}

# Clean up background processes
cleanup() {
    echo "Cleaning up..."
    if [ -n "${SERVER_PID:-}" ]; then
        kill "$SERVER_PID" || true
        echo "Server process terminated."
    fi
}
trap cleanup EXIT

# Main Execution
build_project
start_server
wait_for_server
run_client

echo "gRPC demo completed successfully!"
