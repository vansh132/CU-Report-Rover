import 'package:flutter/material.dart';
import 'package:report/services/auth_services.dart';
import 'package:report/theme/theme_ext.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthServices authServices = AuthServices();

  void login() async {
    await authServices.readData(
        _usernameController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final appColors = context.appColors;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/christ.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          color: Colors.white.withOpacity(0.9),
          width: width * 0.3,
          height: height * 0.5,
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      color:
                          Colors.grey[700], // Professional-looking label color
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey, // Border color when enabled
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appColors.primary, // Border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white, // Background color
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black, // Text color
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      color:
                          Colors.grey[700], // Professional-looking label color
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey, // Border color when enabled
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appColors.primary, // Border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white, // Background color
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black, // Text color
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_loginFormKey.currentState!.validate()) login();
                    },
                    child: const Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
