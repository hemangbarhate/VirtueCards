import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:visiting_cards/widgets/custom_button.dart';
import '../Services/firebase_auth_methods.dart';
import '../constants/constants.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({Key? key}) : super(key: key);

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  @override
  void initState(){
    fetchRecords();
    super.initState();
  }
  var name,phone,email,designation,companyname;

  fetchRecords() async{
    var user = FirebaseAuth.instance.currentUser;
     await FirebaseFirestore.instance.collection('users').doc(user?.uid).get().then((ds){
      name = ds.data()!['name'];
      phone = ds.data()!['phone'];
      email = ds.data()!['email'];
      companyname = ds.data()!['companyname'];
      designation = ds.data()!['designation'];
    });
    setState(() {
      name =name;
      email =email;
      phone = phone;
      companyname = companyname;
      designation = designation;
    });
  }


  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

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
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: QrImage(
              data: user.uid,
              backgroundColor: Colors.white,
              version: QrVersions.auto,
              size: 300,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          NewWidget(name: name, email: email, phone: phone, companyname: companyname, designation: designation),
          CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: "Go Back")
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.companyname,
    required this.designation,
  }) : super(key: key);

  final name;
  final email;
  final phone;
  final companyname;
  final designation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name : $name'),
          Text('Email : $email'),
          Text('Contact No : $phone'),
          Text('Company Name : $companyname'),
          Text('Designation : $designation'),
        ],
      ),
    );
  }
}
