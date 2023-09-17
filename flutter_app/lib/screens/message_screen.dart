import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/pb/rpc_chat.pb.dart';
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
  final StreamController<SendMessageRequest> streamController =
      StreamController<SendMessageRequest>();
  final ScrollController scrollController = ScrollController();

  String? error;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  initAsync() async {
    await fetchChatsHistory();
    startListeningMessageRequest();
    addMessage("Join_room");
  }

  void startListeningMessageRequest() {
    final stream = GrpcService.client.sendMessage(streamController.stream,
        options: CallOptions(
            metadata: {'authorization': 'bearer ${AuthService.authToken}'}));
    stream.listen((value) {
      if (value.sender != "Server") {
        messages.add(value);
      } else {
        if (value.message.contains("has joined the room.")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.reciever.fullname} has joined now.'),
            ),
          );
        }
      }
      setState(() {});
    });
  }

  void addMessage(String message) {
    // Simulate adding a message to the stream when a button is clicked
    final req = SendMessageRequest(
      message: message,
      reciever: widget.reciever.username,
    );
    streamController.sink.add(req);
  }

  void _sendMessage() {
    final messageText = controller.text;

    if (messageText.isNotEmpty) {
      addMessage(messageText);

      controller.clear();
      scrollDown();
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
          content: Text('Failed to get messages: $error'),
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
    streamController.close();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
            "${widget.reciever.fullname.replaceRange(0, 1, widget.reciever.fullname[0].toUpperCase())}'s"),
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
                                controller: scrollController,
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
