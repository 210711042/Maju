import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maju/core/widgets/maju_basic_product.dart';
import 'package:maju/core/widgets/maju_basic_shop.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:maju/themes/palette.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:maju/views/login/login.dart';
import 'package:maju/views/profile/profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> products = [];

  void refresh() async {
    final data = await SQLHelper.getProducts();
    setState(() {
      products = data;
    });
    print(products);
  }

  @override
  void initState() {
    refresh();
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
          MaterialPageRoute(builder: (context) => HomeView()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfileView()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Updated soon")),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16.0,
                ),
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
                  "Sample Product",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 18.0,
                      color: Palette.n900,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Produk Lainnya",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 18.0,
                      color: Palette.n900,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ProductGrid()
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
            icon: Icon(Icons.business),
            label: 'Business',
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
    final availableWidth = (MediaQuery.of(context).size.width - 59) / 2;

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 252,
      ),
      itemCount: 10,
      itemBuilder: (_, index) {
        return Container(
          color: Palette.b100,
          child: MajuGridProduct(
            image: "product_3.png",
            title: "3 In 1 Kitchen Set lengkap untuk dapur",
            price: "179.900",
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
  final String price;
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
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
