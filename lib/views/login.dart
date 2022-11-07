import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/login_image.png",
                height: 270,
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
                    fontWeight: FontWeight.w400,
                    fontSize: (15),
                    color: Colors.white,
                  ),
                ).px8(),
                SizedBox(
                  height: (50),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 56, 47, 47),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[500],
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
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
                ),
                const SizedBox(
                  height: 20,
                ),
                //////////////////////////////////////////////////////////////////////////////////
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: (15),
                    color: Colors.white,
                  ),
                ).px8(),
                SizedBox(
                  height: (50),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 56, 47, 47),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[500],
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      hintText: 'someone@gmail.com ?',
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
                ),
                const SizedBox(
                  height: 20,
                ),
                ///////////////////////////////////////////////////////////////
                Text(
                  "Password",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: (15),
                    color: Colors.white,
                  ),
                ).px8(),

                SizedBox(
                  height: (50),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 56, 47, 47),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[500],
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
                          color: Colors.white,
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
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.login_sharp,
                      color: Colors.white,
                    ),
                    label: "Complete Profile".text.make(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
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
