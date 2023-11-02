import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maju/core/utils/currency.dart';
import 'package:maju/themes/palette.dart';

class MajuProduct extends StatefulWidget {
  final String image;
  final String title;
  final double price;
  final String location;
  final double rating;
  final String sold;

  const MajuProduct({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.location,
    required this.sold,
    this.rating = 0,
  });

  @override
  State<MajuProduct> createState() => _MajuProductState();
}

class _MajuProductState extends State<MajuProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 0.5, color: Palette.n200),
          color: Palette.n0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.fitHeight)),
              ),
              Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text(
                      "Ad",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Palette.n0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0, // shadow blur
                            color: Palette.n900, // shadow color
                            offset: Offset(
                                1.0, 1.0), // how much shadow will be shown
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 12.0, color: Palette.n900),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  CurrencyFormat.convertToIdr(widget.price, 0),
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Palette.n900),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/location.svg"),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      widget.location,
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Palette.n600,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/star.svg"),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      widget.rating == 0.0
                          ? "-"
                          : "${widget.rating.toString()} | ${widget.sold} terjual",
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Palette.n600,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
