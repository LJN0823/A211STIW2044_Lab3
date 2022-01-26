import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab3/class/config.dart';
import 'package:lab3/panel/login.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late double screenHeight, screenWidth, resWidth = 0;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final TextEditingController nameEC = TextEditingController();
  final TextEditingController phoneEC = TextEditingController();
  final TextEditingController passEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool clickOn = false;
  String eula = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [lowerHalf(context)],
            ),
          ),
        ),
      ),
    );
  }

  lowerHalf(BuildContext context) {
    return Container(
      width: resWidth,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text("Register",
                          style: TextStyle(
                              fontSize: resWidth * 0.05,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                              width: resWidth * 0.2,
                              child: Text("Name: ",
                                  style: TextStyle(fontSize: resWidth * 0.04))),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Please enter valid name"
                                        : null,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(focus);
                                },
                                controller: nameEC,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.0)))),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: resWidth * 0.2,
                              child: Text("Phone: ",
                                  style: TextStyle(fontSize: resWidth * 0.04))),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 10)
                                        ? "Please enter valid phone number"
                                        : null,
                                focusNode: focus,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(focus1);
                                },
                                controller: phoneEC,
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.0)))),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: resWidth * 0.2,
                              child: Text("Password: ",
                                  style: TextStyle(fontSize: resWidth * 0.04))),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              validator: (val) =>
                                  _validatePassword(val.toString()),
                              focusNode: focus1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus2);
                              },
                              controller: passEC,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0))),
                              obscureText: passwordVisible,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _registerDialog,
                        child: const Text("Register"),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(resWidth / 3, screenHeight / 50)),
                      )
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 10),
          Text("Other Ways",
              style: TextStyle(
                fontSize: resWidth * 0.04,
              )),
          GestureDetector(
            onTap: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Login()))
            },
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: resWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //GestureDetector(
          //  onTap: () => {
          //    Navigator.pop(context)
          //  },
          //  child: Text(
          //    "Back",
          //    style: TextStyle(
          //      fontSize: resWidth * 0.04,
          //      fontWeight: FontWeight.bold,
          //    ),
          //  ),
          //),
        ],
      ),
    );
  }


  String? _validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Please enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerDialog() {
    if (!formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          fontSize: resWidth * 0.04);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            'Register new account?',
            style: TextStyle(),
          ),
          content: const Text("Sure to Register?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _registerUserAccount();
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No")),
          ],
        );
      },
    );
  }

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String name = nameEC.text;
    String phone = phoneEC.text;
    String password = passEC.text;
    FocusScope.of(context).unfocus();
    ProgressDialog dialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    dialog.show();
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/registerdb.php"),
        body: {"name": name, "phone": phone, "password": password}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Successful Registered!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: resWidth * 0.04);
        dialog.dismiss();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: resWidth * 0.04);
        dialog.dismiss();
        return;
      }
    });
  }
}
