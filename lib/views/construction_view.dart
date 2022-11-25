import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class Construction extends StatefulWidget {
  const Construction({super.key});

  @override
  State<Construction> createState() => _ConstructionState();
}

class _ConstructionState extends State<Construction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child:
                Lottie.asset("assets/animations/construction_animation.json"),
          ).p12(),
          const HeightBox(10),
          "The page is under construction"
              .text
              .textStyle(GoogleFonts.pacifico(fontSize: 25))
              .make()
              .p12(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const CircleAvatar(
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ).px8()
        ],
      ),
    );
  }
}
