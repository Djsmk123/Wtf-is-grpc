import 'package:flutter_app/pb/rpc_services.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class GrpcService {
  static String host = "10.0.2.2"; //default for android emulator
  static updateChannel() {
    channel = ClientChannel(host,
        port: 9090,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
  }

  static var channel = ClientChannel(host,
      port: 9090,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ));

  static var client = GrpcServerServiceClient(channel);
}
