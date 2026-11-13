import 'package:flutter/material.dart';
import 'package:nicnic/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  Future<bool>cekLogin()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") !=null;
  }


  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CRUD LARAVEL FLUTTER',
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo
    ),
    home: FutureBuilder(
      future: cekLogin(),
      builder: (context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if(snapshot.data==true){
        return const HomePage();
      }
      return const LoginPage();
      }
    ),
   );
  }
}
