import 'dart:ui';

import 'package:agriculture_app/views/global/global.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../views/auth_screen.dart';
import '../views/construction_view.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: "Your Profile"
            .text
            .textStyle(GoogleFonts.poppins(color: Colors.blue))
            .bold
            .make(),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
      ),
      body: ListView(children: [
        Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
            Colors.blue[400]!,
            Colors.blue[200]!,
            Colors.blue[200]!,
            Colors.blue[200]!,
            Colors.grey[200]!,
            Colors.grey[200]!,
          ])),
          padding: const EdgeInsets.only(top: 25, bottom: 10),
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(80)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: SizedBox(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                sharedPreferences!.getString("name")!,
                style: TextStyle(
                    color: Colors.blue[900]!,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 3,
        ),
        ListTile(
          leading: const Icon(Icons.home_filled),
          title: const Text("Home"),
          onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
        ListTile(
          leading: const Icon(Icons.monetization_on_rounded),
          title: const Text("My Earnings"),
          onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
        ListTile(
          leading: const Icon(Icons.reorder_rounded),
          title: const Text("New Orders"),
          onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
        ListTile(
          leading: const Icon(Icons.local_shipping_rounded),
          title: const Text("History"),
          onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app_outlined),
          title: const Text("Logout"),
          onTap: () {
            firebaseAuth.signOut().then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (AuthScreen) => false);
            });
          },
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
      ]),
    );
  }
}
