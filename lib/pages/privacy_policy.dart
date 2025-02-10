import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
                        "Privacy Policy",
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
                          "At OneTwoQ, we value your privacy and are committed to protecting the personal information you share with us. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our mobile application (the 'App'). When you use our App, we may collect non-personally identifiable information such as your device type, operating system, and usage patterns to improve your experience. Additionally, we use third-party services like Google AdMob to display advertisements within the App. Google AdMob may collect and use data such as your location, device ID, and usage history for delivering personalized ads. We do not collect any personal information unless you voluntarily provide it, such as in the case of app registration or support inquiries. We use the information we collect to serve relevant ads based on your interests, enhance the performance of the App, and understand how you interact with the App to improve future updates. We may also share aggregated data with third-party partners for analytical and advertising purposes. We take reasonable measures to protect your information from unauthorized access, but it is important to note that no method of internet data transmission is completely secure. While we strive to protect your privacy, we cannot guarantee complete security. We reserve the right to update this Privacy Policy periodically, and any changes will be reflected in the App with an updated 'Effective Date.' For further details, you may refer to the Google AdMob privacy policy on their website.If you have any questions or concerns regarding our Privacy Policy, or if you would like to request additional information about how we handle your data, please reach out to us at [Insert Contact Information].",
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
