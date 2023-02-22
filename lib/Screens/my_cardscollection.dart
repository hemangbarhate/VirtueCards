import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Services/usermodel.dart';
import '../constants/constants.dart';

class MyCollection extends StatefulWidget {
  const MyCollection({Key? key}) : super(key: key);

  @override
  State<MyCollection> createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  @override
  List<Usermodel> mycollection = [];

  var user = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance.collection('users');
  void initState() {
    fetchRecords();
    super.initState();
  }

  fetchRecords() async {
    var records = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('myvisitingcontacts')
        .get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
    var _list = records.docs
        .map((item) => Usermodel(id: item.id, count: item['count']))
        .toList();
    setState(() {
      mycollection = _list;
    });
    for (var i = 0; i < mycollection.length; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(mycollection[i].id)
          .get()
          .then((ds) {
        mycollection[i].name = ds.data()!['name'];
        mycollection[i].phone = ds.data()!['phone'];
        mycollection[i].email = ds.data()!['email'];
        mycollection[i].companyname = ds.data()!['companyname'];
        mycollection[i].designation = ds.data()!['designation'];
      });
      setState(() {
        mycollection[i].name = mycollection[i].name;
        mycollection[i].phone = mycollection[i].phone;
        mycollection[i].email = mycollection[i].email;
        mycollection[i].companyname = mycollection[i].companyname;
        mycollection[i].designation = mycollection[i].designation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "VirtueVisitingCards",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
            )),
      ),
      body: ListView.builder(
        itemCount: mycollection.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(26),
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Name :${mycollection[index].name ?? ''}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Email :${mycollection[index].email ?? ''}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Contact No :${mycollection[index].phone ?? ''}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Company Name :${mycollection[index].companyname ?? ''}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Designation :${mycollection[index].designation ?? ''}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Really ??"),
                                content: const Text(
                                    "Do you want to DELETE ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      firestore.doc(user?.uid).collection('myvisitingcontacts').doc(mycollection[index].id).delete();
                                      fetchRecords();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );

                        },
                      icon: Icon(Icons.delete,size: 32,),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
