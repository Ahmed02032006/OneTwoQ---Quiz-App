import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header Section (non-scrollable)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Image.asset(
                          width: 150,
                          height: 150,
                          'assets/images/preloader.png', // Replace with your image asset path
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          decorationThickness: 3,
                        ),
                      ),
                      const SizedBox(height: 40),
                  
                      // FAQ Content (scrollable)
                      Container(
                        padding: const EdgeInsets.all(25),
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 13, 211, 19),
                        ),
                        child: const Text(
                          "By downloading and using OneTwoQ, you agree to comply with and be bound by these Terms and Conditions. This agreement outlines the rules and guidelines for using our mobile application, and by continuing to use the App, you confirm that you understand and accept these terms. You are granted a limited, non-exclusive, non-transferable license to access and use the App for personal, non-commercial use only. You are responsible for ensuring that your use of the App complies with all relevant laws, regulations, and guidelines.The App may display advertisements provided by third-party networks such as Google AdMob. These advertisements may collect non-personal information such as your device's location and usage data to deliver targeted ads. By using the App, you consent to the collection and use of this data in accordance with the AdMob Privacy Policy. We are not responsible for any third-party content, including advertisements, that may appear in the App.While we strive to provide a seamless and enjoyable experience, we do not guarantee that the App will be free from errors, interruptions, or issues. We reserve the right to modify, suspend, or discontinue the App at any time without notice. In no event shall the developers of this App be held liable for any damages arising from the use or inability to use the App, including damages resulting from third-party advertisements.We may update these Terms and Conditions from time to time, and any changes will be posted in the App along with an updated 'Effective Date.' We encourage you to review these terms regularly. If you do not agree to any changes, you should discontinue using the App. If you have any questions or concerns regarding these Terms and Conditions, please contact us at OneTwoQ@gmail.com .",
                          
                          
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.more_horiz_sharp,
                        size: 100,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(
                        height: 50,
                      ), // Extra space to avoid overlapping with the button
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Positioned 'Back' button at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
                'Back',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
