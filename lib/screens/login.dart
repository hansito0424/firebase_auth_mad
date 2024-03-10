import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:trace_app/screens/home.dart';
import 'package:trace_app/screens/register_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  void toggleHidePassword(){
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void login () async {
    //validate input
    //login
    if (formKey.currentState!.validate()){
      EasyLoading.show(status: 'Please wait');
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text).then((User) {
        EasyLoading.dismiss();
        Navigator.of(context).push(CupertinoPageRoute(builder: (__) => HomeScreen()));
      }).catchError((error){
        print(error);
        EasyLoading.showError('Incorrect Email and/or Password');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_back.webp'),
            alignment: Alignment.bottomCenter,
            opacity: 0.5,
          )
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Please enter your Email and Password to Login'),
              const Gap(12),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: const Text('Email address'),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'email is required';
                  }
                  return null;
                },
              ),
              const Gap(12),
              TextFormField(
                controller: password,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: const Text('Password'),
                  suffixIcon: IconButton(
                    onPressed: toggleHidePassword,
                    icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'password is required';
                  }
                  return null;
                },
              ),
              const Gap(12),
              ElevatedButton(onPressed: login, child: const Text('Login'),
              ),
              const Gap(12),
              ElevatedButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (__) => Registrationscreen()));
                  }, child: const Text('Register'),
                  ),
            ],
          ),
        ),
      )
    );
  }
}