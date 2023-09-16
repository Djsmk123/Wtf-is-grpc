import 'package:flutter_app/pb/rpc_chat.pb.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/grpc_services.dart';
import 'package:grpc/grpc.dart';

class ChatService {
  static Future<List<Message>> getMessages(String username) async {
    final res = await GrpcService.client.getAllMessage(
        GetAllMessagesRequest(
          reciever: username,
        ),
        options: CallOptions(
            metadata: {'authorization': 'bearer ${AuthService.authToken}'}));
    return res.messages;
  }
}
