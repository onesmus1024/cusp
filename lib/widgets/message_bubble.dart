import 'package:cusp/widgets/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBuddle extends StatefulWidget {
  const MessageBuddle({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  State<MessageBuddle> createState() => _MessageBuddleState();
}

class _MessageBuddleState extends State<MessageBuddle> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid.toString() + widget.id)
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Bubble(
                  message: snapshot.data.docs[index]['text'].toString(),
                  isMe: FirebaseAuth.instance.currentUser!.uid.toString() ==
                      snapshot.data.docs[index]['userId'].toString());
            },
          );
        }
      },
    );
  }
}
