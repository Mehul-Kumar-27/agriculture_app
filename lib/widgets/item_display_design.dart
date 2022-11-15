import 'package:agriculture_app/models/category.dart';
import 'package:agriculture_app/models/item_model.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/item_details_view.dart';
import 'package:agriculture_app/views/item_view.dart';
import 'package:agriculture_app/views/items_upload_screen.dart';
import 'package:agriculture_app/views/category_upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemDesign extends StatefulWidget {
  ItemDesign({super.key, required this.model, required this.context});

  Item model;

  BuildContext context;

  @override
  State<ItemDesign> createState() => _ItemDesignState();
}

class _ItemDesignState extends State<ItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailView(model: widget.model)));
      },
      child: Material(
        elevation: 10,
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Hero(
              tag: Key(widget.model.productId.toString()),
              child: SizedBox(
                height: 120,
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.model.thumbnailUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.model.productTitle.text
                    .color(Colors.black)
                    .textStyle(GoogleFonts.poppins(fontSize: 20))
                    .make(),
                widget.model.productDescription.text
                    .color(Colors.black87)
                    .textStyle(GoogleFonts.poppins(fontSize: 15))
                    .make(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    "Price: \$ ${widget.model.priceTitle}"
                        .text
                        .color(Colors.red[300])
                        .textStyle(GoogleFonts.poppins(fontSize: 15))
                        .bold
                        .make(),
                  ],
                )
              ],
            )
          ],
        ),
      ).p12(),
    );
  }
}
