package com.example.grpc;

import io.grpc.Server;
import io.grpc.ServerBuilder;

import java.io.IOException;

public class GrpcServer {
    public static void main(String[] args) throws IOException, InterruptedException {
        if (args.length < 1) {
            System.err.println("Usage: GrpcServer <port>");
            System.exit(1);
        }
        int port = Integer.parseInt(args[0]);
        Server server = ServerBuilder.forPort(port)
                .addService(new GreeterServiceImpl(port))
                .build()
                .start();
        System.out.println("Server started on port " + port);
        server.awaitTermination();
    }
}