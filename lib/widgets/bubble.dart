import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  const Bubble({Key? key, required this.message,required this.isMe}) : super(key: key);

  final String message;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe?MainAxisAlignment.start:MainAxisAlignment.end,
      children: [
        Container(
          decoration:  BoxDecoration(
              color: isMe? Colors.blueGrey:Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight:const Radius.circular(20), 
                bottomLeft:isMe? const Radius.circular(20):const Radius.circular(0),
                bottomRight: !isMe? const Radius.circular(20):const Radius.circular(0),
              )),
          width: 140,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(message),
        )
      ],
    );
  }
}
