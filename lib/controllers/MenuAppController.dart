import 'dart:developer';

import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    log(' Index $selectedIndex');
    _scaffoldKey.currentState!.closeDrawer();
    notifyListeners();
  }
}
