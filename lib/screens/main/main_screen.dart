import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/Students/StudentScreen.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/dashboard/components/recent_files.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      appBar: PreferredSize(
        child: Header(
search: search,
        ),
        preferredSize: Size.fromHeight(60),
      ),
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Consumer<MenuAppController>(
              builder: (BuildContext context, MenuAppController value,
                      Widget? child) =>
                  Expanded(
                flex: 5,
                child: switchClass(value.selectedIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget switchClass(final int altMenuIndex) {
  Widget degisenMenu() {
    switch (altMenuIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return StudentScreen(search: search,);
      case 2:
        return DashboardScreen(); // You may replace this with the appropriate widget
      case 3:
        return DashboardScreen(); // You may replace this with the appropriate widget
      default:
        return Container(
          child: Center(
            child: Text("Invalid Value"),
          ),
        );
    }
  }

  return degisenMenu();
}
}


