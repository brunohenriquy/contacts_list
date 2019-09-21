import 'dart:io';

import 'package:contacts_list/helper/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_screen.dart';

enum OrderOptions { orderaz, orderza }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContactHelper contactHelper = ContactHelper();

  List<Contact> _contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A -Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z -A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactScreen();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _contacts[index].img != null
                        ? FileImage(File(_contacts[index].img))
                        : AssetImage("images/person.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      _contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text(
                        "Call",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        launch("tel:${_contacts[index].phone}");
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showContactScreen(contact: _contacts[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        contactHelper.deleteContact(_contacts[index].id);
                        setState(() {
                          _contacts.removeAt(index);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          onClosing: () {},
        );
      },
    );
  }

  void _showContactScreen({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactScreen(contact: contact),
        ));

    if (recContact != null) {
      if (contact != null) {
        await contactHelper.updateContact(recContact);
      } else {
        await contactHelper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    contactHelper.getAllContacts().then((list) {
      setState(() {
        _contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        _contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        _contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }

    setState(() {});
  }
}
