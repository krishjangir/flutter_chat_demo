import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ContactProvider with ChangeNotifier {

  //variables
  List<Contact> _contacts=[];

  List<Contact> _contactsFiltered=[];

  Map<String, Color> _contactsColorMap=new Map();

  //Controllers
  TextEditingController _searchController = new TextEditingController();

  //searchController getter
  TextEditingController get searchController => _searchController;

  //contacts getter outside
  get contacts => _contacts;

  //contacts setter outside
  set contacts(List<Contact> value) {
    _contacts = value;
    notifyListeners();
  }

  //contactsFiltered getter outside
  get contactsFiltered => _contactsFiltered;

  //contactsFiltered setter outside
  set contactsFiltered(List<Contact> value) {
    _contactsFiltered = value;
    notifyListeners();
  }

  //contactsColorMap getter outside
  get contactsColorMap => _contactsColorMap;

  //contactsColorMap setter outside
  set contactsColorMap(Map<String, Color> value) {
    _contactsColorMap = value;
    notifyListeners();
  }

  //contacts getter
  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    contacts = _contacts;
  }

  //contacts filter
  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
      contactsFiltered = _contacts;
    }
  }

  //mobile number validatior
  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  //add search filter
  addSearchFilter() {
    searchController.addListener(() {
      filterContacts();
    });
  }
}
