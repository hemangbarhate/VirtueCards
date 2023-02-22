import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:visiting_cards/widgets/custom_button.dart';

import '../constants/constants.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  var getResult = 'QR Code Result';
  var user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    scanQRCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      SizedBox(
        width: 300,
        height: 80,
        child: CustomButton(
          onTap: () {
            scanQRCode();
          },
          text: 'Scan QR',
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
      Center(
        child: Text(
          getResult,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
          SizedBox(height: 25,),
          SizedBox(
            width: size.width / 2.5,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, 'MyCollection');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kpsky),
              ),
              icon: const Icon(
                Icons.collections_bookmark_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'MyCards',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ffffff', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      int count = 0;
      await firestore.collection('users').doc(user?.uid).get().then((ds) {
        count = ds.data()!['count'];
      });
      if (count < 100) {
        if (qrCode.length == 28) {
          count++;
          await firestore
              .collection('users')
              .doc(user?.uid)
              .set({'count': count}, SetOptions(merge: true));
          firestore
              .collection('users')
              .doc(user?.uid)
              .collection('myvisitingcontacts')
              .doc(qrCode)
              .set({'count': count});
          setState(() {
            getResult = 'Card is added to MyCollection';
          });
        } else {
          setState(() {
            getResult = 'Only VirtueBytes QR are supported';
          });
        }
      } else {
        setState(() {
          getResult = 'Free Visiting Cards Limit reached';
        });
      }
    } on PlatformException {
      getResult = 'Failed to scan QR Code.';
    }
  }
}
