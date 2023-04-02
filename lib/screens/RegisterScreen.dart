import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
          appBar: AppBar(title: const Text("Create account"), backgroundColor: Colors.greenAccent,),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const SizedBox(height: 40),
              TextField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(width: 200, child: ElevatedButton(onPressed: signUp, style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.greenAccent)), child: const Text("Create account"),))
            ]))));
  }

  Future signUp() async {
    try {
      // create user
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
      );

      // create user details
      final user = <String, String> {
        "name": nameController.text.trim()
      };

      await FirebaseFirestore.instance.collection("/user-profiles").doc(credentials.user!.uid).set(user);

      if (!mounted) {
        return;
      }
    Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "An error occured while creating the account";
      if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "The account already exists";
      }
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Unable to create account"),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Ok"))
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
