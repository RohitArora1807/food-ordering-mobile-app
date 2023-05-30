import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/provider/my_provider.dart';
import 'package:foodapp/screen/cart_page.dart';
import 'package:foodapp/screen/detail_page.dart';

import 'package:foodapp/screen/home_page.dart';
import 'package:foodapp/screen/login_page.dart';
import 'package:foodapp/screen/sign_up.dart';
import 'package:foodapp/screen/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  runApp(HomePage());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff2b2b2b),
          appBarTheme: AppBarTheme(
            color: Color(0xff2b2b2b),
          ),
        ),
        home: HomePage(),
        // home: StreamBuilder(
        //     stream: FirebaseAuth.instance.authStateChanges(),
        //     builder: (index, sncpshot) {
        //       if (sncpshot.hasData) {
        //         return HomePage();
        //       }
        //       return LoginPage();
        //     }),
      ),
    );
  }
}
