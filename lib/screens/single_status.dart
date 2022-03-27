import 'package:flutter/material.dart';

class SingleStatus extends StatelessWidget {
  const SingleStatus({Key? key}) : super(key: key);
  static const routName = '/single_status';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("status"),),
      body: Image.network(
          "https://images.unsplash.com/photo-1527610276295-f4c1b38decc5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,),
    );
  }
}
