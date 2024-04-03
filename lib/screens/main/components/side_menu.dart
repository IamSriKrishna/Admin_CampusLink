import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/screens/main/components/CustomAddpost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuAppController>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Text("KCG Tech")),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () => provider.changeIndex(0),
          ),
          DrawerListTile(
            title: "Add Post",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => CustomAddpost(context),
          ),
          DrawerListTile(
            title: "Feed",
            svgSrc: "assets/icons/menu_task.svg",
            press: () => provider.changeIndex(2),
          ),
          DrawerListTile(
            title: "Search",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () => provider.changeIndex(3),
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () => provider.changeIndex(4),
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () => provider.changeIndex(5),
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () => provider.changeIndex(6),
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () => provider.changeIndex(7),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
