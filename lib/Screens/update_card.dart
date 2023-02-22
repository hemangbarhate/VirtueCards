import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visiting_cards/constants/constants.dart';

import '../Services/firebase_auth_methods.dart';
import '../widgets/custom_button.dart';

TextEditingController name = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController designation = TextEditingController();
TextEditingController companyname = TextEditingController();

class UpdateCard extends StatefulWidget {
  const UpdateCard({Key? key}) : super(key: key);

  @override
  State<UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {
  @override
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    final firestore = FirebaseFirestore.instance;

    getUserrbyID() async {
      await firestore.collection('users').doc(user.uid).get().then((ds) {
        name.text = ds.data()!['name'];
        email.text = ds.data()!['email'];
        phone.text = ds.data()!['phone'];
        companyname.text = ds.data()!['companyname'];
        designation.text = ds.data()!['designation'];
      });
    }

    getUserrbyID();
    return Scaffold(
      backgroundColor: kbgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("VirtueVisitingCards",style: TextStyle(color: Colors.white),),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_sharp,color: Colors.white,)),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: name,
              decoration: const InputDecoration(
                icon: Icon(Icons.person,color: Colors.white,),
                hintText: 'Enter your name',
                hintStyle: TextStyle(color: Colors.white),
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
              ),
              validator: (value) {
                if (value != null && value.length < 4) {
                  return 'Enter min. 4 characters';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: email,
              decoration: const InputDecoration(
                icon: Icon(Icons.email_outlined,color: Colors.white,),
                hintText: 'Enter Your Email',
                hintStyle: TextStyle(color: Colors.white),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
              ),
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: phone,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone,color: Colors.white,),
                hintText: 'Enter a phone number',
                hintStyle: TextStyle(color: Colors.white),
                labelText: 'Phone',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.length != 10) {
                  return 'Enter 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: companyname,
              decoration: const InputDecoration(
                icon: Icon(Icons.work,color: Colors.white,),
                hintText: 'Enter Company name',
                hintStyle: TextStyle(color: Colors.white),
                labelText: 'Company Name',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
              ),
              validator: (value) {
                if (value != null && value.length < 4) {
                  return 'Enter min. 4 characters';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: designation,
              decoration: const InputDecoration(
                icon: Icon(Icons.filter_none,color: Colors.white,),
                hintText: 'Enter Designation',
                hintStyle: TextStyle(color: Colors.white),
                labelText: 'Designation',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
              ),
              validator: (value) {
                if (value != null && value.length < 4) {
                  return 'Enter min. 4 characters';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 18,
            ),
            Center(
              child: CustomButton(
                onTap: () {
                  final isValidForm = _formKey.currentState!.validate();
                  if (isValidForm) {
                    firestore.collection('users').doc(user.uid).set({
                      'name': name.text,
                      'email': email.text,
                      'phone': phone.text,
                      'companyname': companyname.text,
                      'designation': designation.text,
                    },SetOptions(merge: true));
                    Navigator.of(context).pushNamedAndRemoveUntil('Home', (route) => false);
                  }
                },
                text:'Submit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
