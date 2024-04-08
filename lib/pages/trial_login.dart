// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class TrialLogin extends StatefulWidget {
  const TrialLogin({super.key});

  @override
  State<TrialLogin> createState() => _TrialLoginState();
}

class _TrialLoginState extends State<TrialLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  late String _email, _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                showCursor: true,
                onChanged: (value) {
                  _email = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Email';
                  } else if (!value.contains("@")) {
                    return '@ is missing';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                showCursor: true,
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  return value!.isEmpty ? 'Password is required' : null;
                },
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.deepPurple[300],
                child: MaterialButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      return print('Success');
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
