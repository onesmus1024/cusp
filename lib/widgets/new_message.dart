import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
 const NewMessage({Key? key,required this.id}) : super(key: key);
  final id;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _message = '';
  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid.toString() + widget.id)
          .add({
        "text": _message,
        'createdAt': Timestamp.now(),
        'userId': user.uid
      });
      FirebaseFirestore.instance
          .collection(widget.id+FirebaseAuth.instance.currentUser!.uid.toString())
          .add({
        "text": _message,
        'createdAt': Timestamp.now(),
        'userId': user.uid
      });
      setState(() {
        _controller.clear();
        _message = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              setState(() {
                _message = value;
              });
            },
            decoration:
                const InputDecoration(label: Text("Type new message ...")),
          ),
        ),
        IconButton(
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send))
      ],
    );
  }
}
