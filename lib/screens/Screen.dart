import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/controllers/calendar.dart';
import 'package:pos_app/controllers/document.dart';
import 'package:pos_app/controllers/invoice.dart';
import 'package:pos_app/controllers/receipt.dart';
import 'package:pos_app/controllers/report.dart';
import 'package:pos_app/controllers/resume.dart';
import 'package:pos_app/screens/firestoreservices.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

class Screen extends StatefulWidget {
  double charge;
  Screen({Key key, @required this.charge}) : super(key: key);
  @override
  ScreenState createState() {
    return ScreenState();
  }
}

class ScreenState extends State<Screen> with SingleTickerProviderStateMixin {
  List<Tab> _myTabs;
  List<LayoutCallback> _tabGen;
  List<String> _tabUrl;
  int _tab = 0;
  TabController _tabController;

  PrintingInfo printingInfo;
  List<Cart> items;
  FirestoreService fireServ = new FirestoreService();
  StreamSubscription<QuerySnapshot> todoTasks;
  @override
  void initState() {
    super.initState();
    _init();
    items = new List();

    todoTasks?.cancel();
    todoTasks = fireServ.getTaskList().listen((QuerySnapshot snapshot) {
      final List<Cart> tasks = snapshot.docs
          .map((documentSnapshot) => Cart.fromMap(documentSnapshot.data()))
          .toList();
      // setState(() {
      items = tasks;
      // });
    });
    print(items.length);
  }

  Future<void> _init() async {
    final PrintingInfo info = await Printing.info();

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

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  final pdf = pw.Document();

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final Uint8List bytes = await build(pageFormat);
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File file = File(appDocPath + '/' + 'document.pdf');
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
        title: const Text('Pdf Printing Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _myTabs,
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => _generatePdf(format),
        //  _tabGen[_tab],
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

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                    height: 70,
                    child: pw.FittedBox(
                      child: pw.Text(
                        'Total: 679',
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
                            // color: _darkColor,
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
                                  text: 'Gabriel Musodza\n',
                                  style: pw.TextStyle(
                                    // color: _darkColor,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  children: [
                                const pw.TextSpan(
                                  text: '\n',
                                  style: pw.TextStyle(
                                    fontSize: 5,
                                  ),
                                ),
                                pw.TextSpan(
                                  text: 'customerAddress',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    fontSize: 10,
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
                                // pw.style: _statLabelTextStyle,
                                // textAlign: TextAlign.start,
                              ),
                            ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(
                            receipt.title.toUpperCase(),
                            // style: _statLabelTextStyle,
                          ),
                        ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(
                            receipt.price.toString(),
                            // style: _statLabelTextStyle
                          ),
                        ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(
                            receipt.subtotal.toString(),
                            // style: _statLabelTextStyle
                          ),
                        ]),
                      ]);
                }),
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
                          // color: _darkColor,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                        child: pw.Text(
                          'Payment Info:',
                          style: pw.TextStyle(
                            // color: baseColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        'paymentInfo',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          lineSpacing: 5,
                          // color: _darkColor,
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
                      // color: _darkColor,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Sub Total:'),
                            pw.Text('999'),
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
                            // color: baseColor,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Total:'),
                              pw.Text('_formatCurrency(_grandTotal)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ]));
        },
      ),
    );

    return pdf.save();
  }
}
