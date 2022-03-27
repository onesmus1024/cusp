// ignore_for_file: prefer_final_fields, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class Contacts with ChangeNotifier {
  List<Contact> _common = [];
  List<Contact> _contacts = [];
  List<String> phoneNumber = [];
  Future<void> _askForPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      await Permission.contacts.request();
    }
  }

  // ignore: unused_element
  Future<void> getContactsFromPhone() async {
    List<Contact> contacts = [];
    await _askForPermission();
    contacts = await ContactsService.getContacts();
    _contacts = contacts;
    notifyListeners();
  }

  Future<void> getContactFromDB() async {
    List<String> _phoneNumber = [];
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var contact in event.docs) {
        // ignore: unnecessary_null_comparison
        if (FirebaseAuth.instance.currentUser!.uid != null) {
          if (contact.data()['userId'] !=
              FirebaseAuth.instance.currentUser!.uid) {
            _phoneNumber.add(contact.data()['phoneNumber'].trim());
          }
        }
      }

      phoneNumber = _phoneNumber;
    });
    processCommon();
    notifyListeners();
  }

  Future<void> processCommon() async {
    List<Contact> common = [];

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
              common.add(_contacts[i]);
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
            common.add(_contacts[i]);
            _common.add(_contacts[i]);
            notifyListeners();
          }
        } catch (e) {
          // ignore: avoid_print
          print(e.toString());
        }
      }
      _common = common;
      notifyListeners();
    }
    _common = _contacts;
    notifyListeners();
  }

  List<Contact> get getContact {
    return [..._contacts];
  }

  List<Contact> get getCommon {
    return [..._common];
  }
}







// for (var k = 0; k < phoneNumber.length; k++) {
//       for (var i = 0; i < _contacts.length; i++) {
//         try {
//           if (_contacts[i]
//               .phones![0]
//               .value!
//               .replaceAll('(', "")
//               .replaceAll(')', "")
//               .replaceAll('-', "")
//               .replaceAll(" ", "")
//               .trim()
//               .startsWith("+254")) {
//             if (phoneNumber[k] ==
//                 _contacts[i]
//                     .phones![0]
//                     .value!
//                     .replaceAll('(', "")
//                     .replaceAll(')', "")
//                     .replaceAll('-', "")
//                     .replaceAll(" ", "")
//                     .trim()
//                     .replaceAll("+254", "0")) {
//               common.add(_contacts[i]);
//             }
//           } else if (phoneNumber[k] ==
//               _contacts[i]
//                   .phones![0]
//                   .value!
//                   .replaceAll('(', "")
//                   .replaceAll(')', "")
//                   .replaceAll('-', "")
//                   .replaceAll(' ', '')
//                   .trim()) {
//             common.add(_contacts[i]);
//             _common.add(_contacts[i]);
//             notifyListeners();
//           }
//         } catch (e) {
//           // ignore: avoid_print
//           print(e.toString());
//         }
//       }
//       _common = common;
//       notifyListeners();
//     }