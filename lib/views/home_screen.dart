

import 'package:agriculture_app/database/database_methods.dart';
import 'package:agriculture_app/models/category.dart';
import 'package:agriculture_app/views/auth_screen.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/category_upload_view.dart';
import 'package:agriculture_app/widgets/drawer.dart';
import 'package:agriculture_app/widgets/menu_display_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? sellerCategories;

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    getSellerCategories();
    super.initState();
  }

  getSellerCategories() async {
    databaseMethods
        .getCategories(sharedPreferences!.getString("uid")!)
        .then((value) {
      setState(() {
        sellerCategories = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: const MyDrawer(),
      // appBar: AppBar(
      //   backgroundColor: Colors.deepPurple,
      //   title: Text("Welcome  ${sharedPreferences!.getString("name")!}"),
      // ),
      // bottomNavigationBar:
      //     BottomNavigationBar(backgroundColor: Colors.white70, items: [
      //   const BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.home,
      //         size: 32,
      //         color: Colors.deepPurpleAccent,
      //       ),
      //       label: ""),
      //   BottomNavigationBarItem(
      //     icon: InkWell(
      //       onTap: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const CategoryUploadScreen()));
      //       },
      //       child: Container(
      //         height: 52,
      //         width: 52,
      //         decoration: const BoxDecoration(
      //             shape: BoxShape.circle,
      //             gradient: LinearGradient(
      //                 colors: [Colors.indigoAccent, Colors.purple])),
      //         child: const Icon(
      //           Icons.add,
      //           size: 32,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //     label: "",
      //   ),
      //   const BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.settings,
      //         size: 32,
      //         color: Colors.deepPurpleAccent,
      //       ),
      //       label: ""),
      // ]),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: StreamBuilder(
      //         stream: sellerCategories,
      //         builder: (context, AsyncSnapshot snapshot) {
      //           return !snapshot.hasData
      //               ? const Center(
      //                   child: CircularProgressIndicator(),
      //                 )
      //               : ListView.builder(
      //                   shrinkWrap: true,
      //                   itemCount: snapshot.data.docs.length,
      //                   itemBuilder: (context, index) {
      //                     Category model = Category.fromJson(
      //                         snapshot.data!.docs[index].data()!
      //                             as Map<String, dynamic>);
      //                     return MenueDesign(model: model, context: context);
      //                   });
      //         },
      //       ),
      //     ),
      //   ],
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              elevation: 12,
              color: Colors.grey[200],
              child: Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff955cd1),
                        Color(0xff3fa2fa),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.2, 0.85],
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeightBox(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Namaste"
                            .text
                            .textStyle(GoogleFonts.poppins(
                                fontSize: 25, color: Colors.white))
                            .bold
                            .make()
                            .px16(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfile()));
                          },
                          child: const CircleAvatar(
                            child: Icon(
                              Icons.person,
                            ),
                          ),
                        ).px8()
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.sunny,
                          color: Colors.amber[600],
                          size: 50,
                        )),
                    const HeightBox(10),
                    "    Sunny"
                        .text
                        .textStyle(GoogleFonts.pacifico(color: Colors.white))
                        .bold
                        .make(),
                    const HeightBox(10),
                    "Gandhinagar"
                        .text
                        .textStyle(GoogleFonts.poppins(color: Colors.grey[200]))
                        .bold
                        .make(),
                    const HeightBox(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          "27* C"
                              .text
                              .textStyle(GoogleFonts.poppins(
                                  color: Colors.grey[300], fontSize: 20))
                              .bold
                              .make(),
                          const HeightBox(2),
                          "Temperature"
                              .text
                              .textStyle(GoogleFonts.poppins(
                                  color: Colors.grey[400], fontSize: 15))
                              .make(),
                        ]),
                        const WidthBox(10),
                        Column(children: [
                          "30%"
                              .text
                              .textStyle(GoogleFonts.poppins(
                                  color: Colors.grey[300], fontSize: 20))
                              .bold
                              .make(),
                          const HeightBox(2),
                          "Humudity"
                              .text
                              .textStyle(GoogleFonts.poppins(
                                  color: Colors.grey[400], fontSize: 15))
                              .make(),
                        ]),
                        const WidthBox(10),
                        Column(children: [
                          "10 km/ph"
                              .text
                              .textStyle(GoogleFonts.poppins(
                                  color: Colors.grey[300], fontSize: 20))
                              .bold
                              .make(),
                          const HeightBox(2),
                          "Wind Speed"
                              .text
                              .textStyle(GoogleFonts.poppins(
                                  color: Colors.grey[400], fontSize: 15))
                              .make(),
                        ]),
                      ],
                    )
                  ],
                ).p12(),
              ),
            ).px4(),
            const HeightBox(20),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        width: 70,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_shipping,
                              size: 30,
                              color: Colors.black54,
                            ),
                            const HeightBox(10),
                            "History".text.bold.make()
                          ],
                        ),
                      ).p8(),
                    ),
                    InkWell(
                      child: Container(
                        width: 70,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              size: 30,
                              color: Colors.black54,
                            ),
                            const HeightBox(10),
                            "Earnings".text.bold.make()
                          ],
                        ),
                      ).p8(),
                    ),
                    InkWell(
                      child: Container(
                        width: 70,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.reorder_outlined,
                              size: 30,
                              color: Colors.black54,
                            ),
                            const HeightBox(10),
                            "Orders".text.bold.make()
                          ],
                        ),
                      ).p8(),
                    ),
                    InkWell(
                      child: Container(
                        width: 70,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.category,
                              size: 30,
                              color: Colors.black54,
                            ),
                            const HeightBox(10),
                            "Categories".text.bold.make()
                          ],
                        ),
                      ).p8(),
                    ),
                    InkWell(
                      child: Container(
                        width: 70,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.payment_outlined,
                              size: 30,
                              color: Colors.black54,
                            ),
                            const HeightBox(10),
                            "Payments".text.bold.make()
                          ],
                        ),
                      ).p8(),
                    ),
                    InkWell(
                      child: Container(
                        width: 70,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.percent,
                              size: 30,
                              color: Colors.black54,
                            ),
                            const HeightBox(10),
                            "Offers".text.bold.make()
                          ],
                        ),
                      ).p8(),
                    ),
                  ],
                ),
              ),
            ).px4(),
            const HeightBox(20),
            Row(
              children: [
                "Trending Products"
                    .text
                    .textStyle(GoogleFonts.poppins(
                        fontSize: 20, color: Colors.grey[600]))
                    .bold
                    .make(),
                const WidthBox(10),
                const Icon(Icons.trending_up_outlined)
              ],
            ).px8(),
            const HeightBox(10),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget TrendingView(Item model, BuildContext context) {
  return Container(
    child: Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              model.thumbnailUrl,
              fit: BoxFit.fitWidth,
              height: 180,
            ),
          ),
        ).p(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            model.productTitle.text
                .textStyle(GoogleFonts.raleway(fontSize: 20))
                .color(Colors.black)
                .bold
                .make()
                .py2(),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
}
