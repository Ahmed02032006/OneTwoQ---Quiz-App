import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_app/AnimationFormat/FadeAnimation.dart';
import 'package:quiz_app/helpers/ad_helper.dart';
import 'package:quiz_app/pages/categories.dart';
import 'package:quiz_app/pages/faq.dart';
import 'package:quiz_app/pages/privacy_policy.dart';
import 'package:quiz_app/pages/terms_and_conditions.dart';
import 'package:quiz_app/pages/truerandomquestions.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool isButtonDisplayed = false;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false; // Track ad loading status

  @override
  void initState() {
    super.initState();
    fetchSettings();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true; // Mark ad as loaded
          });
          debugPrint("Banner Ad loaded successfully");
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> fetchSettings() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('Settings')
          .doc('2fbG1GP9nX7XJrgGaA6H')
          .get();
      if (doc.exists) {
        var isbuttonDisplay = doc.data()?['isButtonDisplayed'];
        setState(() {
          isButtonDisplayed = isbuttonDisplay;
        });
      } else {
        debugPrint("Document does not exist");
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Dispose of ad when leaving screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const TermsAndConditions(),
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                FadePageRoute(page: const TermsAndConditions()),
                              );
                            },
                            child: Image.asset(
                              "assets/images/TAC.png",
                              height: screenHeight * 0.04,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const PrivacyPolicy(),
                                  //   ),
                                  // );
                                  Navigator.push(
                                    context,
                                    FadePageRoute(page: const PrivacyPolicy()),
                                  );
                                },
                                child: Image.asset(
                                  "assets/images/PP.png",
                                  height: screenHeight * 0.04,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const Faq(),
                                  //   ),
                                  // );
                                  Navigator.push(
                                    context,
                                    FadePageRoute(page: const Faq()),
                                  );
                                },
                                child: Image.asset(
                                  "assets/images/settings-gears 1.png",
                                  height: screenHeight * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Image.asset(
                        'assets/images/preloader.png', // Replace with your image asset path
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (isButtonDisplayed)
                      Column(
                        children: [
                          buildButton(
                            context,
                            screenWidth,
                            "Categories",
                            "Choose a question category and then answer a grouping of questions. This is the definitive way to play.",
                            const Categories(),
                          ),
                          const SizedBox(height: 35),
                          buildButton(
                            context,
                            screenWidth,
                            "True Random",
                            "Feeling crazy? Answer questions taken randomly from every category on the app.",
                            const TrueRandomQuestions(),
                          ),
                        ],
                      )
                    // const SizedBox(height: 35),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        minimumSize: Size(double.infinity, screenHeight * 0.05),
                      ),
                      child: const Text(
                        '',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _isAdLoaded
          ? SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox(),
    );
  }

  Widget buildButton(
    BuildContext context,
    double screenWidth,
    String title,
    String subtitle,
    Widget targetScreen,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => targetScreen,
              //   ),
              // ),
              Navigator.push(
            context,
            FadePageRoute(page: targetScreen),
          ),
          child: Container(
            width: screenWidth * 0.7,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 13, 211, 19),
                width: 5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 25,
                  blurStyle: BlurStyle.outer,
                  offset: Offset(0, 0.2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 35,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: screenWidth * 0.7,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
