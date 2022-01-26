import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab3/class/config.dart';
import 'package:lab3/class/user.dart';
import 'package:lab3/panel/mainpage.dart';
import 'package:lab3/panel/register.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late double screenWidth, screenHeight, resWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final TextEditingController phoneEC = TextEditingController();
  final TextEditingController passEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return SafeArea(
      child: Center(
          child: SingleChildScrollView(
              child: Column(children: [
        Container(
            width: resWidth,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(children: [
              Card(
                  elevation: 10,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                      child: Form(
                          key: formKey,
                          child: Column(children: [
                            Text("Login",
                                style: TextStyle(
                                    fontSize: resWidth * 0.05,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                    width: resWidth * 0.2,
                                    child: Text("Phone: ",
                                        style: TextStyle(
                                            fontSize: resWidth * 0.04))),
                                Expanded(
                                  child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      validator: (val) => val!.isEmpty ||
                                              (val.length < 10)
                                          ? "Please enter valid phone number"
                                          : null,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus);
                                      },
                                      controller: phoneEC,
                                      keyboardType: const TextInputType
                                          .numberWithOptions(),
                                      decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 1.0)))),
                                )],
                            ),
                            Row(children: [
                              SizedBox(
                                  width: resWidth * 0.2,
                                  child: Text("Password: ",
                                      style: TextStyle(
                                          fontSize: resWidth * 0.04))),
                              Expanded(
                                  child: TextFormField(
                                textInputAction: TextInputAction.done,
                                validator: (val) => val!.isEmpty
                                    ? "Please enter a password"
                                    : null,
                                focusNode: focus,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(focus1);
                                },
                                controller: passEC,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.0))),
                                obscureText: true,
                              ))
                            ]),
                            ElevatedButton(
                              onPressed: _loginUser,
                              child: const Text("Login"),
                              style: ElevatedButton.styleFrom(
                                  fixedSize:
                                      Size(resWidth / 3, screenHeight / 50)),
                            ),
                            GestureDetector(
            onTap: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Register()))
            },
            child: Text(
              "Register",
              style: TextStyle(
                fontSize: resWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
                          ]))))
            ]))
      ]))),
    );
  }

  void _loginUser() {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    ProgressDialog dialog = ProgressDialog(context,
        message: const Text("Please wait..."), title: const Text("Login User"));
    dialog.show();
    String phone = phoneEC.text;
    String password = passEC.text;
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/logindb.php"),
        body: {"phone": phone, "password": password}).then((response) {
      if (response.statusCode == 200 && response.body != "failed") {
        final jsonResponse = jsonDecode(response.body);
        User user = User.fromJson(jsonResponse);
        //print(user.datereg);
        Fluttertoast.showToast(
            msg: "Successful Login!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: resWidth * 0.04);
        dialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(user:user)));
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: resWidth * 0.04);
        dialog.dismiss();
      }
    });
  }
}
