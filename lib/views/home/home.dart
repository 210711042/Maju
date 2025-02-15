// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maju/core/utils/currency.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/maju_basic_product.dart';
import 'package:maju/core/widgets/maju_basic_shop.dart';
import 'package:maju/core/widgets/maju_product.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:maju/themes/palette.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:http/http.dart' as http;
// import 'package:maju/views/login/login.dart';
import 'package:maju/views/product/productDetail.dart';
import 'package:maju/views/product/products.dart';
// import 'package:maju/views/profile/profile.dart';
// import 'package:flutter/src/rendering/box.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:maju/views/profile/user_profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> dummyProducts = [];
  void refresh() async {
    final data = await SQLHelper.getProducts();
    setState(() {
      products = data;
    });
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/products.json');
    final data = await json.decode(response);
    final fakeProducts = List<Map<String, dynamic>>.from(data['products']);

    setState(() {
      dummyProducts = fakeProducts;
    });
  }

  @override
  void initState() {
    refresh();
    readJson();
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => const ProductsView())));
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, ScreenType) {
        return Scaffold(
          appBar: const MajuBasicAppBar(
            title: "Cari produk...",
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16.0.px,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.px,
                        // aspectRatio: 16 / 9,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
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
                      height: 48.0.px,
                    ),
                    Text(
                      "Diskon Spesial",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 18.0,
                          color: Palette.n900,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4.px,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "Berakhir pukul 17:00 WIB",
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .labelLarge!
                    //           .copyWith(
                    //               fontSize: 14.0,
                    //               color: Palette.n900,
                    //               fontWeight: FontWeight.w400),
                    //     ),
                    //     Text(
                    //       "Lihat Semua",
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .labelLarge!
                    //           .copyWith(
                    //               fontSize: 14.0,
                    //               color: Palette.n900,
                    //               fontWeight: FontWeight.w600),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 16.px,
                    // ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       MajuBasicProduct(
                    //         image: "product_1.png",
                    //         title: "Busa ganjal penutup celah pintu anti kecoa",
                    //         price: "29.000",
                    //         location: "Tangerang",
                    //         rating: "4.9",
                    //         sold: "100+",
                    //       ),
                    //       MajuBasicProduct(
                    //         image: "product_2.png",
                    //         title: "Pisau potong buah dan daging 4 pcs",
                    //         price: "45.500",
                    //         location: "Kab. Kudus",
                    //         rating: "4.9",
                    //         sold: "1.2k",
                    //         isCashback: true,
                    //       ),
                    //       MajuBasicProduct(
                    //         image: "product_3.png",
                    //         title:
                    //             "3 In 1 Kitchen Set lengkap untuk dapur anda yang bagus",
                    //         price: "179.900",
                    //         location: "Semarang",
                    //         rating: "4.7",
                    //         sold: "200+",
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 24.px,
                    // ),
                    // Text(
                    //   "Toko Pilihan Untukmu",
                    //   style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    //       fontSize: 18.0,
                    //       color: Palette.n900,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(
                    //   height: 16.px,
                    // ),
                    // const SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         MajuBasicShopCard(),
                    //         MajuBasicShopCard(),
                    //         MajuBasicShopCard(),
                    //         MajuBasicShopCard(),
                    //         MajuBasicShopCard(),
                    //         MajuBasicShopCard(),
                    //       ],
                    //     )),
                    // SizedBox(
                    //   height: 24.px,
                    // ),
                    // Text(
                    //   "Sample Product",
                    //   style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    //       fontSize: 18.0,
                    //       color: Palette.n900,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(
                    //   height: 16.0.px,
                    // ),
                    // GridView.builder(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount:
                    //         Device.orientation == Orientation.portrait
                    //             ? 2
                    //             : 4, // number of items in each row
                    //     mainAxisSpacing: 16.0, // spacing between rows
                    //     crossAxisSpacing: 16.0, // spacing between columns
                    //     mainAxisExtent: 290,
                    //   ),
                    //   padding:
                    //       const EdgeInsets.all(0.0), // padding around the grid
                    //   itemCount: dummyProducts.length, // total number of items
                    //   itemBuilder: (_, index) {
                    //     return GestureDetector(
                    //       onTap: () async {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => ProductDetail(
                    //                     id: index,
                    //                     productName: dummyProducts[index]
                    //                         ['title'],
                    //                     price: dummyProducts[index]['price']
                    //                         .toDouble(),
                    //                     stock: dummyProducts[index]['stock'],
                    //                     images: dummyProducts[index]['images'],
                    //                     thumbnail: dummyProducts[index]
                    //                         ['thumbnail'],
                    //                     description: dummyProducts[index]
                    //                         ['description'])));
                    //       },
                    //       child: MajuProduct(
                    //           image: dummyProducts[index]['thumbnail'],
                    //           title: dummyProducts[index]['title'],
                    //           price: dummyProducts[index]['price'].toDouble(),
                    //           location: "jakarta",
                    //           rating:
                    //               dummyProducts[index]['rating'].toDouble() ??
                    //                   0,
                    //           sold: "200+"),
                    //     );
                    //   },
                    // ),

                    // GridView.builder(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 8,
                    //     mainAxisSpacing: 8,
                    //     mainAxisExtent: 252,
                    //   ),
                    //   itemCount: products.length,
                    //   itemBuilder: (_, index) {
                    //     return GestureDetector(
                    //         onTap: () async {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => ProductDetail(
                    //                       id: products[index]['id'],
                    //                       productName: products[index]
                    //                           ['product_name'],
                    //                       price: products[index]['price'],
                    //                       stock: products[index]['stock'],
                    //                       image: products[index]['image'])));
                    //         },
                    //         child: Container(
                    //           color: Palette.b100,
                    //           child: const MajuProduct(
                    //               image: "product_3.png",
                    //               title:
                    //                   "Testing judul produk kira kira ini cocok apa ngga",
                    //               price: 172810,
                    //               location: "Jakarta Selatan",
                    //               rating: 4.8,
                    //               sold: "200+"),
                    // child: MajuGridProduct(
                    //   image: "product_3.png",
                    //   title: products[index]['product_name'],
                    //   price: 179900,
                    //   location: "Semarang",
                    //   rating: "4.7",
                    //   sold: "200+",
                    // ),
                    // ));
                    // },
                    // ),
                    SizedBox(
                      height: 24.px,
                    ),
                    Text(
                      "Produk Lainnya",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 18.0,
                          color: Palette.n900,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 16.0.px,
                    ),
                    // const ProductGrid()
                  ],
                ),
              )),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Palette.n900,
            unselectedItemColor: Palette.n600,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    // Calculate the available width for each product item
    // final availableWidth = (MediaQuery.of(context).size.width - 59) / 2;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 270,
      ),
      itemCount: 10,
      itemBuilder: (_, index) {
        return Container(
          color: Palette.b100,
          child: MajuGridProduct(
            image: "product_3.png",
            title: "3 In 1 Kitchen Set lengkap untuk dapur",
            price: 179900,
            location: "Semarang",
            rating: "4.7",
            sold: "200+",
          ),
        );
      },
    );
  }
}

class MajuGridProduct extends StatefulWidget {
  final String image;
  final String title;
  final double price;
  final String location;
  final String rating;
  final String sold;
  final bool isCashback;

  MajuGridProduct({
    required this.image,
    required this.title,
    required this.price,
    required this.location,
    required this.rating,
    required this.sold,
    this.isCashback = false,
  });

  @override
  _MajuGridProductState createState() => _MajuGridProductState();
}

class _MajuGridProductState extends State<MajuGridProduct> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        // width: 200,
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
                  left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
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
                    height: 4.px,
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(widget.price, 0),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 14.0,
                          color: Palette.n900,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(
                    height: 8.px,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/location_on.svg"),
                      SizedBox(
                        width: 4.px,
                      ),
                      Text(
                        widget.location,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 12.0,
                              color: Palette.n600,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.px,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/star.svg"),
                      SizedBox(
                        width: 4.px,
                      ),
                      Text(
                        "${widget.rating} | ${widget.sold} terjual",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
