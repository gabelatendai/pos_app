import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/root_widget.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pos_app/screens/Items.dart';

import './screens/error.dart';
import './screens/welcome.dart';
import './screens/login.dart';
import './screens/forget.dart';
import './screens/register.dart';
import './screens/home.dart';
import './screens/charge.dart';
import './screens/products.dart';
import './screens/product.dart';
import './screens/receipts.dart';
import './screens/support.dart';
import './screens/settings.dart';
import './screens/profile.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _islogged = false;
  String _initialRoute = '/welcome';

  @override
  void initState() {
    super.initState();
    if (_islogged) {
      _initialRoute = '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' POS',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: _initialRoute,
      // routes: {
      //   '/': (context) => HomeScreen(),
      //   '/welcome': (context) => WelcomeScreen(),
      //   '/login': (context) => LoginScreen(),
      //   '/forget': (context) => ForgetPasswordScreen(),
      //   '/register': (context) => RegisterScreen(),
      //   '/home': (context) => HomeScreen(),
      //   '/profile': (context) => ProfileScreen(),
      //   '/charge': (context) => ChargeScreen(),
      //   '/items': (context) => ProductScreen(),
      //   '/receipts': (context) => ReceiptScreen(),
      //   '/singleproduct': (context) => SingleProductScreen(),
      //   '/support': (context) => SupportScreen(),
      //   '/settings': (context) => SettingScreen(),
      //   '/error': (context) => ErrorScreen(),
      //
      // },
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/welcome', page: () => WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/forget', page: () => ForgetPasswordScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/charge', page: () => ChargeScreen()),
        GetPage(name: '/items', page: () => ItemScreen()),
        GetPage(name: '/receipts', page: () => ReceiptScreen()),
        GetPage(name: '/singleproduct', page: () => SingleProductScreen()),
        GetPage(name: '/support', page: () => SupportScreen()),
        GetPage(name: '/settings', page: () =>SettingScreen()),
        GetPage(name: '/error', page: () =>ErrorScreen()),
      ],
    );
  }
}
