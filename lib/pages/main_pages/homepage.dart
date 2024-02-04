import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptocoin/components/coinCard.dart';
import 'package:cryptocoin/components/coinModel.dart';
import 'package:cryptocoin/pages/main_pages/coinDetails.dart';
import 'package:cryptocoin/providers/firebase_auth_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

enum _SelectedTab { home, settings }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedTab = _SelectedTab.home; // Tab selecionado (home/Settings)
  List<Coin> coinsList = []; // Todos os coins da request
  List<String> currencys = ['€', '\$']; // As moedas
  String? selectedCurrency; // Moeda selecionada
  bool isLoading = true; // Se deu load na request
  int? count; //Timer
  int? _currentTime; //Timer
  Timer? _timer; //Timer

// Função para saber se a tab mudou
  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  //Função para obter a crypto moedas
  Future<Object> fetchCoin() async {
    await getCurrency();
    coinList = [];
    isLoading = true;
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=$selectedCurrency&order=market_cap_desc&per_page=250&page=1&sparkline=true'));

    if (response.statusCode == 200) {
      //Se for 200 a api respondeu certo
      List<dynamic> values = []; // Lista temporaria das moedas
      values = json.decode(response.body); //Traformar o body em json
      if (values.length > 0) {
        // Se for maior q 0 passa
        for (int i = 0; i < values.length; i++) {
          //LOOP para todos os valores que existirem na request
          if (values[i] != null) {
            // Se n for nulo
            Map<String, dynamic> map = values[i]; // associa a um map os valores
            coinList.add(Coin.fromJson(map)); // Adiociona a coin list
          }
        }
        setState(() {
          isLoading = false;
          coinList;
          count = 0;
          _currentTime = 5;
        });
      }
      return coinsList;
    } else {
      return _currentTime = 5;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      count = (count! + 1);
      if (count == 5) {
        setState(() {
          _currentTime = 5;
          count = 0;
        });
        fetchCoin();
      } else {
        if (mounted) {
          setState(() {
            _currentTime = (_currentTime! - 1);
          });
        }
      }
    });
  }

  // Ir buscar a currency
  Future<String?> getCurrency() async {
    final user = context.read<FirebaseAuthMethods>().user;
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      selectedCurrency = doc['currency'];
    });
    return selectedCurrency;
  }

  // Correr as funcoes quando a pagina iniciar
  @override
  void initState() {
    fetchCoin();
    _startTimer();
    super.initState();
  }

  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    Color primary = Theme.of(context).primaryColor;
    Color? text = Theme.of(context).iconTheme.color;
    return Scaffold(
      extendBody: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Color(0xff413372)),
            child: _selectedTab.index == 0
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 40, left: 20, right: 20, bottom: 0),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: isLoading
                                                        ? CupertinoActivityIndicator(
                                                            radius: 9,
                                                            color: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .color)
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 6.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "All Coins",
                                                                  style: GoogleFonts.aleo(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                _currentTime ==
                                                                        1
                                                                    ? Text(
                                                                        'Updates in $_currentTime min',
                                                                        style: GoogleFonts.aleo(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      )
                                                                    : Text(
                                                                        'Updates in $_currentTime min',
                                                                        style: GoogleFonts.aleo(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                              ],
                                                            ),
                                                          )),
                                                GestureDetector(
                                                  // Ao carregar em reload
                                                  onTap: () {
                                                    _timer!.cancel();
                                                    fetchCoin();
                                                    _startTimer();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    93,
                                                                    73,
                                                                    168)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Icon(
                                                            size: 20,
                                                            Icons.refresh,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20, bottom: 0),
                          child: Container(
                              child: Column(
                            children: [
                              Expanded(
                                child: isLoading
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 20,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                bottom: 5),
                                            child: Container(
                                              width: 200,
                                              height: 50,
                                            ),
                                          );
                                        })
                                    : ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Divider(
                                            color: Colors.transparent,
                                            height: 10,
                                          ),
                                        ),
                                        itemCount: 250,
                                        itemBuilder: (context, index) {
                                          if (coinList.isNotEmpty) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CoinDetailsPage(
                                                                  id: coinList[
                                                                          index]
                                                                      .id,
                                                                  name: coinList[
                                                                          index]
                                                                      .name,
                                                                  symbol: coinList[
                                                                          index]
                                                                      .symbol,
                                                                  imageUrl: coinList[
                                                                          index]
                                                                      .imageUrl,
                                                                  currency:
                                                                      selectedCurrency ??
                                                                          'eur',
                                                                  price: coinList[
                                                                          index]
                                                                      .price
                                                                      .toDouble(),
                                                                  change: coinList[
                                                                          index]
                                                                      .change
                                                                      .toDouble(),
                                                                  changePercentage: coinList[
                                                                          index]
                                                                      .changePercentage
                                                                      .toDouble(),
                                                                  pchange: coinList[
                                                                          index]
                                                                      .pchange
                                                                      .toDouble(),
                                                                  pchangePercentage: coinList[
                                                                          index]
                                                                      .pchangePercentage
                                                                      .toDouble(),
                                                                  pricechart: coinList[
                                                                          index]
                                                                      .pricechart,
                                                                )));
                                              },
                                              child: CoinCard(
                                                primary: primary,
                                                text: text!,
                                                name: coinList[index].name,
                                                symbol: coinList[index].symbol,
                                                imageUrl:
                                                    coinList[index].imageUrl,
                                                currency:
                                                    selectedCurrency ?? 'eur',
                                                price: coinList[index]
                                                    .price
                                                    .toDouble(),
                                                pchange: coinList[index]
                                                    .pchange
                                                    .toDouble(),
                                                pchangePercentage:
                                                    coinList[index]
                                                        .pchangePercentage
                                                        .toDouble(),
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Container(
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Settings",
                            style: GoogleFonts.aleo(
                                color: Colors.white,
                                fontSize: 33,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      IconlyBold.profile,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      user.displayName as String,
                                      style: GoogleFonts.aleo(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Color(0xFFC7BBF2),
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.currency_bitcoin,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Currency",
                                          style: GoogleFonts.aleo(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: SizedBox(
                                              height: 40,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  dropdownColor: Color.fromARGB(
                                                      255, 182, 160, 254),
                                                  iconSize: 0.0,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  value:
                                                      selectedCurrency == 'eur'
                                                          ? '€'
                                                          : '\$',
                                                  items: currencys
                                                      .map(
                                                        (e) => DropdownMenuItem<
                                                                String>(
                                                            value: e,
                                                            child: Text(
                                                              e,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      )
                                                      .toList(),
                                                  onChanged:
                                                      (String? value) async {
                                                    var value2;
                                                    if (value == '€') {
                                                      value2 = 'eur';
                                                    } else if (value == '\$') {
                                                      value2 = 'usd';
                                                    }

                                                    final docUser =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user.uid);
                                                    final newTrip = {
                                                      "currency": value2,
                                                    };

                                                    await docUser.update(
                                                      newTrip,
                                                    );
                                                    setState(() {
                                                      selectedCurrency = value2;
                                                    });
                                                    _timer!.cancel();
                                                    fetchCoin();
                                                    _startTimer();
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 28.0, right: 28.0, bottom: 125.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<FirebaseAuthMethods>()
                                        .signOut(context);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 100.w,
                                        padding: const EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: const Color(0xFFC7BBF2),
                                        ),
                                        child: Text(
                                          'Sign out',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.aleo(
                                            color: const Color(0xFF251A4B),
                                            fontSize: 23,
                                            fontWeight: FontWeight.w900,
                                          ),
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
                    ),
                  )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 80, left: 80),
        child: CrystalNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          // indicatorColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.1),
          // outlineBorderColor: Colors.black.withOpacity(0.1),
          itemPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          marginR: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          onTap: _handleIndexChanged,
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.white,
            ),

            /// Settings
            CrystalNavigationBarItem(
              icon: IconlyBold.setting,
              unselectedIcon: IconlyLight.setting,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
