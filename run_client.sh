#!/bin/bash
set -e

# Configuration
PROJECT_ROOT=$(pwd)
JAR_FILE="$PROJECT_ROOT/target/grpc-demo-1.0-SNAPSHOT.jar"
CLIENT_IP=192.168.122.100
CLIENT_PORT=8080
CLIENT_REQUESTS=10

# Ensure the jar file exists
if [ ! -f "$JAR_FILE" ]; then
    echo "Jar file not found. Building the project..."
    mvn clean install
fi

## Run client
echo "Running client with $CLIENT_REQUESTS requests..."
java -cp $JAR_FILE com.example.grpc.GrpcClient $CLIENT_IP $CLIENT_PORT $CLIENT_REQUESTS

# Keep running until interrupted
echo "Demo is running... Press Ctrl+C to stop"
wait