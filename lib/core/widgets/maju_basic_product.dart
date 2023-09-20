import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maju/themes/palette.dart';

class MajuBasicProduct extends StatefulWidget {
  final String image;
  final String title;
  final String price;
  final String location;
  final String rating;
  final String sold;
  final bool isCashback;
  final double width;

  MajuBasicProduct({
    required this.image,
    required this.title,
    required this.price,
    required this.location,
    required this.rating,
    required this.sold,
    this.isCashback = false,
    this.width = 142.0,
  });

  @override
  _MajuBasicProductState createState() => _MajuBasicProductState();
}

class _MajuBasicProductState extends State<MajuBasicProduct> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 0.5, color: Palette.n200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Image.asset(
                        "assets/images/products/${widget.image}",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    if (widget.isCashback)
                      Positioned(
                        bottom: 4.0,
                        left: 4.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: Palette.g600,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 4.0),
                              child: Text(
                                "Cashback 2%",
                                style: TextStyle(color: Palette.g100),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 4.0, right: 4.0, top: 4.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _truncateTitle(widget.title),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 14.0,
                              color: Palette.n900,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Rp${widget.price}",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 14.0,
                              color: Palette.n900,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/location_on.svg"),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.location,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontSize: 12.0,
                                  color: Palette.n600,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/star.svg"),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${widget.rating} | ${widget.sold} terjual",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontSize: 12.0,
                                  color: Palette.n600,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }

  String _truncateTitle(String title) {
    if (title.length <= 40) {
      return title;
    } else {
      return title.substring(0, 40) + '...';
    }
  }
}
