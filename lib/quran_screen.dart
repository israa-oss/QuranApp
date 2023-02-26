import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Search.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List _items = [];
  final PageController _pageController = PageController();

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/hafs_smart_v8.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["sura"];
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'القرآن الكريم',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(items: _items),
                );
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: PageView.builder(
          controller: _pageController,
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            if (_items.isNotEmpty) {
              String byPage = '';
              String surahName = '';
              int jozzNum = 0;
              bool isBasmalahShown = false;

              for (Map ayahData in _items) {
                if (ayahData['page'] == index + 1) {
                  byPage = '$byPage ${ayahData['aya_text']}';
                }
              }

              for (Map ayahData in _items) {
                if (ayahData['page'] == index + 1) {
                  surahName = ayahData['sura_name_ar'];
                }
              }

              for (Map ayahData in _items) {
                if (ayahData['page'] == index + 1) {
                  jozzNum = ayahData['jozz'];
                }
              }

              for (Map ayahData in _items) {
                if (ayahData['page'] == index + 1) {
                  if (ayahData['aya_no'] == 1 &&
                      ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                      ayahData['sura_name_ar'] != 'التوبَة') {
                    isBasmalahShown = true;
                    break;
                  }
                }
              }

              return SafeArea(
                child: Container(
                  decoration: index % 2 == 0
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                              Color(0x27000000),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent
                            ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight))
                      : const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                              Color(0x27000000),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent
                            ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الجزء $jozzNum',
                                    style: const TextStyle(
                                        fontFamily: 'Kitab', fontSize: 20),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text(
                                    surahName,
                                    style: const TextStyle(
                                        fontFamily: 'Kitab', fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isBasmalahShown
                                    ? const Text(
                                        "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontFamily: 'Hafs', fontSize: 22),
                                        textAlign: TextAlign.center,
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  byPage,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                      fontFamily: 'Hafs', fontSize: 22),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 18),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Color(0xffbce0c5),
              ));
            }
          },
        ),
      ),
    );
  }
}
