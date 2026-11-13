import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'package:nicnic/services/api_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final ApiService api=ApiService();
  bool isLoading=false;

 Future<void>login()async{
  String? token=await api.login(
    emailController.text,
    passwordController.text,
  );
  if(token!=null){
    SharedPreferences pref= await SharedPreferences.getInstance();
    await pref.setString("token", token);
    Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (_)=>const HomePage(),
    ),
     );
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Gagal"),
      ),
    );
  }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(Icons.shopping_bag,
              size: 50,color: Colors.indigo,
              ),
              const SizedBox(height: 10,),
              const Text("Aplikasi CRUD",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                   child: const Text("LOGIN"),
                   ),
              )
            ],
          ),
          ),
        ))
    );
  }
}