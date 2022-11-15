import 'dart:io';

import 'package:agriculture_app/views/home_screen.dart';
import 'package:agriculture_app/widgets/error_dialog.dart';
import 'package:agriculture_app/widgets/loading_dialod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import 'global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String _username;
  late String _email;
  late String _password;
  late String _confirmPassword;
  late String _phoneNumber;
  late String _location;
  late String _manualLocation;
  bool _obscureText = true;

  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();

  var completeAddress = "";

  Future<void> _getImage() async {
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXfile;
    });
  }

  Position? position;
  List<Placemark>? placemarks;

  String sellerImageUrl = "";
  getCurrentLocation() async {
    // Ask permission from device
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position farm_position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = farm_position;

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placemarks![0];
    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    setState(() => _location = completeAddress);
  }

  Future<void> formValidation() async {
    if (imageXfile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please upload image",
            );
          });
    } else {
      if (_password == _confirmPassword) {
        if (_password.isEmpty || _confirmPassword.isEmpty) {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(message: "Password cannot be empty!");
              });
        } else if (_username.isEmpty) {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(message: "Name cannot be empty !");
              });
        } else if (_email.isEmpty) {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(message: "Email cannot be empty !");
              });
        } else if (_phoneNumber.isEmpty) {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(
                    message: "Phone number cannot be empty !");
              });
        } else if (_location.isEmpty) {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(
                    message: "Please click on set location to proceed !");
              });
        } else if (_manualLocation.isEmpty) {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(message: "Please fill your address!");
              });
        }

        showDialog(
            context: context,
            builder: (context) {
              return const LoadingDialod(
                message: "Please wait while we register you .....",
              );
            });
        // We will be uploading the image to firestore

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        fStorage.Reference reference = fStorage.FirebaseStorage.instance
            .ref()
            .child("Seller")
            .child(fileName);

        fStorage.UploadTask uploadTask =
            reference.putFile(File(imageXfile!.path));

        fStorage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});

        await taskSnapshot.ref.getDownloadURL().then((url) {
          sellerImageUrl = url;
        });

        /// Athentication of the seller
        ///
        authenticateSellerandSignUp();
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(message: "Password did not matched !");
            });
      }
    }
  }

  void authenticateSellerandSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(message: error.message.toString());
          });
    });

    if (currentUser != null) {
      saveDatatoFirebase(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    }
  }

  Future<void> saveDatatoFirebase(User currentUser) async {
    FirebaseFirestore.instance.collection("seller").doc(currentUser.uid).set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerPhone": _phoneNumber.trim(),
      "sellerName": _username,
      "sellerManualLocation": _manualLocation,
      "sellerAvaratUrl": sellerImageUrl,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", _username);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _getImage();
              },
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///////////////////////////////////////////////////////////////
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
                  height: 10,
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
                ).px8(),
                const SizedBox(
                  height: 10,
                ),

                /////////////////////////////////////////////////////////////////////
                Text(
                  "Phone Number",
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
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[100],
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(
                        Icons.phone_rounded,
                        color: Colors.black,
                      ),
                      hintText: 'XXXXXXXXXXXXX',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular((6.94)),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _phoneNumber = value.trim();
                    },
                  ),
                ).px8(),

                const SizedBox(
                  height: 10,
                ),

                /////////////////////////////////////////////////////////////////////////////////////

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
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
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
                  height: (10),
                ),
                ///////////////////////////////////////////////////////////
                Text(
                  "Confirm Password",
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
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
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
                        _confirmPassword = value.trim();
                      });
                    },
                    obscureText: _obscureText,
                  ),
                ).px8(),

                const SizedBox(
                  height: 10,
                ),
                ///////////////////////////////////////////////
                Text(
                  "Your Location",
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
                    enableSuggestions: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[100],
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(
                        Icons.my_location,
                        color: Colors.black,
                      ),
                      enabled: true,
                      hintText: 'Enter your location !',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular((6.94)),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _manualLocation = value;
                      });
                    },
                  ),
                ).px8(),
                ////////////////////////////////////////////////////////////
                const SizedBox(
                  height: (27.8),
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: "Setup Your Location".text.make(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
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
                    onPressed: () {
                      formValidation();
                    },
                    icon: const Icon(
                      Icons.login_sharp,
                      color: Colors.white,
                    ),
                    label: "Complete Profile".text.make(),
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
            )
          ],
        ),
      ),
    );
  }
}
