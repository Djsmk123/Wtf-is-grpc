import 'package:flutter_app/pb/rpc_services.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class GrpcService {
  static final channel = ClientChannel("10.0.2.2",
      port: 9090,
      options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
          connectionTimeout: Duration(seconds: 10)));

  static var client = GrpcServerServiceClient(channel);
}
