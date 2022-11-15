import 'dart:ui';

import 'package:agriculture_app/views/global/global.dart';

import 'package:flutter/material.dart';

import '../views/auth_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
            Colors.purple[900]!,
            Colors.purple[900]!,
            Colors.purple[800]!
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
                style: const TextStyle(
                    color: Colors.white,
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
          onTap: () {},
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
        ListTile(
          leading: const Icon(Icons.monetization_on_rounded),
          title: const Text("My Earnings"),
          onTap: () {},
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
        ListTile(
          leading: const Icon(Icons.reorder_rounded),
          title: const Text("New Orders"),
          onTap: () {},
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.85,
        ),
        ListTile(
          leading: const Icon(Icons.local_shipping_rounded),
          title: const Text("History"),
          onTap: () {},
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
