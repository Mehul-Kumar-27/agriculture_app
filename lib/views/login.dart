import 'package:agriculture_app/views/auth_screen.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/home_screen.dart';
import 'package:agriculture_app/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _username;
  late String _email;
  late String _password;
  bool _obscureText = true;

  formValidation() {
    if (_username.isNotEmpty && _email.isNotEmpty && _password.isNotEmpty) {
      /// LOGIN
      ///
      loginSeller();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
                message: "Please fill the required fields");
          });
    }
  }

  loginSeller() async {
    User? currentUser;

    showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(message: "Checking Credentials....");
        });

    await firebaseAuth
        .signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim())
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(message: error.message.toString());
          });
    });

    if (currentUser != null) {
      Navigator.pop(context);
      FirebaseFirestore.instance
          .collection("seller")
          .doc(currentUser!.uid)
          .get()
          .then((snapshot) {
        if (snapshot.data()!["sellerName"] == _username) {
          readSetDataLocally(currentUser!);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(message: "Incorrect Username !");
              });
        }
      });
    }
  }

  Future readSetDataLocally(User currentUser) async {
    FirebaseFirestore.instance
        .collection("seller")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!
            .setString("name", snapshot.data()!["sellerName"]);

        await sharedPreferences!
            .setString("email", snapshot.data()!["sellerEmail"]);

        await sharedPreferences!
            .setString("photoUrl", snapshot.data()!["sellerAvaratUrl"]);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        firebaseAuth.signOut();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AuthScreen()));

        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                  message: "No records found for the seller !");
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Material(
                elevation: 4,
                child: Image.asset(
                  "assets/images/login_image.png",
                  height: 270,
                ),
              ),
            ).px8().py12(),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: (15),
                    color: Colors.deepPurple,
                  ),
                ).px16().py2(),
                SizedBox(
                  height: (50),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[100],
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      hintText: 'What should we call you ?',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular((6.94)),
                        ),
                      ),
                    ),
                    onChanged: ((value) {
                      setState(() {
                        _username = value;
                      });
                    }),
                  ),
                ).px8(),
                const SizedBox(
                  height: 20,
                ),
                //////////////////////////////////////////////////////////////////////////////////
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: (15),
                    color: Colors.deepPurple,
                  ),
                ).px16().py2(),
                SizedBox(
                  height: (50),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[100],
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      hintText: 'someone@gmail.com',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular((6.94)),
                        ),
                      ),
                    ),
                    onChanged: ((value) {
                      setState(() {
                        _email = value.trim();
                      });
                    }),
                  ),
                ).px8(),
                const SizedBox(
                  height: 20,
                ),
                ///////////////////////////////////////////////////////////////
                Text(
                  "Password",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: (15),
                    color: Colors.deepPurple,
                  ),
                ).px16().py2(),

                SizedBox(
                  height: (50),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[100],
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black87,
                        ),
                      ),
                      hintText: '***********',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular((6.94)),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password = value.trim();
                      });
                    },
                    obscureText: _obscureText,
                  ),
                ).px8(),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {}, child: "Forgot Password".text.make())
                  ],
                ).px2(),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      formValidation();
                    },
                    icon: const Icon(
                      Icons.login_sharp,
                      color: Colors.white,
                    ),
                    label: "Login".text.make(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
