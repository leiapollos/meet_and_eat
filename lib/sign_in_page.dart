import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:meet_and_eat/home_page.dart';
import 'package:provider/provider.dart';

/*class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
            ),
            obscureText: true,
          ),
          RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
            child: Text("Sign in"),
          )
        ],
      ),
      ),
    );
  }
}*/
class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);


  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/login_background.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        Container(
        height: 100.0,
        child: Image.asset('assets/images/logo.png'),
        ),
        SizedBox(
        height: 48.0,
        ),
        TextField(
        controller: emailController,
        decoration: InputDecoration(
          filled: true,
        fillColor: Colors.white,
        hintText: 'Enter your email',
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Color(0xff3d405b), width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Color(0xff3d405b), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        ),
        ),
        SizedBox(
        height: 8.0,
        ),
        TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
        fillColor: Colors.white,
        hintText: 'Enter your password.',
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Color(0xff3d405b), width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Color(0xff3d405b), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        ),

        ),
        SizedBox(
        height: 24.0,
        ),
        Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
        color: Color(0xff81b29a),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
        onPressed: () {
        _logIn();
        },
        minWidth: 200.0,
        height: 42.0,
        child: Text(
        'Log In',style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300)
        ),
        ),
        ),
        ),
        Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
        color: Color(0xff81b29a),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
        onPressed: () {
        _register();
        },
        minWidth: 200.0,
        height: 42.0,
        child: Text(
        'Register', style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300)
        ),
        ),
        ),
        ),
        ],
        ),
        ),
        ),
      ],
    );
  }

  _logIn() async{
      String text = await context.read<AuthenticationService>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if(text != "Success")
        _showMaterialDialog(text);
  }

  _register() async{
    String text = await context.read<AuthenticationService>().signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if(text != "Success")
      _showMaterialDialog(text);
  }

  _showMaterialDialog(String text) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Error"),
          content: new Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('Close me!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

}


