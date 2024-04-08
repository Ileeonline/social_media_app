import 'package:flutter/material.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/pages/register_page.dart';
class LoginOrRegester extends StatefulWidget {
  const LoginOrRegester({super.key});

  @override
  State<LoginOrRegester> createState() => _LoginOrRegesterState();
}

class _LoginOrRegesterState extends State<LoginOrRegester> {

bool showLoginPage=true;

void togglePages(){
  setState(() {
    showLoginPage   =   !showLoginPage;
  });
}


  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginScreen(onTap: togglePages);
    }else {
     return RegesterPage(onTap: togglePages);
    }
  }
}