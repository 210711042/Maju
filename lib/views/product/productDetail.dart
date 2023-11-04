import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maju/core/utils/currency.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/product/generate_qr.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {super.key,
      required this.id,
      required this.productName,
      required this.price,
      required this.stock,
      required this.images,
      required this.thumbnail,
      required this.description});

  final int? id;
  final String? productName, thumbnail, description;
  final List<dynamic> images;
  final int? stock;
  final double? price;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  TextEditingController controllerProductName = TextEditingController();
  TextEditingController controllerStock = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerThumbnail = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerProductName.text = widget.productName!;
      controllerStock.text = widget.stock!.toString();
      controllerPrice.text = widget.price!.toStringAsFixed(2);
      controllerThumbnail.text = widget.thumbnail!;
      controllerDescription.text = widget.description!;
    }
    return Scaffold(
        appBar: const MajuProductAppBar(title: "Cari produk..."),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: double.infinity,
              //   height: 339,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: [
              //         Colors.black.withOpacity(0.3),
              //         Colors.black.withOpacity(0),
              //         Colors.black.withOpacity(0),
              //         Colors.white.withOpacity(0),
              //       ],
              //     ),
              //   ),
              //   child: Stack(
              //     children: [
              //       Image.network(
              //         widget.image.toString(),
              //         width: double.infinity,
              //         fit: BoxFit.cover,
              //         filterQuality: FilterQuality.high,
              //       ),
              //       MajuProductAppBar(
              //         title: "Halo",
              //         // backSupport: false,
              //       ),
              //     ],
              //   ),
              // ),
              // Positioned(
              //   top: 0,
              //   child: Image.network(
              //     widget.thumbnail.toString(),
              //     width: double.infinity,
              //     fit: BoxFit.cover,
              //     filterQuality: FilterQuality.high,
              //   ),
              // ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  // aspectRatio: 16 / 9,
                  // autoPlay: true,
                  // autoPlayInterval: Duration(seconds: 5),
                  // autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  viewportFraction: 1,
                ),
                items: widget.images.map((imageURL) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        // decoration: BoxDecoration(border: Border.all(width: 1)),
                        width: double.infinity,
                        height: 600,
                        child: Image.network(
                          imageURL.toString(),
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controllerProductName.text,
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Palette.n900),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(widget.price, 0),
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/location.svg",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Text(
                          "Jakarta",
                          style: TextStyle(
                              fontSize: 14.0,
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
                        SvgPicture.asset(
                          "assets/icons/star.svg",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Text(
                          "4.9 | 250 terjual",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Palette.n600,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Text(
                      "Deskripsi produk",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Palette.n900),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      controllerDescription.text,
                      style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Palette.n900),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Penilaian produk",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Palette.n900),
                        ),
                        Text(
                          "Lihat Semua",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Palette.n900),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const CustomerReview(
                      user: "Budi",
                      rating: 4.00,
                      comment:
                          "Respon cepat, barang sesuai, cepat sampai, memuaskan lah pokoknya",
                    ),
                    const CustomerReview(
                      user: "Lala",
                      rating: 5.00,
                      comment:
                          "Pecah, tapi gapapa lah, sesuai sama harga hehe. Lain kali beli di toko lain saja",
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Produk Lain",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Palette.n900),
                        ),
                        Text(
                          "Lihat Semua",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Palette.n900),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 10,
                offset: Offset(0, -4),
                spreadRadius: 0,
              ),
            ],
            color: Colors.white, // Set the background color
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0, top: 8.0, right: 16.0, left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MajuBasicButton(
                      textButton: "Beli Sekarang",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenerateQRPage(
                              productName: controllerProductName.text,
                              price: double.parse(controllerPrice.text),
                            ),
                          ),
                        );
                      },
                      // btnWidth: 183,
                      btnHeight: 40,
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                color: Palette.n900,
                                width: 1.0,
                              ),
                            ),
                          ),
                          elevation: const MaterialStatePropertyAll(0.0),
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Colors.white),
                          foregroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Palette.n900))),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: MajuBasicButton(
                    textButton: "Keranjang",
                    onPressed: () {},
                    // btnWidth: 183,
                    btnHeight: 40,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class CustomerReview extends StatelessWidget {
  const CustomerReview(
      {super.key, required this.user, required this.rating, this.comment});
  final String user;
  final String? comment;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user,
            style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Palette.n900),
          ),
          const SizedBox(
            height: 4.0,
          ),
          const Row(
            children: [
              Icon(Icons.star_rounded, size: 16.0, color: Color(0xFFFF841F)),
              SizedBox(
                width: 4.0,
              ),
              Text(
                "5 Hari lalu",
                style: TextStyle(fontSize: 12.0, color: Palette.n600),
              )
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(comment!,
              style: const TextStyle(
                  fontSize: 14.0,
                  color: Palette.n900,
                  fontWeight: FontWeight.normal)),
          const SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
