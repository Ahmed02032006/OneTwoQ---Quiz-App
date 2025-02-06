import 'package:flutter/material.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

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
                child: Container(
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
                        "FAQ",
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
                          "Hello again, my name is Aiden and I started working on One Two Q in 2019. I started this project because I was curious about how people from all over the world and from different walks of life might answer the same question. I want to know what makes us the people we are and how our life experiences define us and I hope that's why you're here too. Please know that all questions and information you give to the app are completely anonymous. You may be giving up your anonymity, however, if you decide to link a social media account and share your experiences with friends or by making comments on questions within the app.I hope you enjoy the app and the statistics for each question. If you would like to support me, the best thing you could do to help is just to tell your friends about the app and the things about the app and the things you like about it. I came up with a lot of questions over the years, but I can use your help and your creativity. I f you've got questions you want answered, please send them to me at xxxxx@xxxxx.com or join me on discord. Feel free to drop your username when submitting a username when submitting a question I'll put your name besides your question. One question is gret but i'm sure you've noticed that I group my questions into modules, if you have a series of questions you'll have a better shot of having your questions put in the app. If submitting a seriesof questions please submit a minimum of 6 questions that all relate to each other. I'll do my best to add your questions to the app but I cannot guarantee anything. I hope you understand.",
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
