import 'package:cusp/widgets/message_bubble.dart';
import 'package:cusp/widgets/new_message.dart';
import 'package:flutter/material.dart';

class SingleChat extends StatelessWidget {
  const SingleChat({Key? key}) : super(key: key);

  static const routName = '/single_chat';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: const Text("chat"),
      ),
      body: Column(children: [
        Expanded(flex: 1, child: MessageBuddle(id: id['ID'].toString())),
       Expanded(flex: 0, child: NewMessage(id: id['ID'].toString()))
      ]),
    );
  }
}
