import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:world_talk/providers/auth.dart';
import 'package:world_talk/providers/google_sign_in.dart';

enum AuthMode { Signup, Login }

class SignUp extends StatefulWidget {
  static const routeName = 'signUpScreen';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 135, 71),
        // title: Container(
        //   width: 40,
        //   height: 40,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     backgroundImage: AssetImage('assets/image/twitter.png'),
        //   ),
        //
        // ),
        // centerTitle: true,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back, color: const Color(0xFF909093)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background2.jpg'), fit: BoxFit.cover),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(
                  0), // This container must be present and it can be transparent.
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const AnimatedOpacity(
                          opacity: 1,
                          duration: Duration(milliseconds: 1600),
                          child: Text(
                            'Go in or sign up\n to see what the world \n has for you ;)',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AnimatedOpacity(
                            opacity: 1,
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              width: 320,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  AuthCard(),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLogin = true;
  bool _obscureConfimPass = true;
  bool _obscurePass = true;
  Color _obscureTextColor = Colors.amber;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'userName': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  // void _switchAuthMode() {
  //   if (_authMode == AuthMode.Login) {
  //     setState(() {
  //       _authMode = AuthMode.Signup;
  //     });
  //   } else {
  //     setState(() {
  //       _authMode = AuthMode.Login;
  //     });
  //   }
  // }

  void changeObscureConfimPass() {
    setState(() {
      _obscureConfimPass = !_obscureConfimPass;
    });
  }

  void changeObscurePass() {
    setState(() {
      _obscurePass = !_obscurePass;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      print('not valid');
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    // Sign user up
    await Provider.of<Authen>(context, listen: false).submitAuthForm(
        _authData['email'].toString().trim(),
        _authData['password'].toString().trim(),
        _authData['userName'].toString().trim(),
        _isLogin,
        context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    // final String label1 = Text('d');
    return Container(
      // height: _authMode == AuthMode.Signup ? 320 : 260,
      // constraints:
      //     BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
      // width: deviceSize.width * 0.75,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Word Mail eg "Cleion@WorldMail.com"',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 34, 250, 128)))),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@WorldMail.com')) {
                    return 'Invalid email!, please end your email with @WorldMail.com ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.blueAccent),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () => changeObscurePass(),
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color:
                              _obscurePass ? Colors.black : _obscureTextColor,
                        ))),
                obscureText: _obscurePass,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_isLogin == false)
                TextFormField(
                  enabled: _isLogin == false,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffixIcon: IconButton(
                          color: _obscureConfimPass
                              ? Colors.black
                              : _obscureTextColor,
                          onPressed: () {
                            changeObscureConfimPass();
                          },
                          icon: Icon(Icons.remove_red_eye_outlined))),
                  obscureText: _obscureConfimPass,
                  validator: _isLogin == false
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                      : null,
                ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'UserName',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent))),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter userName';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['userName'] = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Container(
              //   // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              //   decoration: const BoxDecoration(
              //       border: Border(bottom: BorderSide(color: Colors.grey))),
              //   child: TextField(
              //     style: const TextStyle(
              //       color: Colors.white,
              //     ),
              //     decoration: InputDecoration(
              //         fillColor: Colors.white,
              //         hintText: "UserName",
              //         hintStyle:
              //             const TextStyle(color: Colors.grey, fontSize: 14),
              //         border: new UnderlineInputBorder(
              //             borderSide:
              //                 new BorderSide(color: Colors.blueAccent))),
              //   ),
              // ),
              const SizedBox(
                height: 60,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  child: Text(_isLogin == true ? 'LOGIN' : 'SIGN UP'),
                  onPressed: () => _submit(),
                  style: ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              TextButton(
                child: Text('${_isLogin == true ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                onPressed: () => setState(() {
                  _isLogin = !_isLogin;
                }),
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
              const SizedBox(height: 20),
              const AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 1600),
                child: Text(
                  'Or go in with another\naccount.',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 1600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Provider.of<GoogleSignInPRovider>(context,
                                  listen: false)
                              .googleSignUp(context);
                        },
                        icon: SvgPicture.asset(
                          "assets/icons/icons-google.svg",
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
