import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/Models/Pay.dart';
import 'package:pos_app/Models/food.dart';
import 'package:pos_app/bloc/food_bloc.dart';
import 'package:pos_app/screens/firestoreservices.dart';
import 'receipt.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart' as ul;
import 'calendar.dart';
import 'document.dart';
import 'invoice.dart';
import 'report.dart';
import 'resume.dart';

class PdfHome extends StatefulWidget {
  double charge;
  String name;
  String mobile;
  String email;
  String invoice;
  PdfHome({Key key, @required this.charge, @required this.name, @required this.mobile, @required this.invoice, @required this.email}) : super(key: key);
  @override
  PdfHomeState createState() {
    return PdfHomeState();
  }
}

class PdfHomeState extends State<PdfHome> with SingleTickerProviderStateMixin {
  List<Tab> _myTabs;
  List<LayoutCallback> _tabGen;
  List<String> _tabUrl;
  int _tab = 0;
  TabController _tabController;

  PrintingInfo printingInfo;
  List<Cart> items;
  List<Pay> foodlist;
  List<Pay> datalist;

  StreamSubscription<QuerySnapshot> todoTasks;
  StreamSubscription<QuerySnapshot> get;

   Stream<QuerySnapshot> getDataList({int offset, int limit}) {

      Stream<QuerySnapshot> snapshots =FirebaseFirestore.instance.collection("paymethod").where("invoice",isEqualTo: widget.invoice).snapshots();
      // yourNeeds.add(snapshots);
      if (offset != null) {
        snapshots = snapshots.skip(offset);
      }
      if (limit != null) {
        snapshots = snapshots.take(limit);
      }
      return snapshots;
    }
    Stream<QuerySnapshot> getPaySummary({int offset, int limit}) {

      Stream<QuerySnapshot> snapshots =FirebaseFirestore.instance.collection("pos_db").where("invoice",isEqualTo: widget.invoice).snapshots();
      // yourNeeds.add(snapshots);
      if (offset != null) {
        snapshots = snapshots.skip(offset);
      }
      if (limit != null) {
        snapshots = snapshots.take(limit);
      }
      return snapshots;
    }

  @override
  void initState() {
    super.initState();
    _init();
    items = new List();
    datalist = new List();

    todoTasks?.cancel();
    todoTasks = getPaySummary().listen((QuerySnapshot snapshot) {
      final List<Cart> tasks = snapshot.docs
          .map((documentSnapshot) => Cart.fromMap(documentSnapshot.data()))
          .toList();
      setState(() {
        items = tasks;
      });
    });
    foodlist = new List();
    print(items.length);
    print(foodlist.length);
get ?.cancel();
get = getDataList().listen((QuerySnapshot snapshot) {
  final List<Pay> data = snapshot.docs
      .map((documentSnapshot) => Pay.fromMap(documentSnapshot.data()))
      .toList();
  setState(() {
    datalist = data;
  });
});
  print(datalist);
  }
  Future<void> _init() async {
    final PrintingInfo info = await Printing.info();

    _myTabs = const <Tab>[
      Tab(text: 'RÉSUMÉ'),
      Tab(text: 'DOCUMENT'),
      Tab(text: 'INVOICE'),
      Tab(text: 'REPORT'),
      Tab(text: 'CALENDAR'),
      Tab(text: 'Recept'),
    ];

    _tabGen = const <LayoutCallback>[
      generateResume,
      generateDocument,
      generateInvoice,
      generateReport,
      generateCalendar,
      generateRecept,
    ];

    _tabUrl = const <String>[
      'resume.dart',
      'document.dart',
      'invoice.dart',
      'report.dart',
      'calendar.dart',
      'receipt.dart',
    ];

    _tabController = TabController(
      vsync: this,
      length: _myTabs.length,
      initialIndex: _tab,
    );
    _tabController.addListener(() {
      setState(() {
        _tab = _tabController.index;
      });
    });

    setState(() {
      printingInfo = info;
    });
  }
  // baseColor: PdfColors.teal,
  // accentColor: PdfColors.blueGrey900,
  DateTime now = new DateTime.now();
  // DateTime date = new DateTime(now.year, now.month, now.day);
  void _showPrintedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);
    // FirebaseFirestore.instance.collection('paymethod').doc().delete().catchError((e) {
    //   print(e);
    // });
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final Uint8List bytes = await build(pageFormat);
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File file = File(appDocPath + '/' + '${widget.name+widget.invoice}.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
      //   bottom: TabBar(
      //     controller: _tabController,
      //     tabs: _myTabs,
      //   ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build:
            (format) => _generatePdf(format),
         // _tabGen[_tab],
        actions: actions,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.deepOrange,
      //   onPressed: _showSources,
      //   child: Icon(Icons.code),
      // ),
    );
  }

  void _showSources() {
    ul.launch(
      'https://github.com/DavBfr/dart_pdf/blob/master/demo/lib/${_tabUrl[_tab]}',
    );
  }



  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;
  // final String paymentInfo;


  PdfImage _logo;
  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: PdfColors.teal,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius: 2,
                      color: PdfColors.blueGrey900,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #'),
                          pw.Text(widget.invoice),
                          pw.Text('Date:'),
                          pw.Text("${DateFormat('yMd').format(now)}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 100,
                    width: 400,
                    // child:pw.Image("assets/logo.png"),
                    child: _logo != null ? pw.Image(_logo) : pw.PdfLogo(),
                  ),
                  pw.Container(
                    color: PdfColors.teal,
                    padding: pw.EdgeInsets.only(top: 3),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# ${widget.invoice}',
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey,
          ),
        ),
      ],
    );
  }
  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.BoxBorder(
                    top: true,
                    color: PdfColors.blueGrey900,
                  ),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.teal,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 10,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    _logo = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
              child: pw.Column(children: [
                _buildHeader(context),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                    height: 70,
                    child: pw.FittedBox(
                      child: pw.Text(
                        'Total: \$${widget.charge.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          // color: Colors.blue,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Container(
                        margin: const pw.EdgeInsets.only(left: 10, right: 10),
                        height: 70,
                        child: pw.Text(
                          'Invoice to:',
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          height: 70,
                          child: pw.RichText(
                              text: pw.TextSpan(
                                  text:'${widget.name}\n',
                                  style: pw.TextStyle(
                                    color: _darkColor,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  children: [
                                 pw.TextSpan(
                                  text: "${widget.email} \n",
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                pw.TextSpan(
                                  text: widget.mobile,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ])),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(height: 10,),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: <pw.Widget>[
                        pw.Text(
                          "Qty".toUpperCase(),
                          // style:bioTextStyle,
                          // textAlign: TextAlign.start,
                        ),
                      ]),
                  pw.Column(children: <pw.Widget>[
                    pw.Text(
                      "Item".toUpperCase(),
                      // style: bioTextStyle,
                    ),
                  ]),
                  pw.Column(children: <pw.Widget>[
                    pw.Text(
                      "Price".toUpperCase(),
                      // style: bioTextStyle
                    ),
                  ]),
                  pw.Column(
                    children: <pw.Widget>[
                      pw.Text(
                        "Total".toUpperCase(),
                        // style: bioTextStyle
                      ),
                    ],
                  )
                ]),
                pw.Divider(height: 10,),
            pw.ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Cart receipt = items[index];
                  return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[

                        pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: <pw.Widget>[
                              pw.Text(
                                receipt.qnty.toString(),
                                style: pw.TextStyle(fontSize: 10),
                                // textAlign: TextAlign.start,
                              ),
                            ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(
                            receipt.title.toUpperCase(),
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(
                            "\$${receipt.price.toString()}",
                            // style: _statLabelTextStyle
                          ),
                        ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(
                           "\$${ receipt.subtotal.toString()}",
                            // style: _statLabelTextStyle
                          ),
                        ]),
                      ]);
                }),
                pw.Divider(height: 10,),
                pw.SizedBox(height: 10),
                pw.Row(children: [pw.Text("Payment Method Used", style: pw.TextStyle(fontSize: 20),)]),
                pw.Divider(height: 10,),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: <pw.Widget>[
                            pw.Text(
                              "Currency Name".toUpperCase(),
                              // style: bioTextStyle,
                              // textAlign: TextAlign.start,
                            ),
                          ]),
                      pw.Column(children: <pw.Widget>[
                        pw.Text(
                          "Amount Paid".toUpperCase(),
                          // style: bioTextStyle,
                        ),
                      ]),
                      pw.Column(children: <pw.Widget>[
                        pw.Text("Rate Used".toUpperCase(),
                            // style: bioTextStyle
                        ),
                      ]),
                    ]),
                pw.Divider(height: 10,),
                pw.ListView.builder(
                  // shrinkWrap: true,
                  // primary: false,
                  itemCount:datalist.length,
                  itemBuilder: (context, i) {
                    Pay pay = datalist[i];
                    return pw.Row(
                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: <pw.Widget>[
                                pw.Text(pay.currency.toString()),
                              ]),
                         pw. Column(children: <pw.Widget>[
                            pw.Text(pay.amount.toString()),
                          ]),
                          pw.Column(children: <pw.Widget>[
                            pw.Text(pay.rate.toString()),
                          ]),
                        ]);
                  },
                ),
                pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Thank you for your business',
                        style: pw.TextStyle(
                          color: _darkColor,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                        child: pw.Text(
                          'Payment Info:',
                          style: pw.TextStyle(
                            color: PdfColors.teal,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      // pw.Text(),
                      pw.Text("Wedding Hub \n 797 Fairview Crescent \n Winston Park \n Marondera  \n info@weddinghub.co.zw \n +263 772 629 299",
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          lineSpacing: 2,
                          color: _darkColor,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.DefaultTextStyle(
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: _darkColor,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Sub Total:'),
                            pw.Text("\$${widget.charge.toStringAsFixed(2)}"),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Tax:'),
                            pw.Text('${(78 * 100).toStringAsFixed(1)}%'),
                          ],
                        ),
                        pw.Divider(),
                        pw.DefaultTextStyle(
                          style: pw.TextStyle(
                            color: PdfColors.teal,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Total:'),
                              pw.Text('\$${widget.charge.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
                // pw.Divider(),
                _termsAndConditions(context),
                pw.SizedBox(height: 50),
                _buildFooter(context),
              ]));
        },
      ),
    );

    return pdf.save();
  }
}
