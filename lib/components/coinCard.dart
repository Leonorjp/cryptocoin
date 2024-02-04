import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/firebase_auth_methods.dart';

class CoinCard extends StatefulWidget {
  CoinCard({
    required this.primary,
    required this.text,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currency,
    required this.price,
    required this.pchange,
    required this.pchangePercentage,
  });

  Color primary;
  Color text;
  String name;
  String symbol;
  String imageUrl;
  String currency;
  double price;
  double pchange;
  double pchangePercentage;

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  bool coinExists = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    return Container(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.1), //  glass effect
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network(widget.imageUrl),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.symbol.toUpperCase(),
                                  style: GoogleFonts.aleo(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                widget.currency == 'eur'
                                    ? widget.price.toDouble().toString() + '\€'
                                    : widget.currency == 'usd'
                                        ? '\$' +
                                            widget.price.toDouble().toString()
                                        : widget.currency == 'btc'
                                            ? '₿' +
                                                widget.price
                                                    .toDouble()
                                                    .toString()
                                            : '\$' +
                                                widget.price
                                                    .toDouble()
                                                    .toString(),
                                style: GoogleFonts.aleo(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.pchange.toDouble() < 0
                                      ? Color(0xFFFFB6B3).withOpacity(0.6)
                                      : Color(0xFFBDE7BD).withOpacity(0.6),
                                  border: Border.all(
                                    color: widget.pchange.toDouble() < 0
                                        ? Color(0xFFFFB6B3)
                                        : Color(0xFFBDE7BD),
                                    width: 1,
                                  )),
                              child: Text(
                                widget.pchangePercentage.roundToDouble() < 0
                                    ? widget.pchangePercentage
                                            .roundToDouble()
                                            .toString() +
                                        '%'
                                    : '+' +
                                        widget.pchangePercentage
                                            .roundToDouble()
                                            .toString() +
                                        '%',
                                style: GoogleFonts.aleo(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Container(
                              padding: EdgeInsets.all(3.5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.pchange.toDouble() < 0
                                      ? Color(0xFFFFB6B3).withOpacity(0.6)
                                      : Color(0xFFBDE7BD).withOpacity(0.6),
                                  border: Border.all(
                                    color: widget.pchange.toDouble() < 0
                                        ? Color(0xFFFFB6B3)
                                        : Color(0xFFBDE7BD),
                                    width: 1,
                                  )),
                              child: Text(
                                widget.pchange.toDouble() < 0
                                    ? widget.pchange
                                        .roundToDouble()
                                        .toDouble()
                                        .toString()
                                    : '+' +
                                        widget.pchange.toDouble().toString(),
                                style: GoogleFonts.aleo(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
