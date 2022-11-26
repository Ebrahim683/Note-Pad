import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:note_pad/pages/auth/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool secure = true;
  bool isLoading = false;

  final auth = FirebaseAuth.instance;

  signUp(String name, String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.off(() => const LoginPage());
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      Get.snackbar('Error', e.message.toString(),
          snackPosition: SnackPosition.BOTTOM);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Get.off(() => const LoginPage());
              },
              child: const Text('Login'),
            ),
          )
        ],
        backgroundColor: Colors.white.withOpacity(0.2),
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: const CircularProgressIndicator(
          color: Colors.yellow,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                obscureText: secure,
                controller: passController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          secure = !secure;
                        });
                      },
                      icon: Icon(secure == true
                          ? Icons.remove_red_eye
                          : Icons.visibility_off)),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: Get.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      String name = nameController.text;
                      String email = emailController.text.trim();
                      String password = passController.text.trim();
                      if (name == '' || email == '' || password == '') {
                        Get.snackbar('Error', 'Fill the form first',
                            snackPosition: SnackPosition.BOTTOM);
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        signUp(name, email, password);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
