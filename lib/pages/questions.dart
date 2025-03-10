import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quiz_app/AnimationFormat/FadeAnimation.dart';
import 'package:quiz_app/pages/forwarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

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

  int? selectedIndex;

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 1), // Show for 1 second
        content: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 13, 211, 19), // Border color
                width: 5, // Border width
              ),
            ),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center, // Center the text
            style: const TextStyle(
              color: Color.fromARGB(255, 13, 211, 19), // Text color
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
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
                        height: showStats == true ? 100 : 100,
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
                                  color: Colors.white,
                                )
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
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : const SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        "Most questions are answered in a simple yes or no format. Please select Yes or No.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 35),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("YES or "),
                                          Text(
                                            "option 1",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Row(
                                        children: [
                                          Text("NO or "),
                                          Text(
                                            "option 2",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                              decorationThickness: 3,
                                              decorationColor: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
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
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = 0;
                                              });
                                              _showSnackbar(context,
                                                  "Your Feedback Submitted!");
                                            },
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
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: selectedIndex == 0
                                                      ? 6
                                                      : 4, // Increase border width on selection
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
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = 1;
                                              });
                                              _showSnackbar(
                                                context,
                                                "Your Feedback Submitted!",
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: selectedIndex == 1
                                                      ? 6
                                                      : 4, // Increase border width on selection
                                                  color: Colors.grey,
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
                                      delay: const Duration(milliseconds: 2500),
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
                                                      delay: 4000,
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
                                                      delay: 5000,
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
                                                      delay: 6000,
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
                                                      delay: 7000,
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
                                                      delay: 8000,
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
                                                      delay: 9000,
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
                                                      delay: 10000,
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
                                                      delay: 11000,
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
                                                      delay: 12000,
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
                                    ByDefaultCountries(
                                      cp1: c1Progress,
                                      cp2: c2Progress,
                                      cp3: c3Progress,
                                      cp4: c4Progress,
                                      cp5: c5Progress,
                                      cp6: c6Progress,
                                    ),
                                    const CountryDropdown(),
                                    const SizedBox(height: 5),
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
                                        Colors.grey, // Color of the underline
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const Forwarding(),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          FadePageRoute(page: const Forwarding()),
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

class CountryDropdown extends StatefulWidget {
  const CountryDropdown({super.key});

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  List<Map<String, String>> selectedCountries = [];
  List<Map<String, String>> countries = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final response = await http
        .get(Uri.parse('https://restcountries.com/v3.1/all?fields=name,flags'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        countries = data.map((country) {
          return {
            'name': country['name']['common'].toString(),
            'flag': country['flags']['png'].toString(),
          };
        }).toList();

        countries.sort((a, b) => a['name']!.compareTo(b['name']!));
      });
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Map<String, String>? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      alignLabelWithHint: false,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    ),
                  ),
                  child: DropdownButtonFormField<Map<String, String>>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    ),
                    isExpanded: true,
                    value: selectedCountry, // Set selected value here
                    onChanged: (Map<String, String>? value) {
                      if (value != null) {
                        setState(() {
                          selectedCountry = value; // Update selected country
                          if (selectedCountries.any(
                              (country) => country['name'] == value['name'])) {
                            selectedCountries
                                .removeWhere((c) => c['name'] == value['name']);
                          } else {
                            selectedCountries
                                .add(Map<String, String>.from(value));
                          }
                        });
                      }
                    },
                    hint: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Select Country',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    items: countries.map<DropdownMenuItem<Map<String, String>>>(
                      (Map<String, String> country) {
                        final isSelected = selectedCountries
                            .any((c) => c['name'] == country['name']);
                        return DropdownMenuItem<Map<String, String>>(
                          value: country,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            width: double.infinity, // Ensures full width
                            color: isSelected
                                ? const Color.fromARGB(255, 13, 211, 19)
                                : Colors
                                    .transparent,
                            child: Text(
                              country['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    dropdownColor: Colors.grey.shade500,
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.white, size: 20),
                    menuMaxHeight: 300,
                    alignment: Alignment.centerLeft,
                    // Fix the selectedItemBuilder
                    selectedItemBuilder: (BuildContext context) {
                      return countries
                          .map<Widget>((Map<String, String> country) {
                        // Only show text for the currently selected country
                        if (selectedCountry != null &&
                            selectedCountry!['name'] == country['name']) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              country['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                        // Return an empty container for non-selected countries
                        return Container();
                      }).toList();
                    },
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          if (selectedCountries.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: selectedCountries.length,
                itemBuilder: (context, index) {
                  final country = selectedCountries[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, left: 0),
                    child: SelectedCountryStats(
                      flagUrl: country['flag']!,
                      countryName: country['name']!,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class SelectedCountryStats extends StatefulWidget {
  final String flagUrl;
  final String countryName;

  const SelectedCountryStats({
    super.key,
    required this.flagUrl,
    required this.countryName,
  });

  @override
  State<SelectedCountryStats> createState() => _SelectedCountryStatsState();
}

class _SelectedCountryStatsState extends State<SelectedCountryStats> {
  late final double progressing;

  @override
  void initState() {
    super.initState();
    Random random = Random();
    progressing = 0.1 + random.nextDouble() * 0.4;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 270,
            child: CustomLoadingBar(
              progress: progressing,
              delay: const Duration(milliseconds: 50),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 35,
            height: 20,
            child: Image.network(
              widget.flagUrl,
              width: 24,
              height: 16,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.flag, size: 24, color: Colors.white);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class CountryDropdown extends StatefulWidget {
//   const CountryDropdown({super.key});

//   @override
//   _CountryDropdownState createState() => _CountryDropdownState();
// }

// class _CountryDropdownState extends State<CountryDropdown> {
//   List<Map<String, String>> selectedCountries = []; // Store all selected countries
//   List<Map<String, String>> countries = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchCountries();
//   }

//   Future<void> fetchCountries() async {
//     final response = await http
//         .get(Uri.parse('https://restcountries.com/v3.1/all?fields=name,flags'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         countries = data.map((country) {
//           return {
//             'name': country['name']['common'].toString(),
//             'flag': country['flags']['png'].toString(),
//           };
//         }).toList();

//         // Sort countries alphabetically
//         countries.sort((a, b) => a['name']!.compareTo(b['name']!));
//       });
//     } else {
//       throw Exception('Failed to load countries');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Use Row to force dropdown to start from left
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 child: Theme(
//                   // Apply a theme override to force left alignment
//                   data: Theme.of(context).copyWith(
//                     inputDecorationTheme: const InputDecorationTheme(
//                       alignLabelWithHint: false,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
//                     ),
//                   ),
//                   child: DropdownButtonFormField<Map<String, String>>(
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       filled: true,
//                       fillColor: Colors.grey,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
//                     ),
//                     isExpanded: true,
//                     value: null,
//                     onChanged: (Map<String, String>? value) {
//                       if (value != null &&
//                           !selectedCountries.any((country) => country['name'] == value['name'])) {
//                         setState(() {
//                           selectedCountries.add(Map<String, String>.from(value));
//                         });
//                       }
//                     },
//                     hint: Container(
//                       alignment: Alignment.centerLeft,
//                       child: const Text(
//                         'Select Country',
//                         style: TextStyle(color: Colors.white, fontSize: 14),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     items: countries.map<DropdownMenuItem<Map<String, String>>>(
//                       (Map<String, String> country) {
//                         return DropdownMenuItem<Map<String, String>>(
//                           value: country,
//                           alignment: Alignment.centerLeft,
//                           child: Container(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               country['name']!,
//                               style: const TextStyle(color: Colors.white, fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                         );
//                       },
//                     ).toList(),
//                     dropdownColor: Colors.grey,
//                     style: const TextStyle(color: Colors.white),
//                     icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
//                     menuMaxHeight: 300,
//                     alignment: Alignment.centerLeft,
//                   ),
//                 ),
//               ),
//               // Use Spacer to push dropdown to the left
//               const Spacer(),
//             ],
//           ),

//           const SizedBox(height: 10),

//           if (selectedCountries.isNotEmpty)
//             SizedBox(
//               height: 200,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 itemCount: selectedCountries.length,
//                 itemBuilder: (context, index) {
//                   final country = selectedCountries[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8, left: 0),
//                     child: SelectedCountryStats(
//                       flagUrl: country['flag']!,
//                       countryName: country['name']!,
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class SelectedCountryStats extends StatefulWidget {
//   final String flagUrl;
//   final String countryName;

//   const SelectedCountryStats({
//     super.key,
//     required this.flagUrl,
//     required this.countryName, // Add country name parameter
//   });

//   @override
//   State<SelectedCountryStats> createState() => _SelectedCountryStatsState();
// }

// class _SelectedCountryStatsState extends State<SelectedCountryStats> {
//   late final double
//       progressing; // Store the random progress value when widget is created

//   @override
//   void initState() {
//     super.initState();
//     // Generate random progress once when widget is created
//     Random random = Random();
//     progressing = 0.1 +
//         random.nextDouble() * 0.4; // Generates a value between 0.1 and 0.7
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 270,
//             child: CustomLoadingBar(
//               progress: progressing,
//               delay: const Duration(milliseconds: 50),
//             ),
//           ),
//           const SizedBox(width: 10),
//           SizedBox(
//             width: 35,
//             height: 20,
//             child: Image.network(
//               widget.flagUrl,
//               width: 24,
//               height: 16,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.flag, size: 24, color: Colors.white);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ByDefaultCountries extends StatelessWidget {
  final double cp1;
  final double cp2;
  final double cp3;
  final double cp4;
  final double cp5;
  final double cp6;

  const ByDefaultCountries(
      {super.key,
      required this.cp1,
      required this.cp2,
      required this.cp3,
      required this.cp4,
      required this.cp5,
      required this.cp6});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              children: [
                MiniLoadingBar(
                  progress: cp1,
                  delay: 13000,
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
                  progress: cp2,
                  delay: 14000,
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
                  progress: cp3,
                  delay: 15000,
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
          width: 15,
        ),
        Column(
          children: [
            Row(
              children: [
                MiniLoadingBar(
                  progress: cp4,
                  delay: 16000,
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
                  progress: cp5,
                  delay: 17000,
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
                  progress: cp6,
                  delay: 18000,
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
    );
  }
}

class CustomLoadingBar extends StatefulWidget {
  final double progress;
  final Duration delay;

  const CustomLoadingBar({
    super.key,
    required this.progress,
    this.delay = const Duration(milliseconds: 1500), // Slower start delay
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
  bool showNumbers = false;

  @override
  void initState() {
    super.initState();

    // Slower fade-in animation for the progress bar
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    // Slower fade-in animation for the number
    _numberFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _numberFadeAnimation =
        CurvedAnimation(parent: _numberFadeController, curve: Curves.easeInOut);

    // Start the progress bar fade-in after the delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          animatedProgress = widget.progress;
        });
        _fadeController.forward().then((_) {
          // Start number fade-in after progress animation
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
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Background bar
              Container(
                width: 350,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
              ),
              // Slower progress bar animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.easeInOut,
                width: 350 * animatedProgress,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 13, 211, 19),
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _numberFadeAnimation,
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
              // Remaining percentage
              Positioned(
                left: 350 * animatedProgress,
                top: 0,
                child: Container(
                  width: 350 * (1 - animatedProgress),
                  height: 20,
                  alignment: Alignment.center,
                  child: FadeTransition(
                    opacity: _numberFadeAnimation,
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

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
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
