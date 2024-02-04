import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptocoin/components/chart.dart';
import 'package:cryptocoin/components/coinModel.dart';
import 'package:cryptocoin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../providers/firebase_auth_methods.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class CoinDetailsPage extends StatefulWidget {
  const CoinDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currency,
    required this.price,
    required this.change,
    required this.changePercentage,
    required this.pchange,
    required this.pchangePercentage,
    required this.pricechart,
  });

  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final String currency;
  final double price;
  final double change;
  final double changePercentage;
  final double pchange;
  final double pchangePercentage;
  final List<double> pricechart;

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  bool coinExists = false;
  int currentIndex = 0;
  String description = '';
  @override
  void initState() {
    (widget.name);
    getCryptocurrencyDefinition(widget.id);
    super.initState();
  }

  Future<void> getCryptocurrencyDefinition(String id) async {
    final response = await http
        .get(Uri.parse('https://api.coingecko.com/api/v3/coins/${id}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        description = data['description']['en'].toString().isNotEmpty
            ? r'''''' + data['description']['en']
            : r'''No description available.''';
      });
    } else {
      setState(() {
        description = r'''No description available''';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.name,
          style: GoogleFonts.aleo(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1), //  glass effect,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    height: 250,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Center(
                            child: Text(
                              widget.currency == 'eur'
                                  ? widget.price.toStringAsFixed(2) + '\€'
                                  : widget.currency == 'usd'
                                      ? '\$' + widget.price.toStringAsFixed(2)
                                      : widget.currency == 'btc'
                                          ? '₿' +
                                              widget.price.toStringAsFixed(2)
                                          : '\$' +
                                              widget.price.toStringAsFixed(2),
                              style: GoogleFonts.aleo(
                                  color: Colors.white,
                                  fontSize: 25),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CoinChart(
                              color: Colors.white,
                              pricechart: widget.pricechart,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8, bottom: 4),
                          child: Text(
                            'Last 7 days',
                            style: GoogleFonts.aleo(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.aleo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' description',
                    style: GoogleFonts.aleo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            description.isNotEmpty
                ? Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: SingleChildScrollView(
                          child: Text(
                        style: GoogleFonts.aleo(
                          color: Colors.white,
                        ),
                        description.toString(),
                      )),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CupertinoActivityIndicator(
                        radius: 10, color: Colors.white),
                  )
          ],
        ),
      ),
    );
  }
}

class Stat extends StatelessWidget {
  final String title;
  final String value;
  final double value2;
  final String wis;
  final String wis2;
  final bool color;
  final Color mainColor;

  const Stat(
      {super.key,
      required this.title,
      required this.value,
      required this.wis,
      required this.wis2,
      required this.color,
      required this.value2,
      required this.mainColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(color: mainColor),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    wis,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.aleo(
                        color: Theme.of(context).iconTheme.color),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      wis2,
                      style: TextStyle(color: mainColor),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.all(7),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[800]!,
                // color: Colors.black.withAlpha(15),
                width: 1.0,
              ),
            ),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              flex: 5,
              child: Text(
                title,
                style: GoogleFonts.aleo(
                  color: Theme.of(context).iconTheme.color,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.aleo(
                  color: color
                      ? value2 < 0
                          ? Colors.red
                          : Colors.green
                      : mainColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
