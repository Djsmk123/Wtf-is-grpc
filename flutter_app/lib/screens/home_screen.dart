// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/screens/login.dart';
import 'package:flutter_app/screens/message_screen.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:grpc/grpc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<UserModel> users = [];
  String? error;
  bool isEnd = false; //for pagination purposes
  int page = 1;

  @override
  void initState() {
    super.initState();

    getUsers();
  }

  getUsers() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await AuthService.getUsers(pageNumber: page);

      if (page == 1) {
        users = res;
        page++;
      } else {
        if (res.isNotEmpty) {
          users.addAll(res);
          page++;
        } else {
          isEnd = true;
        }
      }
    } on GrpcError catch (e) {
      d.log(e.toString());
      error = e.message;
    } finally {
      isLoading = false;
      setState(() {});
    }
  } /*eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInVzZXJuYW1lIjoiaXJvbm1hbiIsImlzc3VlZF9hdCI6IjIwMjMtMDktMTZUMTY6MDA6MjQuMzY1NzgzKzA1OjMwIiwiZXhwaXJlZF9hdCI6IjIwMjMtMDktMTdUMDI6MDA6MjQuMzY1NzgzKzA1OjMwIn0.kjeeca9fMBMjNmBSpdxMrfz6Ny67Fbn_oWOJ85hT7Pc*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${AuthService.user?.fullname}"),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await AuthService.logout();
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const LoginScreen()));
                } catch (e) {
                  d.log(e.toString());
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading && page == 1)
                loadingWidget()
              else if (error != null && page == 1)
                errorWidget()
              else
                buildUsersCard(users),
            ]),
      ),
    );
  }

  loadingWidget() => const Center(child: CircularProgressIndicator());
  errorWidget() => Center(
      child: Text(error ?? "Something went wrong",
          style: const TextStyle(color: Colors.red)));
  Widget buildUsersCard(List<UserModel> users) {
    if (users.isEmpty) {
      return const Center(
        child: Text("No users found"),
      );
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Connect with following people:",
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
          Expanded(
              child: NotificationListener<ScrollEndNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !isEnd) {
                getUsers();
              }
              return isEnd;
            },
            child: ListView.separated(
                padding: const EdgeInsets.all(10),
                separatorBuilder: (context, index) {
                  if (isLoading && index == users.length - 1) {
                    return loadingWidget();
                  }
                  if (error != null && index == users.length - 1) {
                    return errorWidget();
                  }
                  return const SizedBox.shrink();
                },
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserModel user = users[index];
                  int random = Random().nextInt(49);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  MessageScreen(reciever: user)));
                    },
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            Flexible(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  height: 80,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(color: Colors.black),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://xsgames.co/randomusers/assets/avatars/pixel/$random.jpg"))),
                                ),
                                title: Text(user.fullname),
                                subtitle: Text(user.username),
                                trailing: const Icon(Icons.navigate_next),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )),
        ],
      ),
    );
  }
}
