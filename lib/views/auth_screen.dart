import 'package:agriculture_app/views/login.dart';
import 'package:agriculture_app/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: "Raithu Mitra"
                  .text
                  .textStyle(GoogleFonts.pacifico(fontSize: 50))
                  .color(Colors.blue)
                  .make(),
              centerTitle: true,
              bottom: TabBar(
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    text: "Login",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    text: "Register",
                  ),
                ],
                indicatorColor: Colors.blue[200],
                indicatorWeight: 6,
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: const TabBarView(children: [LoginPage(), RegisterScreen()]),
            ),
          ),
        ));
  }
}
