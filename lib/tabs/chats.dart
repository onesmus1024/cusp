import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusp/screens/single_chat.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    super.initState();
    getContactsFromPhone();
    getContactFromDB();
  }

  bool nav = false;
  List<Contact> common = [];
  List<Contact> _contacts = [];
  List<String> phoneNumber = [];
  Future<void> _askForPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      await Permission.contacts.request();
    }
  }

  Future<void> getContactsFromPhone() async {
    List<Contact> contacts = [];
    await _askForPermission();
    contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
      common = processCommon();
    });
  }

  void getContactFromDB() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      List<String> _phoneNumber = [];
      for (var contact in event.docs) {
        // ignore: unnecessary_null_comparison
        if (FirebaseAuth.instance.currentUser!.uid != null) {
          if (contact.data()['userId'] !=
              FirebaseAuth.instance.currentUser!.uid) {
            _phoneNumber.add(contact.data()['phoneNumber'].trim());
          }
        }
      }
      setState(() {
        phoneNumber = _phoneNumber;
      });
    });
  }

  List<Contact> processCommon() {
    List<Contact> commonIn = [];
    for (var k = 0; k < phoneNumber.length; k++) {
      for (var i = 0; i < _contacts.length; i++) {
        try {
          if (_contacts[i]
              .phones![0]
              .value!
              .replaceAll('(', "")
              .replaceAll(')', "")
              .replaceAll('-', "")
              .replaceAll(" ", "")
              .trim()
              .startsWith("+254")) {
            if (phoneNumber[k] ==
                _contacts[i]
                    .phones![0]
                    .value!
                    .replaceAll('(', "")
                    .replaceAll(')', "")
                    .replaceAll('-', "")
                    .replaceAll(" ", "")
                    .trim()
                    .replaceAll("+254", "0")) {
              commonIn.add(_contacts[i]);
            }
          } else if (phoneNumber[k] ==
              _contacts[i]
                  .phones![0]
                  .value!
                  .replaceAll('(', "")
                  .replaceAll(')', "")
                  .replaceAll('-', "")
                  .replaceAll(' ', '')
                  .trim()) {
            commonIn.add(_contacts[i]);
          }
        } catch (e) {
          // ignore: avoid_print
          print(e.toString());
        }
      }
    }
    return commonIn;
  }

  String getId(var doc, bool nav) {
    String _id = '';

    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      String id;
      for (var item in event.docs) {
        var number = doc.phones[0].value.toString();
        if (number.trim().startsWith("+254")) {
          number = number
              .replaceAll('(', "")
              .replaceAll(')', "")
              .replaceAll('-', "")
              .replaceAll(" ", "")
              .replaceAll("+254", "0")
              .trim();
        } else {
          number = number
              .replaceAll('(', "")
              .replaceAll(')', "")
              .replaceAll('-', "")
              .replaceAll(" ", "")
              .trim();
        }

        if (item.data()['phoneNumber'] == number && nav) {
          id = item.data()['userId'];
          Navigator.of(context)
              .pushNamed(SingleChat.routName, arguments: {'ID': id.toString()});
          break;
        }
      }
    });
    return _id;
  }

  @override
  Widget build(BuildContext context) {
  
    if (common.isNotEmpty) {
      return ListView.builder(
        itemCount: common.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              key: ValueKey(common[index].phones![0].value),
              leading: const CircleAvatar(child: Text("o")),
              title: GestureDetector(
                  onTap: () => getId(common[index], !nav),
                  child: Text(common[index].displayName.toString())));
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
