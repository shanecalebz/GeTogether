import 'package:flutter/material.dart';
import 'package:getogether/screens/bottom_nav_screen.dart';
import '../screens/home_screen.dart';
import '../utils/colors_utils.dart';
import '../widgets/reusable_widget.dart';
import 'CreateAccount.dart';
import 'Methods.dart';
import 'ResetPassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  bool wrongEntry = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("E65100"),
              hexStringToColor("FB8C00"),
              hexStringToColor("FFB74D"),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 20,
              ),
              SizedBox(
                height: size.height / 50,
              ),
              Container(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Text(
                      "GeTogether",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 10,
              ),
              Container(
                width: size.width,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: reusableTextField(
                      "Enter Email", Icons.person_outline, false, _email),
                ),
              ),
              Container(
                width: size.width,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: reusableTextField("Enter Password",
                      Icons.lock_outline, true, _password),
                ),
              ),
              AnimatedSize(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.fastOutSlowIn,
                  child: wrongEntry ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.info,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                ),
                                Text(
                                  "Wrong email / password",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: forgetPassword(context),
                      ),
                    ],
                  ) :
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: forgetPassword(context),
                  )
              ),
              SizedBox(
                height: size.height / 10,
              ),
              customButton(size),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CreateAccount())),
                child: Row(
                    children: [
                      const Text("Don't have account?",
                          style: TextStyle(color: Colors.white70)),
                      const Text(
                        " Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (isLoading == false) {

          setState(() {
            wrongEntry = false;
          });

          if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
            setState(() {
              isLoading = true;
            });

            logIn(_email.text, _password.text).then((user) {
              if (user != null) {
                print("Login Successful");
                setState(() {
                  isLoading = false;
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) => BottomNavScreen()));
              } else {
                print("Login Failed");
                setState(() {
                  isLoading = false;
                  wrongEntry = true;
                });
              }
            });
          } else {
            print("Please fill form correctly");
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90), color: Colors.white),
          alignment: Alignment.center,
          child: AnimatedSize(
            duration: Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            child: isLoading ? SizedBox(
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator()
            ) :
            Text(
              "Log In",
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

Widget forgetPassword(BuildContext context) {
  return Container(
    height: 35,
    alignment: Alignment.bottomRight,
    child: TextButton(
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.right,
      ),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResetPassword())),
    ),
  );
}
