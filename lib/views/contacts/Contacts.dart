import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/customwidgets/ProgressWidget.dart';
import 'package:flutter_chat_app/providers/ContactProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/resource/Icons.dart' as AppIcons;

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    bool isSearching = contactProvider.searchController.text.isNotEmpty;
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorWhite,
        iconTheme: IconThemeData(color: AppColors.colorPrimary),
        title: Text("Contact List",
            style: TextStyle(
                color: AppColors.colorPrimary, fontWeight: FontWeight.bold)),
      ),
      body: contactProvider.contacts.length == 0
          ? ProgressWidget()
          : Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, right: 16.0),
                    child: Card(
                      color: AppColors.colorWhite,
                      child: TextFormField(
                        autofocus: false,
                        controller: contactProvider.searchController,
                        decoration: InputDecoration(
                            hintText: 'Search contact',
                            contentPadding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 14.0),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search,
                                color: AppColors.colorPrimary)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: isSearching == true
                          ? contactProvider.contactsFiltered.length
                          : contactProvider.contacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = isSearching == true
                            ? contactProvider.contactsFiltered[index]
                            : contactProvider.contacts[index];

                        var baseColor = contactProvider
                            .contactsColorMap[contact.displayName] as dynamic;

                        Color color1 = baseColor[800];
                        Color color2 = baseColor[400];

                        final isSelected =
                            contactProvider.isSelectedContact(contact);

                        return Container(
                            child: FlatButton(
                          child: isSelected
                              ? Column(children: <Widget>[
                                  ListTile(
                                      title: Text(contact.displayName),
                                      subtitle: Text(
                                          contact.phones.elementAt(0).value),
                                      leading: CircleAvatar(
                                        child: Icon(
                                          Icons.check,
                                          size: 30.0,
                                          color: AppColors.colorPrimary,
                                        ),
                                        backgroundColor: AppColors.colorWhite,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Divider(
                                        color: AppColors.divider,
                                        height: 1,
                                      ))
                                ])
                              : Column(children: <Widget>[
                                  ListTile(
                                      title: Text(contact.displayName),
                                      subtitle: Text(
                                          contact.phones.elementAt(0).value),
                                      leading: (contact.avatar != null &&
                                              contact.avatar.length > 0)
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  MemoryImage(contact.avatar),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        color1,
                                                        color2,
                                                      ],
                                                      begin:
                                                          Alignment.bottomLeft,
                                                      end: Alignment.topRight)),
                                              child: CircleAvatar(
                                                  child: Text(
                                                      contact.initials(),
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  backgroundColor:
                                                      Colors.transparent))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Divider(
                                        color: AppColors.divider,
                                        height: 1,
                                      ))
                                ]),
                          onPressed: () =>
                              {contactProvider.selectContact = contact},
                        ));
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
