import 'dart:io';

import 'package:contacts_list/helper/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactScreen extends StatefulWidget {
  final Contact contact;

  ContactScreen({this.contact});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Contact _editedContact;

  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "New Contact"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
          onPressed: () {
            _saveContact(context, false);
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img))
                          : AssetImage("images/person.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  _showPictureOptions(context);
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
                controller: _nameController,
                focusNode: _nameFocus,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Phone",
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveContact(BuildContext context, bool fromDialog) {
    if (fromDialog) {
      Navigator.pop(context);
    }

    if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
      Navigator.pop(context, _editedContact);
    } else {
      FocusScope.of(context).requestFocus(_nameFocus);
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Save your changes or discard them?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Discard"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: () {
                  _saveContact(context, true);
                },
              ),
            ],
          );
        },
      );

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showPictureOptions(BuildContext context) {
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
                        "Camera",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ImagePicker.pickImage(source: ImageSource.camera)
                            .then((file) {
                          if (file == null) return;
                          setState(() {
                            _editedContact.img = file.path;
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((file) {
                          if (file == null) return;
                          setState(() {
                            _editedContact.img = file.path;
                          });
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
}
