import 'package:flutter/material.dart';
import 'package:flutter_gram/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyAav3b7-VRahhWmS6A1mNf89lFuL-PXYIs',
            appId: 'fluttergram-app-ab10b.firebaseapp.com',
            messagingSenderId: '180902736377',
            projectId: 'fluttergram-app-ab10b',
            storageBucket: 'fluttergram-app-ab10b.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      home: SignUpScreen(),
    );
  }
}
