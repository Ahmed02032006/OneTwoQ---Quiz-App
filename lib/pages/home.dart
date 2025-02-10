// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:quiz_app/helpers/ad_helper.dart';
// import 'package:quiz_app/pages/disclaimer.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   BannerAd? _bannerAd;
//   bool _isAdLoaded = false; // Track ad loading status

//   @override
//   void initState() {
//     super.initState();
//     _loadBannerAd();
//   }

//   void _loadBannerAd() {
//     _bannerAd = BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       request: AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _isAdLoaded = true; // Mark ad as loaded
//           });
//           debugPrint("Banner Ad loaded successfully");
//         },
//         onAdFailedToLoad: (ad, err) {
//           debugPrint('Failed to load banner ad: ${err.message}');
//           ad.dispose();
//         },
//       ),
//     )..load();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 const SizedBox(height: 100),
//                 Image.asset(
//                   'assets/images/preloader.png',
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 13, 211, 19),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       minimumSize: const Size(double.infinity, 80),
//                     ),
//                     child: const Text(
//                       'How will the world answer?',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const Disclaimer()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20),
//                     ),
//                   ),
//                   minimumSize: const Size(double.infinity, 40),
//                 ),
//                 child: const Text(
//                   'Next',
//                   style: const TextStyle(
//                     fontSize: 22,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _isAdLoaded
//           ? SizedBox(
//               height: _bannerAd!.size.height.toDouble(),
//               width: _bannerAd!.size.width.toDouble(),
//               child: AdWidget(ad: _bannerAd!),
//             )
//           : SizedBox(), // Hide if ad is not loaded
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_app/helpers/ad_helper.dart';
import 'package:quiz_app/pages/disclaimer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false; // Track ad loading status
  bool _isAgreed = false; // Track if the user has agreed to the terms

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _showTermsAndConditions();
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

  void _showTermsAndConditions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isDismissible: false, // User cannot dismiss without agreeing
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Terms & Conditions",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "By using this App, you acknowledge and accept that we use personalized ads through third-party services like Google AdMob. These ads are tailored based on your preferences and may involve the collection of data such as your device ID and usage patterns. If you agree to the use of personalized ads, please click 'Accept.' If you do not agree, you can still use the App, but non-personalized ads will be shown instead. For more information on how your data is handled, please refer to our Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isAgreed = true; // User has agreed
                    });
                    Navigator.pop(context); // Close modal
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 13, 211, 19),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "I Agree",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _navigateToNextScreen() {
    if (!_isAgreed) {
      _showTermsAndConditions();
      return;
    }

    _bannerAd?.dispose(); // Dispose ad before navigating
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Disclaimer()),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Dispose of ad when leaving screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  'assets/images/preloader.png',
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 13, 211, 19),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size(double.infinity, 80),
                    ),
                    child: const Text(
                      'How will the world answer?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _navigateToNextScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isAdLoaded
          ? SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox(), // Hide if ad is not loaded
    );
  }
}
