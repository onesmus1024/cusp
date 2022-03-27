import 'package:cusp/screens/single_chat.dart';
import 'package:cusp/screens/single_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cusp/screens/sign_in.dart';
import 'package:cusp/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cusp/providers/contact_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Contacts(),
      child: MaterialApp(
        // home: const  SignIn(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          buttonTheme: ButtonTheme.of(context).copyWith(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return const Home();
          }else{
              return const  SignIn();
            }
          },
        ),
        routes: {
          SignIn.routName: (context) => const SignIn(),
          Home.routName: (context) => const Home(),
          SingleChat.routName:(context) => const SingleChat(),
          SingleStatus.routName:(context) =>  const SingleStatus()
        },
      ),
    );
  }
}
