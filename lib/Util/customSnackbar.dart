import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context,required String text}){
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.all(10),
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      content:Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white
                ),
                ),
            ),
          ],
        ),
      )
      
    )
  );
}