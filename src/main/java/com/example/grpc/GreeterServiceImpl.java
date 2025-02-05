package com.example.grpc;

import io.grpc.stub.StreamObserver;
public class GreeterServiceImpl extends GreeterGrpc.GreeterImplBase {
    private final int port;

    public GreeterServiceImpl(int port) {
        this.port = port;
    }

    @Override
    public void sayHello(HelloRequest request, StreamObserver<HelloResponse> responseObserver) {
        System.out.println("Request received on server running on port: " + port);

        HelloResponse response = HelloResponse.newBuilder()
                .setMessage("Hello " + request.getName() + " from server on port " + port)
                .build();

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}