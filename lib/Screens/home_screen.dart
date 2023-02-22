import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visiting_cards/Services/firebase_auth_methods.dart';
import 'package:visiting_cards/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    fetchRecords();
    super.initState();
  }

  var name, phone, email, designation, companyname;

  fetchRecords() async {
    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((ds) {
      name = ds.data()!['name'];
      phone = ds.data()!['phone'];
      email = ds.data()!['email'];
      companyname = ds.data()!['companyname'];
      designation = ds.data()!['designation'];
    });
    setState(() {
      name = name;
      email = email;
      phone = phone;
      companyname = companyname;
      designation = designation;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: kbgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "VirtueVisitingCards",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'GenerateQR');
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ScanQR');
                },
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                )),
            TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Really ??"),
                        content: const Text(
                            "Do you want to LogOut"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<FirebaseAuthMethods>().signOut(context);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('LogOut',style: TextStyle(color: Colors.white),),)
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 20, 12, 10),
              padding: const EdgeInsets.all(6),
              height: size.height / 4,
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'My Visiting Card',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text(
                    '------------------------------------------------------------------------',
                  ),
                  Text(
                    'Name : $name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Email : $email',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Contact No : $phone',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Company Name : $companyname',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Designation : $designation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'UpdateCard');
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        height: size.height / 6,
                        width: size.width / 2.3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/update.png'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
                        ),
                      ),
                      Container(
                        width: size.width / 2.3,
                        height: 25,
                        decoration: const BoxDecoration(
                            color: kpred,
                            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25),bottomRight: Radius.circular(25))),
                        child: const Center(
                            child: Text(
                          'Update Card',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'GenerateQR');
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        height: size.height / 6,
                        width: size.width / 2.3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/share.png'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
                        ),
                      ),
                      Container(
                        width: size.width / 2.3,
                        height: 25,
                        decoration: const BoxDecoration(
                            color: kpblue,
                            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25),bottomRight: Radius.circular(25))),
                        child: const Center(
                            child: Text(
                              'Share',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'MyCollection');
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        height: size.height / 6,
                        width: size.width / 2.3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/mycards2.png'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
                        ),
                      ),
                      Container(
                        width: size.width / 2.3,
                        height: 25,
                        decoration: const BoxDecoration(
                            color: kpblue,
                            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25),bottomRight: Radius.circular(25))),
                        child: const Center(
                            child: Text(
                              'MyCards',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'ScanQR');
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        height: size.height / 6,
                        width: size.width / 2.3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/scanqr.png'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
                        ),
                      ),
                      Container(
                        width: size.width / 2.3,
                        height: 25,
                        decoration: const BoxDecoration(
                            color: kpyellow,
                            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25),bottomRight: Radius.circular(25))),
                        child: const Center(
                            child: Text(
                              'Scan QR',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async{
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Really ??"),
          content:  const Text("Do yo really want to close app?"),
          actions: [
            TextButton(onPressed: (){Navigator.of(context).pop(false);}, child: const Text("No"),),
            TextButton(onPressed: (){Navigator.of(context).pop(true);}, child: const Text("Yes"),),
          ],
        );
      },);
    return exitApp ?? false;
  }
}
