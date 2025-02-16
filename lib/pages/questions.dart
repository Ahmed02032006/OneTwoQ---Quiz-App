import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quiz_app/pages/forwarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions>
    with SingleTickerProviderStateMixin {
  String question = '';
  bool isLoading = true;
  bool showStats = false;
  Map<String, dynamic> stats = {};
  String currentCategoryId = '';
  String currentQuestionId = '';

  bool isStatsDisplayed = false;

  // Animation

  bool isAnimationLoading = false; // Set this to control loading state
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Create the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration for fade-in animation
    );

    // Create the opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Trigger animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimationLoading = true;
      });
      _controller.reset();
      _controller.forward(); // Trigger the fade-in animation
    });
    fetchSettings();
    updateProgressValues();
    fetchQuestion();
  }

  Future<void> fetchSettings() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('Settings')
          .doc('2fbG1GP9nX7XJrgGaA6H')
          .get();
      if (doc.exists) {
        var isStatsDisplay = doc.data()?['isStatsDisplayed'];
        setState(() {
          isStatsDisplayed = isStatsDisplay;
        });
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  Future<void> fetchQuestion() async {
    setState(() {
      isLoading = true;
      showStats = false;
    });

    try {
      QuerySnapshot questionsSnapshot =
          await FirebaseFirestore.instance.collection('questions').get();

      List<DocumentSnapshot> questionDocs = questionsSnapshot.docs;

      Set<String> categoryIds = {};
      for (var doc in questionDocs) {
        categoryIds.add(doc['categoryId']);
      }

      if (categoryIds.isEmpty) {
        setState(() {
          question = 'No categories with questions found';
          isLoading = false;
        });
        return;
      }

      List<String> validCategoryIds = categoryIds.toList();
      validCategoryIds.shuffle();
      String randomCategoryId = validCategoryIds.first;

      QuerySnapshot randomQuestionSnapshot = await FirebaseFirestore.instance
          .collection('questions')
          .where('categoryId', isEqualTo: randomCategoryId)
          .get();

      List<DocumentSnapshot> questionsForCategory = randomQuestionSnapshot.docs;

      if (questionsForCategory.isEmpty) {
        setState(() {
          question = 'No questions found for this category';
          isLoading = false;
        });
        return;
      }

      questionsForCategory.shuffle();
      DocumentSnapshot randomQuestion = questionsForCategory.first;

      setState(() {
        question = randomQuestion['question'];
        currentCategoryId = randomCategoryId;
        currentQuestionId = randomQuestion.id;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching question: $e');
      setState(() {
        question = 'Error fetching question';
        isLoading = false;
      });
    }
  }

  Future<void> fetchAndShowStats() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot statsDoc = await FirebaseFirestore.instance
          .collection('stats')
          .doc(currentCategoryId)
          .collection('questions')
          .doc(currentQuestionId)
          .get();

      if (statsDoc.exists) {
        setState(() {
          stats = statsDoc.data() as Map<String, dynamic>;
          showStats = true;
          isLoading = false;
        });
      } else {
        setState(() {
          stats = {'yesCount': 0, 'noCount': 0};
          showStats = true;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching stats: $e');
      setState(() {
        stats = {'error': 'Error fetching stats'};
        showStats = true;
        isLoading = false;
      });
    }
  }

  Future<void> updateStats(bool answer) async {
    String field = answer ? 'yesCount' : 'noCount';
    try {
      await FirebaseFirestore.instance
          .collection('stats')
          .doc(currentCategoryId)
          .collection('questions')
          .doc(currentQuestionId)
          .set({field: FieldValue.increment(1)}, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating stats: $e');
    }
  }

  void updateProgressValues() {
    // Random number generator
    final random = Random();

    // Generate a random value between 0.3 and 0.8
    double generateRandomProgress() {
      return 0.3 + (random.nextDouble() * (0.8 - 0.3));
    }

    // Update each variable with a random value
    m1Progress = generateRandomProgress();
    m2Progress = generateRandomProgress();

    mProgress = generateRandomProgress();
    fProgress = generateRandomProgress();
    nProgress = generateRandomProgress();

    a1Progress = generateRandomProgress();
    a2Progress = generateRandomProgress();
    a3Progress = generateRandomProgress();
    a4Progress = generateRandomProgress();
    a5Progress = generateRandomProgress();
    a6Progress = generateRandomProgress();

    c1Progress = generateRandomProgress();
    c2Progress = generateRandomProgress();
    c3Progress = generateRandomProgress();
    c4Progress = generateRandomProgress();
    c5Progress = generateRandomProgress();
    c6Progress = generateRandomProgress();
  }

// Variables
  double m1Progress = 0.5;
  double m2Progress = 0.5;

  double mProgress = 0.5;
  double fProgress = 0.6;
  double nProgress = 0.7;

  double a1Progress = 0.2;
  double a2Progress = 0.3;
  double a3Progress = 0.4;
  double a4Progress = 0.5;
  double a5Progress = 0.6;
  double a6Progress = 0.7;

  double c1Progress = 0.3;
  double c2Progress = 0.4;
  double c3Progress = 0.5;
  double c4Progress = 0.6;
  double c5Progress = 0.7;
  double c6Progress = 0.8;

  List<TextSpan> _parseStyledText(String text) {
    final regex =
        RegExp(r'(\*\*(.*?)\*\*)|(?:^| )_(.*?)(?:_|$)|(?:^| )__(.*?)(?:__|$)');

    final List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Add normal text before any matched styled text
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(text: text.substring(currentIndex, match.start)),
        );
      }

      if (match.group(1) != null) {
        // Bold text (**text**)
        spans.add(
          TextSpan(
            text: match.group(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else if (match.group(3) != null) {
        // Italic text (_text_)
        spans.add(
          TextSpan(
            text: match.group(3),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (match.group(4) != null) {
        // Underline text (__text__)
        spans.add(
          TextSpan(
            text: match.group(4),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
        );
      }

      currentIndex = match.end;
    }

    // Add remaining normal text
    if (currentIndex < text.length) {
      spans.add(
        TextSpan(text: text.substring(currentIndex)),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                showStats
                    ? const SizedBox(height: 8)
                    : const SizedBox(height: 40),
                showStats
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Share.share(question);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 13, 211, 19),
                              ),
                              // color: const Color.fromARGB(255, 13, 211, 19),
                              child: const Icon(
                                Icons.share_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                    : const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Image.asset(
                    width: 100,
                    height: 100,
                    'assets/images/preloader.png', // Replace with your image asset path
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Container(
                        width: 100,
                        height: showStats == true ? 80 : 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 13, 211, 19),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : showStats
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Most questions are answered in a simple yes or no format. Please select Yes or No.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: _parseStyledText(question),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (isStatsDisplayed)
                  if (showStats)
                    // SizedBox(
                    //   height: 330,
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.vertical,
                    //     child: Column(
                    //       children: [
                    //         Column(
                    //           children: [
                    //             const Padding(
                    //               padding: EdgeInsets.symmetric(horizontal: 35),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text("YES or option 1"),
                    //                   SizedBox(
                    //                     width: 50,
                    //                   ),
                    //                   Text("NO or option 2"),
                    //                 ],
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               height: 5,
                    //             ),
                    //             CustomLoadingBar(
                    //               progress: m1Progress,
                    //               delay: const Duration(milliseconds: 400),
                    //             ),
                    //             const SizedBox(
                    //               height: 15,
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 50),
                    //               child: Column(
                    //                 children: [
                    //                   const Text("Did you like this question?"),
                    //                   const SizedBox(
                    //                     height: 5,
                    //                   ),
                    //                   Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             horizontal: 40, vertical: 2),
                    //                         decoration: BoxDecoration(
                    //                           borderRadius:
                    //                               const BorderRadius.all(
                    //                             Radius.circular(10),
                    //                           ),
                    //                           border: Border.all(
                    //                             width: 5,
                    //                             color: const Color.fromARGB(
                    //                                 255, 13, 211, 19),
                    //                           ),
                    //                         ),
                    //                         child: const Icon(
                    //                           Icons.thumb_up,
                    //                           color: Color.fromARGB(
                    //                               255, 13, 211, 19),
                    //                         ),
                    //                       ),
                    //                       const SizedBox(
                    //                         width: 10,
                    //                       ),
                    //                       Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             horizontal: 40, vertical: 2),
                    //                         decoration: BoxDecoration(
                    //                           borderRadius:
                    //                               const BorderRadius.all(
                    //                             Radius.circular(10),
                    //                           ),
                    //                           border: Border.all(
                    //                             color: Colors.grey,
                    //                             width: 5,
                    //                           ),
                    //                         ),
                    //                         child: const Icon(
                    //                           Icons.thumb_down,
                    //                           color: Colors.grey,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             Column(
                    //               children: [
                    //                 const SizedBox(
                    //                   height: 15,
                    //                 ),
                    //                 CustomLoadingBar(
                    //                   progress: m2Progress,
                    //                   delay: const Duration(milliseconds: 800),
                    //                 ),
                    //                 const SizedBox(
                    //                   height: 15,
                    //                 ),
                    //                 Row(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Column(
                    //                       children: [
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: mProgress,
                    //                               delay: 500,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "M",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 5),
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: fProgress,
                    //                               delay: 1000,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "F ",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 5),
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: nProgress,
                    //                               delay: 1500,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "N",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 15),
                    //                       ],
                    //                     ),
                    //                     const SizedBox(
                    //                       width: 15,
                    //                     ),
                    //                     Column(
                    //                       children: [
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: a1Progress,
                    //                               delay: 2000,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "0 - 14   ",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 5),
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: a2Progress,
                    //                               delay: 2500,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "15 - 24 ",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 5),
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: a3Progress,
                    //                               delay: 3000,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "25 - 34",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 5),
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: a4Progress,
                    //                               delay: 3500,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "35 - 44",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 5),
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: a5Progress,
                    //                               delay: 4000,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "45 - 64",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 5),
                    //                         Row(
                    //                           children: [
                    //                             MiniLoadingBar(
                    //                               progress: a6Progress,
                    //                               delay: 4500,
                    //                             ),
                    //                             const SizedBox(width: 10),
                    //                             const Text(
                    //                               "65 +     ",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 15),
                    //                       ],
                    //                     )
                    //                   ],
                    //                 ),
                    //                 // ====================================================================== Country
                    //                 // ======================================================================
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 5),
                    //                   child: Row(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       Column(
                    //                         children: [
                    //                           Row(
                    //                             children: [
                    //                               MiniLoadingBar(
                    //                                 progress: c1Progress,
                    //                                 delay: 5000,
                    //                               ),
                    //                               const SizedBox(width: 10),
                    //                               SizedBox(
                    //                                 width: 35,
                    //                                 height: 20,
                    //                                 child: Image.asset(
                    //                                   "assets/images/USA.png",
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           const SizedBox(height: 5),
                    //                           Row(
                    //                             children: [
                    //                               MiniLoadingBar(
                    //                                 progress: c2Progress,
                    //                                 delay: 5500,
                    //                               ),
                    //                               const SizedBox(width: 10),
                    //                               SizedBox(
                    //                                 width: 35,
                    //                                 height: 20,
                    //                                 child: Image.asset(
                    //                                   "assets/images/UK.png",
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           const SizedBox(height: 5),
                    //                           Row(
                    //                             children: [
                    //                               MiniLoadingBar(
                    //                                 progress: c3Progress,
                    //                                 delay: 6000,
                    //                               ),
                    //                               const SizedBox(width: 10),
                    //                               SizedBox(
                    //                                 width: 35,
                    //                                 height: 20,
                    //                                 child: Image.asset(
                    //                                   "assets/images/FRANCE.png",
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           const SizedBox(height: 15),
                    //                         ],
                    //                       ),
                    //                       const SizedBox(
                    //                         width: 7,
                    //                       ),
                    //                       Column(
                    //                         children: [
                    //                           Row(
                    //                             children: [
                    //                               MiniLoadingBar(
                    //                                 progress: c4Progress,
                    //                                 delay: 6500,
                    //                               ),
                    //                               const SizedBox(width: 10),
                    //                               SizedBox(
                    //                                 width: 35,
                    //                                 height: 20,
                    //                                 child: Image.asset(
                    //                                   "assets/images/BOLIVIA.png",
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           const SizedBox(height: 5),
                    //                           Row(
                    //                             children: [
                    //                               MiniLoadingBar(
                    //                                 progress: c5Progress,
                    //                                 delay: 7000,
                    //                               ),
                    //                               const SizedBox(width: 10),
                    //                               SizedBox(
                    //                                 width: 35,
                    //                                 height: 20,
                    //                                 child: Image.asset(
                    //                                   "assets/images/BELGIUM.png",
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           const SizedBox(height: 5),
                    //                           Row(
                    //                             children: [
                    //                               MiniLoadingBar(
                    //                                 progress: c6Progress,
                    //                                 delay: 7500,
                    //                               ),
                    //                               const SizedBox(width: 10),
                    //                               SizedBox(
                    //                                 width: 35,
                    //                                 height: 20,
                    //                                 child: Image.asset(
                    //                                   "assets/images/PORTUGAL.png",
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 20),
                    //                   child: Align(
                    //                     alignment: Alignment.topLeft,
                    //                     child: Container(
                    //                       width: 130,
                    //                       height: 35,
                    //                       padding: const EdgeInsets.symmetric(
                    //                           horizontal: 10),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.grey
                    //                             .shade500, // Grey background color
                    //                         borderRadius:
                    //                             BorderRadius.circular(5),
                    //                       ),
                    //                       child: DropdownButton<String>(
                    //                         value:
                    //                             "USA", // Default selected value
                    //                         items: <String>[
                    //                           "USA",
                    //                           "UK",
                    //                           "FRANCE",
                    //                           "BELGIUM"
                    //                         ].map((String value) {
                    //                           return DropdownMenuItem<String>(
                    //                             value: value,
                    //                             child: Text(value),
                    //                           );
                    //                         }).toList(),
                    //                         onChanged: (String? newValue) {
                    //                           // Handle selection change
                    //                         },
                    //                         underline:
                    //                             const SizedBox(), // Removes the default underline
                    //                         dropdownColor: Colors.grey
                    //                             .shade400, // Grey background for the dropdown
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),

                    //             // const SizedBox(
                    //             //   height: 60,
                    //             // ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.6, // Adjust height relative to screen size
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 35),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("YES or option 1"),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Text("NO or option 2"),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomLoadingBar(
                                  progress: m1Progress,
                                  delay: const Duration(milliseconds: 1000),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.1, // Responsive padding
                                  ),
                                  child: Column(
                                    children: [
                                      const Text("Did you like this question?"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width *
                                                    0.1, // Responsive padding
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                border: Border.all(
                                                  width: 5,
                                                  color: const Color.fromARGB(
                                                      255, 13, 211, 19),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.thumb_up,
                                                color: Color.fromARGB(
                                                    255, 13, 211, 19),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width *
                                                    0.1, // Responsive padding
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.thumb_down,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomLoadingBar(
                                      progress: m2Progress,
                                      delay: const Duration(milliseconds: 2000),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: mProgress,
                                                      delay: 2500,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "M",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: fProgress,
                                                      delay: 3000,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "F ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: nProgress,
                                                      delay: 3500,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "N",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 15),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: a1Progress,
                                                      delay: 4000,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "0 - 14   ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: a2Progress,
                                                      delay: 4500,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "15 - 24 ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: a3Progress,
                                                      delay: 5000,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "25 - 34",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: a4Progress,
                                                      delay: 5500,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "35 - 44",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: a5Progress,
                                                      delay: 6000,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "45 - 64",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    MiniLoadingBar(
                                                      progress: a6Progress,
                                                      delay: 6500,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "65 +     ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 15),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    // ====================================================================== Country
                                    // ======================================================================
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  MiniLoadingBar(
                                                    progress: c1Progress,
                                                    delay: 7000,
                                                    myWidth: 110,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 35,
                                                    height: 20,
                                                    child: Image.asset(
                                                      "assets/images/USA.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  MiniLoadingBar(
                                                    progress: c2Progress,
                                                    delay: 7500,
                                                    myWidth: 110,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 35,
                                                    height: 20,
                                                    child: Image.asset(
                                                      "assets/images/UK.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  MiniLoadingBar(
                                                    progress: c3Progress,
                                                    delay: 8000,
                                                    myWidth: 110,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 35,
                                                    height: 20,
                                                    child: Image.asset(
                                                      "assets/images/FRANCE.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  MiniLoadingBar(
                                                    progress: c4Progress,
                                                    delay: 8500,
                                                    myWidth: 110,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 35,
                                                    height: 20,
                                                    child: Image.asset(
                                                      "assets/images/BOLIVIA.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  MiniLoadingBar(
                                                    progress: c5Progress,
                                                    delay: 9000,
                                                    myWidth: 110,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 35,
                                                    height: 20,
                                                    child: Image.asset(
                                                      "assets/images/BELGIUM.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  MiniLoadingBar(
                                                    progress: c6Progress,
                                                    delay: 9500,
                                                    myWidth: 110,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 35,
                                                    height: 20,
                                                    child: Image.asset(
                                                      "assets/images/PORTUGAL.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: 130,
                                          height: 35,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey
                                                .shade500, // Grey background color
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: DropdownButton<String>(
                                            value:
                                                "USA", // Default selected value
                                            items: <String>[
                                              "USA",
                                              "UK",
                                              "FRANCE",
                                              "BELGIUM"
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              // Handle selection change
                                            },
                                            underline:
                                                const SizedBox(), // Removes the default underline
                                            dropdownColor: Colors.grey
                                                .shade400, // Grey background for the dropdown
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                showStats
                    ? const SizedBox(width: 0, height: 0)
                    : const Spacer(),
                if (!showStats)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                            onPressed: () async {
                              await updateStats(true);
                              fetchAndShowStats();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.white, // White background
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 13, 211, 19),
                                  width: 6), // Green border
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    20,
                                  ), // Border radius on top-left
                                ),
                              ),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Makes the column size fit content
                              children: [
                                Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.grey, // Black color for "Yes"
                                    fontSize: 40, // Large size for "Yes"
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "palatino",
                                  ),
                                ),
                                Text(
                                  'Option 1',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                            onPressed: () async {
                              await updateStats(false);
                              fetchAndShowStats();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.white, // White background
                              side: const BorderSide(
                                  color: Colors.grey, width: 6), // Green border
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                      20), // Border radius on top-left
                                ),
                              ),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Makes the column size fit content
                              children: [
                                Text(
                                  'No',
                                  style: TextStyle(
                                    color: Colors.grey, // Black color for "No"
                                    fontSize: 40, // Large size for "No"
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "palatino",
                                  ),
                                ),
                                Text(
                                  'Option 2',
                                  style: TextStyle(
                                    decoration: TextDecoration
                                        .underline, // Underline the text
                                    decorationColor:
                                        Colors.black, // Color of the underline
                                    color: Colors.grey, // Color of the text
                                    fontSize: 20, // Font size
                                    fontStyle: FontStyle
                                        .italic, // Make the text italic
                                    decorationThickness:
                                        2.5, // Adjust the thickness of the underline (can create some space)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            !showStats
                ? const Text("")
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Forwarding(),
                          ),
                        );
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
                        'Skip',
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
      ),
    );
  }
}

// class CustomLoadingBar extends StatefulWidget {
//   final double progress;
//   final Duration delay; // New delay parameter

//   const CustomLoadingBar({
//     super.key,
//     required this.progress,
//     this.delay = const Duration(milliseconds: 500), // Default delay
//   });

//   @override
//   State<CustomLoadingBar> createState() => _CustomLoadingBarState();
// }

// class _CustomLoadingBarState extends State<CustomLoadingBar> {
//   double animatedProgress = 0.0;
//   bool isVisible = false; // To manage fade-in visibility

//   @override
//   void didUpdateWidget(covariant CustomLoadingBar oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Update the animated progress when the widget's progress changes
//     if (widget.progress != oldWidget.progress) {
//       setState(() {
//         animatedProgress = widget.progress;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Delay the fade-in and initialize progress
//     Future.delayed(widget.delay, () {
//       setState(() {
//         isVisible = true; // Start fade-in animation
//         animatedProgress = widget.progress;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     int progressPercentage = (animatedProgress * 100).toInt();
//     int remainingPercentage = 100 - progressPercentage;

//     return AnimatedOpacity(
//       opacity: isVisible ? 1.0 : 0.0,
//       duration: const Duration(milliseconds: 500), // Fade-in animation duration
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Stack(
//             children: [
//               // Background bar (inactive portion)
//               Container(
//                 width: 350, // Width of the loading bar
//                 height: 20, // Height of the loading bar
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300, // Grey background color
//                 ),
//               ),
//               // Progress bar (active portion)
//               AnimatedContainer(
//                 duration:
//                     const Duration(milliseconds: 1500), // Animation duration
//                 curve: Curves.easeInOut, // Smooth easing curve
//                 width: 350 * animatedProgress,
//                 height: 20,
//                 decoration: const BoxDecoration(
//                   color:
//                       Color.fromARGB(255, 13, 211, 19), // Green progress color
//                 ),
//                 child: Center(
//                   child: Text(
//                     '$progressPercentage%',
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//               // Remaining percentage text inside the grey bar
//               Positioned(
//                 left: 350 * animatedProgress,
//                 top: 0,
//                 child: Container(
//                   width: 350 * (1 - animatedProgress),
//                   height: 20,
//                   alignment: Alignment.center,
//                   child: Text(
//                     '$remainingPercentage%',
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MiniLoadingBar extends StatefulWidget {
//   final double progress; // Progress value between 0 and 1
//   final int delay;

//   const MiniLoadingBar({
//     super.key,
//     required this.progress,
//     required this.delay,
//   });

//   @override
//   State<MiniLoadingBar> createState() => _MiniLoadingBarState();
// }

// class _MiniLoadingBarState extends State<MiniLoadingBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _progressAnimation;

//   bool isVisible = false; // Tracks visibility of the loader

//   @override
//   void initState() {
//     super.initState();

//     // Initialize AnimationController for smooth progress animation
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2), // Smooth progress duration
//     );

//     // Define the progress animation
//     _progressAnimation =
//         Tween<double>(begin: 0.0, end: widget.progress).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut, // Smooth curve for progress animation
//     ));

//     // Delay visibility and start animations
//     Future.delayed(Duration(milliseconds: widget.delay), () {
//       if (mounted) {
//         setState(() {
//           isVisible = true; // Show the loader
//         });
//         _animationController.forward(); // Start the progress animation
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 300), // Smooth fade transition
//       child: isVisible
//           ? Stack(
//               children: [
//                 // Background bar (inactive portion)
//                 Container(
//                   width: 125,
//                   height: 20,
//                   color: Colors.grey.shade300,
//                 ),
//                 // Progress bar (active portion)
//                 AnimatedBuilder(
//                   animation: _progressAnimation,
//                   builder: (context, child) {
//                     double animatedProgress = _progressAnimation.value;
//                     int progressPercentage = (animatedProgress * 100).toInt();

//                     return Container(
//                       width: 125 * animatedProgress,
//                       height: 20,
//                       color: const Color.fromARGB(255, 13, 211, 19),
//                       alignment: Alignment.center,
//                       child: Text(
//                         '$progressPercentage%',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             )
//           : SizedBox(
//               width: 125, // Fixed width
//               height: 20, // Fixed height
//               child: Container(
//                 color: Colors.transparent, // Transparent placeholder
//               ),
//             ),
//     );
//   }
// }


class CustomLoadingBar extends StatefulWidget {
  final double progress;
  final Duration delay;

  const CustomLoadingBar({
    super.key,
    required this.progress,
    this.delay = const Duration(milliseconds: 1000),
  });

  @override
  State<CustomLoadingBar> createState() => _CustomLoadingBarState();
}

class _CustomLoadingBarState extends State<CustomLoadingBar>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _numberFadeController;
  late Animation<double> _numberFadeAnimation;
  
  double animatedProgress = 0.0;
  bool showNumbers = false; // To manage number fade-in

  @override
  void initState() {
    super.initState();

    // Fade-in animation for the progress bar
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    // Fade-in animation for the number (starts after progress animation)
    _numberFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _numberFadeAnimation = CurvedAnimation(
        parent: _numberFadeController, curve: Curves.easeInOut);

    // Start the progress bar fade-in first
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          animatedProgress = widget.progress;
        });
        _fadeController.forward().then((_) {
          // Once progress animation completes, start number fade-in
          setState(() {
            showNumbers = true;
          });
          _numberFadeController.forward();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomLoadingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      setState(() {
        animatedProgress = widget.progress;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _numberFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int progressPercentage = (animatedProgress * 100).toInt();
    int remainingPercentage = 100 - progressPercentage;

    return FadeTransition(
      opacity: _fadeAnimation, // Fade animation for the progress bar
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Background bar (inactive portion)
              Container(
                width: 350,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
              ),
              // Progress bar (active portion)
              AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                width: 350 * animatedProgress,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 13, 211, 19),
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _numberFadeAnimation, // Number fades in after progress
                    child: Text(
                      '$progressPercentage%',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              // Remaining percentage text inside the grey bar
              Positioned(
                left: 350 * animatedProgress,
                top: 0,
                child: Container(
                  width: 350 * (1 - animatedProgress),
                  height: 20,
                  alignment: Alignment.center,
                  child: FadeTransition(
                    opacity: _numberFadeAnimation, // Remaining number fades in
                    child: Text(
                      '$remainingPercentage%',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MiniLoadingBar extends StatefulWidget {
  final double progress; // Progress value between 0 and 1
  final int delay;
  final int myWidth;

  const MiniLoadingBar({
    super.key,
    required this.progress,
    required this.delay,
    this.myWidth = 125,
  });

  @override
  State<MiniLoadingBar> createState() => _MiniLoadingBarState();
}

class _MiniLoadingBarState extends State<MiniLoadingBar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool isVisible = false;
  bool showText = false;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.progress).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          isVisible = true;
        });
        _progressController.forward().then((_) {
          if (mounted) {
            setState(() {
              showText = true;
            });
            _fadeController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isVisible
          ? AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                double animatedProgress = _progressAnimation.value;
                int filledPercentage = (widget.progress * 100).toInt();
                int remainingPercentage = 100 - filledPercentage;

                return Stack(
                  children: [
                    // Background bar (inactive portion)
                    Container(
                      width: widget.myWidth.toDouble(),
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    // Progress bar (active portion)
                    Container(
                      width: widget.myWidth.toDouble() * animatedProgress,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 13, 211, 19),
                      ),
                    ),
                    // Text inside progress bar (filled)
                    Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: showText
                          ? FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                '$filledPercentage%',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                    // Text inside remaining bar (unfilled)
                    Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      child: showText
                          ? FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                '$remainingPercentage%',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                );
              },
            )
          : SizedBox(
              width: widget.myWidth.toDouble(),
              height: 20,
              child: Container(
                color: Colors.transparent,
              ),
            ),
    );
  }
}




// const Text(
//                                     'Stats',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 28,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Text(
//                                     'Yes: ${stats['yesCount'] ?? 0}',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                     ),
//                                   ),
//                                   Text(
//                                     'No: ${stats['noCount'] ?? 0}',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                     ),
//                                   ),