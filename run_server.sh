#!/bin/bash
set -e

# Configuration
PROJECT_ROOT=$(pwd)
JAR_FILE="$PROJECT_ROOT/target/grpc-demo-1.0-SNAPSHOT.jar"
NUMBER_OF_SERVERS=1
SERVER_PORTS=(8080)

# Function to cleanup background processes
cleanup() {
    echo "Cleaning up..."
    pkill -f GrpcServer || true
}
trap cleanup EXIT SIGINT

# Ensure the jar file exists
if [ ! -f "$JAR_FILE" ]; then
    echo "Jar file not found. Building the project..."
    mvn clean install
fi

# Start multiple gRPC servers
echo "Starting gRPC servers..."
for i in $(seq 0 $(($NUMBER_OF_SERVERS - 1))); do
    PORT=${SERVER_PORTS[$i]}
    SERVER_ID=$((i+1))
    echo "provisioning new server..."
    java -cp $JAR_FILE com.example.grpc.GrpcServer $PORT $SERVER_ID &
    sleep 1 # Give some time between server starts
done
wait