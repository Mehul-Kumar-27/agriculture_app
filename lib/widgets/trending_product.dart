
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:velocity_x/velocity_x.dart';

import '../models/item_model.dart';
import '../views/item_details_view.dart';

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

