import 'package:flutter/material.dart';
import 'package:maju/core/widgets/maju_basic_product.dart';
import 'package:maju/core/widgets/maju_basic_shop.dart';
import 'package:maju/themes/palette.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Updated soon")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    // aspectRatio: 16 / 9,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    viewportFraction: 1,
                  ),
                  items: [1, 2].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          // decoration: BoxDecoration(border: Border.all(width: 1)),
                          width: double.infinity,
                          height: 200,
                          child: Image.asset(
                            "assets/images/home_banner_$i.png",
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 48.0,
                ),
                Text(
                  "Diskon Spesial",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 18.0,
                      color: Palette.n900,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Berakhir pukul 17:00 WIB",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 14.0,
                          color: Palette.n900,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "Lihat Semua",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 14.0,
                          color: Palette.n900,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      MajuBasicProduct(
                        image: "product_1.png",
                        title: "Busa ganjal penutup celah pintu anti kecoa",
                        price: "29.000",
                        location: "Tangerang",
                        rating: "4.9",
                        sold: "100+",
                      ),
                      MajuBasicProduct(
                        image: "product_2.png",
                        title: "Pisau potong buah dan daging 4 pcs",
                        price: "45.500",
                        location: "Kab. Kudus",
                        rating: "4.9",
                        sold: "1.2k",
                        isCashback: true,
                      ),
                      MajuBasicProduct(
                        image: "product_3.png",
                        title: "3 In 1 Kitchen Set lengkap untuk dapur",
                        price: "179.900",
                        location: "Semarang",
                        rating: "4.7",
                        sold: "200+",
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Toko Pilihan Untukmu",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 18.0,
                      color: Palette.n900,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MajuBasicShopCard(),
                        MajuBasicShopCard(),
                        MajuBasicShopCard(),
                        MajuBasicShopCard(),
                        MajuBasicShopCard(),
                        MajuBasicShopCard(),
                      ],
                    )),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Diisi apa ya",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 18.0,
                      color: Palette.n900,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )),
    );
  }
}
