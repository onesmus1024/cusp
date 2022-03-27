
import 'package:cusp/tabs/camera.dart';
import 'package:cusp/tabs/chats.dart';
import 'package:cusp/tabs/shorts.dart';
import 'package:cusp/tabs/status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Cusp",
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout))
            ],
            bottom: const TabBar(
              tabs: [
                Icon(Icons.camera_alt),
                Text("chats"),
                Text("status"),
                Text("shorts"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [Camera(), Chats(), Status(), Shorts()],
          ),
          
  
        ));
  }
}
