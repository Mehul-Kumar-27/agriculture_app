import 'package:agriculture_app/models/category.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/item_view.dart';
import 'package:agriculture_app/views/items_upload_screen.dart';
import 'package:agriculture_app/views/category_upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MenueDesign extends StatefulWidget {
  MenueDesign({super.key, required this.model, required this.context});

  Category model;

  BuildContext context;

  @override
  State<MenueDesign> createState() => _MenueDesignState();
}

class _MenueDesignState extends State<MenueDesign> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[350],
      borderRadius: BorderRadius.circular(20),
      
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemView(model: widget.model)));
        },
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.model.thumbnailUrl,
                  fit: BoxFit.fitWidth,
                  height: 180,
                ),
              ),
            ).p(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.model.categoryTitle.text
                    .textStyle(GoogleFonts.raleway(fontSize: 20))
                    .color(Colors.black)
                    .bold
                    .make()
                    .py2(),
                widget.model.categoryDescription.text
                    .textStyle(GoogleFonts.poppins(fontSize: 15))
                    .bold
                    .color(Colors.black87)
                    .make(),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ).p12();
  }
}
