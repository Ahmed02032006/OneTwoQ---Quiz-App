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
                        child: const Column(
                          children: [
                            Text(
                              "Hello again, my name is Aidan and I started working on 1 2 Q back in 2019. I started this project because I was curious about how people from all over the world and from different walks of life might answer the same questions. I want to know what makes us the people we are and how our life experiences define us. I hope that’s why you’re here too. All information given is anonymous. The answers you choose and any other information you give to inform question statistics will be completely anonymous. Only if you wish to make comments will you be required to set up an account and username. Please note that your username will be linked to your social media accounts, and you may lose your anonymity if you decide to post question results to social media. Please skip questions if the question doesn’t apply to you or if you feel uncomfortable answering it.I hope you enjoy the app; it’s been an interesting ride getting the app off the ground starting with the years I spent brainstorming for questions. I of course, am only one person and if you think you’ve got some questions you’d like answered then send them over to me. A single question is good, but a series of questions is better. You’ll have a better shot of getting your question on to the app if you give me more to work with. Be sure to leave a name, real or fake that I can use to credit you with, anonymous is fine too though. I can’t guarantee that your questions will end up on the app, I hope you understand. If you do submit questions know that I myself, generally try to avoid questions about politics, religion, sex and other hot topics. I also do not have questions mentioning specific companies, groups, brands etc. There are, however, ways to ask questions about these things without being so forward. Please use your discretion. Please email your questions to aidan.one.two.q@gmail.com. That is my primary contact for this little venture of mine, if you have any business-related messages for me, send them there as well.If you’d like to support me, the best thing you could do is tell other people about the app. Here’s a fun way to play with friends, be sure to have snacks and drinks at the ready.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "1.	Get a group of friends around a table.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "2.	One player asks a question from the app to the group.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "3.	Other players then raise their hands for how they choose to answer the question.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "4.	Take note of how each player answered.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "5.	The player who asked the question then reveals how they would answer the question, players who answered the same as the person asking the question win. Losers, feel free to take a sip from their drink or grab some snacks in commiseration.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "6.	Pass the device with 1 2 Q to the player on the left and repeat steps 2 through 6.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Alternatively, players can pass the device to another player after an entire module of questions is complete. Also, you can post questions to social media for your friends who didn’t make it to the hangout. Have fun!You'll notice the AI tag with a few modules. These questions have been generated by AI using information inputs directed by myself. These questions appear word per word as per how the AI generated them. The use of AI is becoming more and more prevalent in today’s society so this is why I am being transparent about my usage of AI. I use AI mostly as a sounding board to brainstorm questions, AI is good at throwing random topics at me which might inspire a question or two every now and again.P.S: The statistics on this app will never truly be correct, people will lie and people will choose against their better judgement for reasons only they can explain. I can be a troll sometimes too so I get it.P.S.S: It is not lost on me that we cannot truly find out how the world will answer if the app is only in English. One day I’d love to get everything on here translated into as many languages as I can.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
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
