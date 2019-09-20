import 'package:contacts_list/helper/contact_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ContactHelper contactHelper = ContactHelper();


  @override
  void initState() {
    super.initState();

    Contact c = Contact();
    c.name = "Name 1";
    c.email = "name1@gmail.com";
    c.phone = "5562981112233";
    c.img = "imgtest";
    contactHelper.saveContact(c);

    contactHelper.getAllContacts().then((list){
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
