import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pos_app/screens/item/master_item.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Point Of Sell',
    packageName: 'Flutter',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text('${title} ${subtitle ?? 'Not set'}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 11,
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://helpx.adobe.com/content/dam/help/en/stock/how-to/visual-reverse-image-search/jcr_content/main-pars/image/visual-reverse-image-search-v2_intro.jpg'),
                        fit: BoxFit.cover),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.shareicon.net/download/2015/09/18/103157_man_512x512.png"),
                  ),
                  accountName: Text("Mobile Point Of Sell"),
                  accountEmail: Text("gabrielmusodza@gmail.com"),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text("Sales"),
                  onTap: () => Navigator.of(context).pushNamed('/home'),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text("Receipts"),
                  onTap: () => Navigator.of(context).pushNamed('/receipts'),
                ),ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text("PDF"),
                  onTap: () => Navigator.of(context).pushNamed('/charge'),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.menu),
                  title: Text("Items"),
                  onTap: () => Navigator.of(context).pushNamed('/items'),
                ),
                Divider(
                  height: 1,
                ),ListTile(
                  leading: Icon(Icons.menu),
                  title: Text("Products"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExampleScreen()),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text("Feedback"),
                  onTap: () => {}
                      // Navigator.of(context).pushNamed('/data'),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.place),
                  title: Text("Back Office"),
                  onTap: () => print("object"),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  onTap: () => Navigator.of(context).pushNamed('/settings'),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text("Profile"),
                  onTap: () => Navigator.of(context).pushNamed('/profile'),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.report),
                  title: Text("Support"),
                  onTap: () => Navigator.of(context).pushNamed('/support'),
                ),
              ],
            ),
          ),
          Divider(height: 1,),
          Align(
            alignment: Alignment.bottomLeft,
            child: _infoTile('Version :', _packageInfo.version),
          )
        ],
      ),
    );
  }
}
