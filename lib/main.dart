import 'dart:html';
import 'package:admin/Api/Leave.dart';
import 'package:admin/Api/OnDuty.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:admin/Api/gatepass.dart';
import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;

void main() async {
  window.document.onContextMenu.listen((evt) => evt.preventDefault());
  js.context.callMethod('eval', [
    "document.onkeydown = function(e) {  if(e.keyCode == 123 /* F12 */) {return false;}}"
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyCishefTquUez42NWNNToO61QKxIomFJkE',
          appId: '1:879927221521:android:f914e304f4ac2da0b1c0b0',
          messagingSenderId: '879927221521',
          projectId: 'campuslink-d1f2d'));
  GatePassUserSheetApi.gatepassinit();
  OnDutyUserSheetApi.ondutyinit();
  LeaveUserSheetApi.leaveinit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KCG College Of Technology',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: MainScreen(),
      ),
    );
  }
}
