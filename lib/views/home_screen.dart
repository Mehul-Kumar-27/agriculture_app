import 'package:agriculture_app/database/database_methods.dart';
import 'package:agriculture_app/models/category.dart';
import 'package:agriculture_app/views/auth_screen.dart';
import 'package:agriculture_app/views/category_display.dart';
import 'package:agriculture_app/views/construction_view.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/category_upload_view.dart';
import 'package:agriculture_app/views/item_details_view.dart';
import 'package:agriculture_app/widgets/drawer.dart';
import 'package:agriculture_app/widgets/item_display_design.dart';
import 'package:agriculture_app/widgets/menu_display_design.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    getTrendingProducts();
    super.initState();
  }

  Stream? treandingProductsStream;

  getTrendingProducts() async {
    databaseMethods.getTreandingProducts().then((value) {
      setState(() {
        treandingProductsStream = value;
      });
    });
  }

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                    builder: (context) => const MyProfile()));
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Category_Display()));
                      },
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Construction()));
                      },
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
            const HeightBox(15),
            Column(
              children: [
                SizedBox(
                  height: 270,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                      stream: treandingProductsStream,
                      builder: (context, AsyncSnapshot snapshot) {
                        return !snapshot.hasData
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CarouselSlider.builder(
                                itemCount: 8,
                                itemBuilder: (context, index, realIndex) {
                                  Item model = Item.fromJson(
                                      snapshot.data.docs[index].data()!
                                          as Map<String, dynamic>);

                                  return TrendingProducts(
                                      model: model, context: context);
                                },
                                options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  height: 400,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  },
                                ),
                              );
                      }),
                ),
                const HeightBox(10),
                buildIndicator()
              ],
            ),
            Container(
              height: 400,
              color: Colors.grey[200],
            )
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 8,
        effect: const SwapEffect(
            dotHeight: 10, dotWidth: 10, type: SwapType.yRotation),
      );
}

class TrendingProducts extends StatefulWidget {
  TrendingProducts({super.key, required this.model, required this.context});

  Item model;
  BuildContext context;

  @override
  State<TrendingProducts> createState() => _TrendingProductsState();
}

class _TrendingProductsState extends State<TrendingProducts> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailView(
                      model: widget.model,
                      istrending: true,
                    )));
      },
      child: Material(
        borderRadius: BorderRadius.circular(40),
        color: Colors.grey[200],
        child: SizedBox(
          height: 270,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    widget.model.thumbnailUrl,
                    fit: BoxFit.fitWidth,
                    height: 200,
                    width: 300,
                  ),
                ),
              ),
              const HeightBox(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.model.productTitle.text
                      .textStyle(GoogleFonts.pacifico(fontSize: 25))
                      .make()
                ],
              )
            ],
          ),
        ),
      ).px8(),
    );
  }
}
