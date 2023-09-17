import 'package:flutter_app/pb/rpc_services.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class GrpcService {
  static String host = "192.168.0.102"; //default for android emulator
  static int port = 9090;
  static updateChannel() {
    channel = ClientChannel(host,
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
  }

  static var channel = ClientChannel(host,
      port: port,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ));

  static var client = GrpcServerServiceClient(channel);
}
