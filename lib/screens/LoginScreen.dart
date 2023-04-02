import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const SizedBox(height: 40),
              const Text("Login"),
              TextField(
                controller: emailController,
                // cursorColor: Colors.white, //FIXME: culori
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: passwordController,
                // cursorColor: Colors.white, //FIXME: culori
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: signIn, child: const Text("Sign In"))
            ])));
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }
}
