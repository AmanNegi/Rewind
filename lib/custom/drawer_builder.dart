import 'dart:math';

import 'package:birthday_reminder/app_theme.dart';
import 'package:birthday_reminder/custom/hex_Color.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:share/share.dart';

class DrawerBuilder extends StatefulWidget {
  @override
  _DrawerBuilderState createState() => _DrawerBuilderState();
}

class _DrawerBuilderState extends State<DrawerBuilder>
    with SingleTickerProviderStateMixin {
  var height, width;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: 2.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));
    super.initState();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 0.3 * height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 0.155 * height,
                  color: HexColor("#434343"),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/rewind.png",
                        height: 125,
                        width: 125,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Mdi.themeLightDark),
            title: Text("Dark Mode"),
            trailing: Switch(
              activeColor: Theme.of(context).accentColor,
              value: appTheme.value,
              onChanged: (value) => toggleDarkTheme(value),
            ),
            onTap: () => toggleDarkTheme(!appTheme.value),
          ),
          ListTile(
            leading: Icon(Mdi.shareVariant),
            title: Text("Share the app"),
            onTap: () => Share.share(
              "Get notified of your loved one's birthday every year and remind them they are special for you❤️\n\nCheck out this app on play store https://play.google.com/store/apps/details?id=com.aster.rewind",
            ),
          ),
          ListTile(
            leading: Icon(Mdi.informationOutline),
            title: Text("About Rewind"),
            onTap: () => showAboutDialog(
                context: context,
                applicationIcon: Image.asset(
                  "assets/rewind.png",
                  height: 100,
                  width: 100,
                ),
                applicationName: "Rewind",
                applicationVersion: "1.0.0",
                applicationLegalese: "@Aster, Inc 2020"),
          ),
          Spacer(),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(
                    0.0, animation.value * height, 0.0),
                child: Column(
                  children: <Widget>[
                    Transform.rotate(
                      angle: controller.value * pi,
                      child: FloatingActionButton(
                        heroTag: "tag",
                        elevation: 0,
                        backgroundColor: Colors.deepOrange,
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(
                      height: 0.05 * height,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
