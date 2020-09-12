import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterClone/provider/userProvider.dart';
import 'package:twitterClone/screens/homePage.dart';
import 'package:twitterClone/screens/signUpPage.dart';
import 'package:twitterClone/utils/googleFont.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 100.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome to",
                    style: googleFont(20, Colors.white, FontWeight.w300)),
                SizedBox(width: 5),
                Text("Tweet",
                    style: googleFont(20, Colors.white, FontWeight.w500)),
                SizedBox(width:2 ),
                Text("Me",
                    style: googleFont(20, Colors.purple, FontWeight.bold)),
              ],
            ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Login",
                  style: googleFont(15, Colors.white, FontWeight.bold),
                ),
                Container(
                  width: 64,
                  height: 64,
                  child: Image.asset('assets/logo.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, right: 20),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        userProvider.changeEmail(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Email",
                        labelStyle: googleFont(15,Colors.purple,FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.email, color:Colors.purple),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, right: 20),
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      onChanged: (value) {
                        userProvider.changePassword(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Password",
                        labelStyle: googleFont(15,Colors.purple,FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.lock, color:Colors.purple),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    userProvider.signIn();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 4,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text("Login",
                        style: googleFont(15, Colors.purple, FontWeight.w700)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Need an Account?",
                      style: googleFont(15,Colors.white),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpPage()));
                      },
                      child: Text("Register",
                          style:
                              googleFont(15, Colors.purple, FontWeight.w700)),
                    ),
                  ],
                ),
                  SizedBox(height: 80),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Designed By",
                      style: googleFont(10,Colors.white),
                    ),
                    SizedBox(width: 4),
                    Text("Trinity",
                        style:
                            googleFont(10, Colors.purple, FontWeight.w700)),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
