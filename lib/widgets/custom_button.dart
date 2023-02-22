import 'package:flutter/material.dart';
import 'package:visiting_cards/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
            color: kpred,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        margin: EdgeInsets.all(10),
        height: 50,
        width: size.width/2,
        child: Center(child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: textcolor),)),
      ),
    );
  }
}
