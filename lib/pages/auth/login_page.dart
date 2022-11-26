import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:note_pad/pages/auth/sign_up_page.dart';
import 'package:note_pad/pages/home/home_page.dart';
import 'package:note_pad/util/storage_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool secure = true;
  bool isLoading = false;

  final auth = FirebaseAuth.instance;

  login(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      String? uid = credential.user?.uid;
      log(uid!);
      setState(() {
        isLoading = false;
      });
      if (uid != '') {
        StorageUtil.saveId(uid);
        Get.off(() => const HomePage());
      } else {
        Get.snackbar('Error', 'Something went wrong please try again later',
            snackPosition: SnackPosition.BOTTOM);
      }
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
          'Login',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Get.off(() => const SignUpPage());
              },
              child: const Text('Sign Up'),
            ),
          )
        ],
        backgroundColor: Colors.white.withOpacity(0.2),
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator:
            const CircularProgressIndicator(color: Colors.yellow),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                        String email = emailController.text.trim();
                        String password = passController.text.trim();
                        if (email == '' || password == '') {
                          Get.snackbar('Error', 'Fill the form first',
                              snackPosition: SnackPosition.BOTTOM);
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          login(email, password);
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
