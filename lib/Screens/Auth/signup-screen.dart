import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:e_pharmacy/Screens/Auth/login-screen.dart';
import 'package:e_pharmacy/constants/photos/photos.dart';
import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = "sign up";
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

String? role;

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
// final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController =
      TextEditingController(); // Moved inside _SignUpPageState
  @override
  void dispose() {
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    role = null;
    // Reset form on page dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 50),
                Image.asset(Photos.signUp, height: 200),
                SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'signup',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: role == "Pharmacy"
                                  ? MaterialStateProperty.all(Colors.green)
                                  : MaterialStateProperty.all(
                                      Colors.transparent),
                            ),
                            onPressed: () {
                              setState(() {
                                role = "Pharmacy";
                              });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.admin_panel_settings_rounded,
                                    size: 50,
                                  ),
                                  Text(
                                    "Pharmacy",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: role == "User"
                                  ? MaterialStateProperty.all(Colors.green)
                                  : MaterialStateProperty.all(
                                      Colors.transparent),
                            ),
                            onPressed: () {
                              setState(() {
                                role = "User";
                              });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.person_2_rounded,
                                    size: 50,
                                  ),
                                  Text(
                                    "User",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "name-error";
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "name",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          }
                          final phoneRegExp =
                              RegExp(r'^(010|011|012|015)\d{8}$');
                          if (!phoneRegExp.hasMatch(value)) {
                            return "Invalid Egyptian phone number. It must be 11 digits starting with 010, 011, 012, or 015.";
                          }
                          return null;
                        },
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Phone Number",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "empty-email-error";
                          }
                          final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+",
                          ).hasMatch(value);
                          if (!emailValid) {
                            return "email-error";
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Enter email",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          final RegExp regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                          );
                          if (value == null || value.isEmpty) {
                            return 'empty-pass-error';
                          } else if (!regex.hasMatch(value)) {
                            return 'empty-pass-error-s';
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Enter password",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 15,
                          shadowColor: Color(0xff212529),
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              role != null) {
                            FirebaseFunctions.SignUp(
                              emailController.text,
                              passwordController.text,
                              age: int.parse(ageController.text),
                              userName: nameController.text,
                              role: role!,
                              onSuccess: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(Photos.create),
                                          SizedBox(height: 16),
                                          Text(
                                            "Please Verify Your Email Address to Login",
                                            style: TextStyle(fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );

                                Timer(
                                  Duration(seconds: 3),
                                  () {
                                    Navigator.pushNamed(
                                        context, LoginPage.routeName);
                                  },
                                );
                              },
                              onError: (e) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                            ageController.clear();
                          } else if (role == null &&
                              formKey.currentState!.validate()) {
                            final snackBar = SnackBar(
                              showCloseIcon: false,
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Error',
                                message: 'Please choose your role',
                                inMaterialBanner: true,
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                              showCloseIcon: false,
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Error',
                                message: 'Please fill all the fields',
                                inMaterialBanner: true,
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        },
                        child: Text(
                          "submit",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginPage.routeName);
                        },
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: "Have an account  ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            children: [
                              TextSpan(
                                text: "login",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
