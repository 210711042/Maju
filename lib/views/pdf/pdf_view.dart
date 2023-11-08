import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maju/core/utils/currency.dart';
import 'package:maju/data/entity/products.dart';
import 'package:maju/views/pdf/custom_row_invoice.dart';
import 'package:maju/views/pdf/item_doc.dart';
import 'package:maju/views/pdf/preview_screen.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:barcode_widget/barcode_widget.dart';

Future<void> createPdf(
    String productNameController,
    String priceController,
    // TextEditingController addressController,
    String id,
    Uint8List image,
    BuildContext context,
    List<Products> soldProducts) async {
  final doc = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  debugPrint("PDF View come in");

  // final imageLogo =
  //     (await rootBundle.load("assets/logo.png")).buffer.asUint8List();
  // final imageInvoice = pw.MemoryImage(imageLogo);

  pw.ImageProvider pdfImageProvider(Uint8List imageBytes) {
    return pw.MemoryImage(imageBytes);
  }

  final imageBytes = image;

  // Page Theme config
  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Container(
          decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromHex("#FFBD59"), width: 1.w),
      ));
    },
  );

  final List<CustomRow> elements = [
    CustomRow("Item Name", "Item Price", "Amount", "Sub Total Product"),
    // for (var product in soldProducts)
    CustomRow(
        productNameController,
        CurrencyFormat.convertToIdr(double.parse(priceController), 2),
        1.toString(),
        CurrencyFormat.convertToIdr(double.parse(priceController), 2)),
    // CustomRow("PPN Total (11%)", "", "", "Rp ${getPPNTotal(soldProducts)}"),
    // CustomRow("Total", "", "",
    //     "Rp ${(double.parse(getSubTotal(soldProducts)) + double.parse(getPPNTotal(soldProducts))).toStringAsFixed(2)}")
  ];

  pw.Widget table = itemColumn(elements);

  debugPrint("PDF View come in 2");

  doc.addPage(pw.MultiPage(
      pageTheme: pdfTheme,
      header: (pw.Context context) {
        return headerPDF(id);
      },
      build: (pw.Context context) {
        return [
          pw.Center(
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                pw.Container(
                    margin: pw.EdgeInsets.symmetric(
                        horizontal: 2.h, vertical: 2.h)),
                // pw.Text("HALO")
                imageFromInput(pdfImageProvider, imageBytes),
                // personalDataFromInput(productNameController, priceController),
                // pw.SizedBox(height: 10.h),
                // topOfInvoice(imageInvoice),
                barcodeGaris(id),
                // pw.SizedBox(height: 5.h),
                contentOfInvoice(table),
                // // barcodeKotak(id),
                // pw.SizedBox(height: 1.h)
              ]))
        ];
      },
      footer: (pw.Context context) {
        return pw.Container(
            color: PdfColor.fromHex('#FFBD59'),
            child: footerPDF(formattedDate));
      }));
  debugPrint("PDF View come in 3");
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => PreviewScreen(doc: doc)));
}

pw.Header headerPDF(String id) {
  return pw.Header(
      margin: pw.EdgeInsets.zero,
      outlineColor: PdfColors.amber50,
      outlineStyle: PdfOutlineStyle.normal,
      level: 5,
      decoration: pw.BoxDecoration(
          shape: pw.BoxShape.rectangle,
          gradient: pw.LinearGradient(colors: [
            PdfColor.fromHex("#FCDF8A"),
            PdfColor.fromHex("#F38381")
          ], begin: pw.Alignment.topLeft, end: pw.Alignment.bottomRight)),
      child: pw.Center(
          child: pw.Text("Maju Invoice #$id",
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 12.sp))));
}

pw.Padding imageFromInput(
    pw.ImageProvider Function(Uint8List imageBytes) pdfImageProvider,
    Uint8List imageBytes) {
  return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
      child: pw.FittedBox(
          child: pw.Image(pdfImageProvider(imageBytes), width: 11.h),
          fit: pw.BoxFit.fitHeight,
          alignment: pw.Alignment.center));
}

// pw.Padding personalDataFromInput(
//     String productNameController, String priceController) {
//   return pw.Padding(
//       padding: pw.EdgeInsets.symmetric(horizontal: 5.h, vertical: 1.h),
//       child: pw.Table(border: pw.TableBorder.all(), children: [
//         pw.TableRow(children: [
//           pw.Padding(
//               padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
//               child: pw.Text("Name",
//                   style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     fontSize: 10.sp,
//                   ))),
//           pw.Padding(
//               padding: pw.EdgeInsets.all(1.h),
//               child: pw.Text(productNameController,
//                   style: pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold, fontSize: 10.sp))),
//         ]),
//         pw.TableRow(children: [
//           pw.Padding(
//               padding: pw.EdgeInsets.all(1.h),
//               child: pw.Text("Phone Number",
//                   style: pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold, fontSize: 10.sp))),
//           pw.Padding(
//               padding: pw.EdgeInsets.all(1.h),
//               child: pw.Text(priceController,
//                   style: pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold, fontSize: 10.sp)))
//         ]),
//       ]));
// }

// pw.Padding topOfInvoice(pw.MemoryImage imageInvoice) {
//   return pw.Padding(
//     padding: const pw.EdgeInsets.all(8.0),
//     child:
//         pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
//       pw.Image(imageInvoice, height: 30.h, width: 30.h),
//       pw.Expanded(
//           child: pw.Container(
//               height: 10.h,
//               decoration: const pw.BoxDecoration(
//                   borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
//                   color: PdfColors.amberAccent),
//               padding: const pw.EdgeInsets.only(
//                   left: 40, top: 10, bottom: 10, right: 40),
//               alignment: pw.Alignment.centerLeft,
//               child: pw.DefaultTextStyle(
//                   style: const pw.TextStyle(
//                       color: PdfColors.amber100, fontSize: 12),
//                   child: pw.GridView(crossAxisCount: 2, children: [
//                     pw.Text("Awesome Product",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                     pw.Text("Anggrek Street 12",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                     pw.SizedBox(height: 1.h),
//                     pw.Text("Jakarta 5111",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                     pw.SizedBox(height: 1.h),
//                     pw.SizedBox(height: 1.h),
//                     pw.Text("Contact Us",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                     pw.SizedBox(height: 1.h),
//                     pw.Text("Phone Number",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                     pw.Text("C0812345678",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                     pw.Text("Email",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                     pw.Text("awesomeproduct@gmail.com",
//                         style: pw.TextStyle(
//                             fontSize: 10.sp, color: PdfColors.blue800)),
//                   ]))))
//     ]),
//   );
// }

pw.Padding contentOfInvoice(pw.Widget table) {
  return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(
            "Dear Customer, thank you for buying our product, we hope the products can make your day."),
        pw.SizedBox(height: 3.h),
        table,
        pw.Text("Thanks for your truest, and till the next time."),
        pw.SizedBox(height: 3.h),
        pw.Text("Kind regards,"),
        pw.SizedBox(height: 3.h),
        pw.Text("Maju Dept. Store")
      ]));
}

// // pw.Padding barcodeKotak(String id) {
// //   return pw.Padding(
// //       padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
// //       child: pw.Center(
// //           child: pw.BarcodeWidget(
// //               barcode: pw.Barcode.qrCode(
// //                 errorCorrectLevel: BarcodeQRCorrectionLevel.high,
// //               ),
// //               data: id,
// //               width: 15.w,
// //               height: 15.h)));
// // }

pw.Container barcodeGaris(String id) {
  return pw.Container(
      child: pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
          child: pw.BarcodeWidget(
              barcode: Barcode.code128(escapes: true),
              data: id,
              width: 10.w,
              height: 5.h)));
}

pw.Center footerPDF(String formattedDate) => pw.Center(
    child: pw.Text("Created At $formattedDate",
        style: pw.TextStyle(fontSize: 10.sp, color: PdfColors.blue)));
