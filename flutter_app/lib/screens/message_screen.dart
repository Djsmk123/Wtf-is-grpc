import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/pb/rpc_chat.pb.dart';
import 'package:flutter_app/pb/timestamp.pb.dart';
import 'package:flutter_app/screens/widgets/reciver_message_widget.dart';
import 'package:flutter_app/screens/widgets/sender_message_widget.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/chat_services.dart';
import 'package:flutter_app/services/grpc_services.dart';
import 'package:grpc/grpc.dart';

class MessageScreen extends StatefulWidget {
  final UserModel reciever;
  const MessageScreen({super.key, required this.reciever});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController controller = TextEditingController();
  List<Message> messages = [];
  bool isLoading = false;

  String? error;

  @override
  void initState() {
    super.initState();
    fetchChatsHistory();
    _startListeningToMessages().listen((event) {
      print('received message: ');
      if (event.message != "You have joined the room.") {
        messages.add(event);
        setState(() {});
      }
    });
  }

  Stream<Message> _startListeningToMessages() async* {
    SendMessageRequest request = SendMessageRequest(
      message: "Join_room",
      reciever: widget.reciever.username,
    );

    // Start listening to the gRPC server's response stream
    final stream = GrpcService.client.sendMessage(const Stream.empty(),
        options: CallOptions(
            metadata: {'authorization': 'bearer ${AuthService.authToken}'}));

    // Create a subscription to listen for updates
    await for (var response in stream) {
      yield response;
    }
  }

  void _sendMessage() {
    final messageText = controller.text;

    if (messageText.isNotEmpty) {
      final request = SendMessageRequest(
        message: messageText,
        reciever: widget.reciever.username,
      );

      // Send the message using gRPC.
      GrpcService.client.sendMessage(Stream.fromIterable([request]),
          options: CallOptions(
              metadata: {'authorization': 'bearer ${AuthService.authToken}'}));
      // Clear the input field.

      messages.add(Message(
          id: "12321",
          createdAt: Timestamp.fromDateTime(DateTime.now()),
          sender: AuthService.user?.username,
          receiver: widget.reciever.username,
          message: controller.text));
      controller.clear();
      setState(() {});
    }
  }

  fetchChatsHistory() async {
    try {
      isLoading = true;
      setState(() {});
      final res = await ChatService.getMessages(widget.reciever.username);
      messages.addAll(res);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $error'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_startListeningToMessages();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Chat History"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLoading
                ? loadingWidget()
                : (error != null
                    ? errorWidget()
                    : messages.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: ((context, index) {
                                  Message message = messages[index];
                                  bool isOwn = message.sender ==
                                      AuthService.user?.username;
                                  return isOwn
                                      ? SentMessageScreen(
                                          message: message,
                                        )
                                      : ReceivedMessageScreen(message: message);
                                })),
                          )
                        : const Expanded(
                            child: Center(
                              child: Text(
                                  "No message found,start conversion with 'hi' "),
                            ),
                          )),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        maxLines: null,
                        controller: controller,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.message),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _sendMessage();
                                },
                                icon: const Icon(Icons.send)),
                            hintText: 'Reply to this wave'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {}
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadingWidget() => const Center(child: CircularProgressIndicator());
  errorWidget() => Center(
      child: Text(error ?? "Something went wrong",
          style: const TextStyle(color: Colors.red)));
}
