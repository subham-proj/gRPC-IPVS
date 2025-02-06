package com.example.grpc;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

public class GrpcClient {
    public static void main(String[] args) {
        if (args.length < 3) {
            System.err.println("Usage: GrpcClient <ipaddress> <port> <numRequests>");
            return;
        }

        String ipaddress = args[0];
        int port = Integer.parseInt(args[1]);
        int numRequests = Integer.parseInt(args[2]);
        ManagedChannel channel = ManagedChannelBuilder.forAddress(ipaddress, port)
                .usePlaintext()
                .build();
        System.out.println("IP: " + ipaddress);
        try {
            GreeterGrpc.GreeterBlockingStub stub = GreeterGrpc.newBlockingStub(channel);
            for (int i = 0; i < numRequests; i++) {
                String userName = "User " + i;
                HelloRequest request = HelloRequest.newBuilder()
                        .setName(userName)
                        .build();

                HelloResponse response = stub.sayHello(request);
                System.out.println("Response: " + response.getMessage());
            }


        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Client failed to connect or execute requests.");
        } finally {
            channel.shutdown();
        }

    }
}