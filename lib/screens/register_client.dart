import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:email_validator/email_validator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:trace_app/screens/login.dart';

class Registrationscreen extends StatefulWidget {
  const Registrationscreen({super.key});

  

  @override
  State<Registrationscreen> createState() => _RegistrationscreenState();
}

 class _RegistrationscreenState extends State<Registrationscreen> {

  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            alignment: Alignment.bottomCenter,
            opacity: 1
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gap(20),
                  const Text('Enter your credentials'),
                  Gap(10),
                  TextFormField(
                    controller: firstName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: const Text('Firstname')
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Required. Please enter your first name.';
                      }
                    },
                  ),
                  Gap(10),
                  TextFormField(
                    controller: lastName,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text('Lastname')
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Required. Please enter your last name.';
                      }
                    },
                  ),
                  Gap(10),
                  TextFormField(
                    controller: email,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Required.';
                      }
                      if(!EmailValidator.validate(value)){
                        return 'Invalid Email';
                      }
                    }, 
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text('Email Address'),
                    ),
                  ),
                  Gap(10),
                  TextFormField(
                    obscureText: hidePassword,
                    controller: password,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Required. Please enter your password.';
                      }
                      if(value.length < 7){
                        return 'Password should be more than 6 characters';
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: const Text('Password'),
                      suffixIcon: IconButton(
                    onPressed: toggleHidePassword,
                    icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                    ),
                  ),
                  Gap(10),
                  TextFormField(
                    obscureText: hidePassword,
                    controller: password,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Required. Please enter your password.';
                      }
                      if(value.length < 7){
                        return 'Password should be more than 6 characters';
                      }
                      if(password.text != value){
                        return 'Password do not match';
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: const Text('Password'),
                    ),
                  ),
                  Gap(15),
                  ElevatedButton(onPressed: register, child: const Text('Create Account', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),), 
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.blue
                  ),
                  ),
                    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void register() {
  //validate
  //register in firebase auth

  if(!formKey.currentState!.validate()){
    return;
  }
  //confirmt to the user
  QuickAlert.show(context: context, type: QuickAlertType.confirm,
  text: 'Are you sure?',
  confirmBtnText: 'YES',
  cancelBtnText: 'NO',
  onConfirmBtnTap: (){
    //register in firebase auth
    Navigator.of(context).pop();
    registerClient();
  },
  );
}

void registerClient () async{

try{
  QuickAlert.show(
 context: context,
 type: QuickAlertType.loading,
 title: 'Loading',
 text: 'Fetching your data',
);
UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email.text, password: password.text);
  //firestore add document
  String user_id = userCredential.user!.uid;
  await FirebaseFirestore.instance.collection('clients').doc(user_id).set({
    'firstname': firstName.text,
    'lastname': lastName.text,
    'email': email.text,
  });
  // .add({
  //   'firstname': firstName.text,
  //   'lastname': lastName.text,
  //   'email': email.text,
  // });
  Navigator.of(context).pop();
  print(userCredential.user!.uid);
} on FirebaseAuthException catch(ex){
  Navigator.of(context).pop();
  var errorTitle = '';
  var errorText = '';
  if(ex.code == 'weak-password'){
    errorText = 'Please enter more than 6 characters';
    errorTitle = 'Weak Password';
  }else if (ex.code == 'email-already-in-use'){
    errorText = 'password is already registered';
    errorTitle = 'please enter a new email';
  }
  QuickAlert.show(context: context, type: 
  QuickAlertType.error,
  title: 'Password is already registered',
  text: 'Please enter a new email'
  );
  
}
}

void toggleHidePassword(){
    setState(() {
      hidePassword = !hidePassword;
    });
  }
}

