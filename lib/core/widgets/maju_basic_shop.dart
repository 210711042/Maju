import 'package:flutter/material.dart';
import 'package:maju/themes/palette.dart';

class MajuBasicShopCard extends StatelessWidget {
  const MajuBasicShopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 142.0,
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Palette.n200),
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              Stack(
                alignment:
                    Alignment.center, // Center both text and logo vertically
                children: [
                  Image.asset("assets/images/stores/banner_samsung.png"),
                  Image.asset("assets/images/stores/logo_samsung.png"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, left: 4.0, bottom: 8.0, right: 4.0),
                child: Text(
                  "Samsung Official Store",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 14.0,
                        color: Palette.n900,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 8,
        )
      ],
    );
  }
}
