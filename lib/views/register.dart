import 'dart:io';

import 'package:agriculture_app/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.1,
                  backgroundColor: Colors.grey[600],
                  backgroundImage: imageXfile == null
                      ? null
                      : FileImage(File(imageXfile!.path)),
                  child: imageXfile == null
                      ? Icon(
                          Icons.add_a_photo_outlined,
                          size: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.white,
                        )
                      : null),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      iconData: Icons.person,
                      hintText: "What should we call you ?",
                      isObscure: false,
                      enabled: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: emailController,
                      iconData: Icons.email,
                      hintText: "Enter your email Id",
                      isObscure: false,
                      enabled: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: phoneController,
                      iconData: Icons.phone,
                      hintText: "Enter your contact number",
                      isObscure: false,
                      enabled: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: locationController,
                      iconData: Icons.my_location_sharp,
                      hintText: "Select your Location",
                      isObscure: false,
                      enabled: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: passwordController,
                      iconData: Icons.lock_outline_rounded,
                      hintText: "Enter your password",
                      isObscure: true,
                      enabled: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: passwordController,
                      iconData: Icons.lock_outline_rounded,
                      hintText: "Confirm password",
                      isObscure: true,
                      enabled: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
