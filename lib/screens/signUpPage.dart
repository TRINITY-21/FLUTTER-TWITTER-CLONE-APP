
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterClone/provider/userProvider.dart';
import 'package:twitterClone/screens/loginPage.dart';
import 'package:twitterClone/screens/policyPage.dart';
import 'package:twitterClone/utils/googleFont.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

 

  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                    SizedBox(width: 2),
                    Text("Me",
                        style: googleFont(20, Colors.purple, FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Register",
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
                      controller: usernameController,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        userProvider.changeName(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Username",
                        labelStyle:
                            googleFont(15, Colors.purple, FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.purple),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, right: 20),
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (value) {
                        userProvider.changeEmail(value);
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Email",
                        labelStyle:
                            googleFont(15, Colors.purple, FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.purple),
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
                        labelStyle:
                            googleFont(15, Colors.purple, FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.purple),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    userProvider.saveUser();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 4,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text("Register",
                        style: googleFont(15, Colors.purple, FontWeight.w700)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Agree To Terms?",
                      style: googleFont(15, Colors.white),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PolicyPage()));
                      },
                      child: Text("Terms",
                          style:
                              googleFont(15, Colors.purple, FontWeight.w700)),
                    )
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Designed By",
                      style: googleFont(10, Colors.white),
                    ),
                    SizedBox(width: 4),
                    Text("Trinity",
                        style: googleFont(10, Colors.purple, FontWeight.w700)),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
