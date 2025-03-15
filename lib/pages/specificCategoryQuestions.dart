import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/AnimationFormat/FadeAnimation.dart';
import 'package:quiz_app/Common/UserIdPreferences.dart';
import 'package:quiz_app/pages/categories.dart';
import 'package:quiz_app/pages/options.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecificCategoryQuestions extends StatefulWidget {
  SpecificCategoryQuestions({
    super.key,
    this.SelectedCategoryId,
    this.SelectedCategoryName,
    this.SelectSubCategoryName,
  });

  String? SelectedCategoryId;
  String? SelectedCategoryName;
  String? SelectSubCategoryName;

  @override
  _SpecificCategoryQuestionsState createState() =>
      _SpecificCategoryQuestionsState();
}

class _SpecificCategoryQuestionsState extends State<SpecificCategoryQuestions>
    with SingleTickerProviderStateMixin {
  String question = '';
  bool isLoading = true;
  bool showStats = false;
  Map<String, dynamic> stats = {};
  String currentCategoryId = '';
  String currentQuestionId = '';
  List<DocumentSnapshot> allQuestions = [];
  int currentQuestionIndex = 0;
  bool isBackButton = false;
  bool isNoQuestion = true;
  String totalLength = "";

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

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
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
      print("Error fetching settings: $e");
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

  void updateCurrentQuestion() {
    if (currentQuestionIndex < allQuestions.length) {
      DocumentSnapshot currentQuestion = allQuestions[currentQuestionIndex];
      setState(() {
        question = currentQuestion['question'];
        currentCategoryId = currentQuestion['categoryId'];
        currentQuestionId = currentQuestion.id;
      });
    } else {
      setState(() {
        question = 'All questions completed!';
      });
    }
  }

  Future<void> addCommentToFirebase(
    String username,
    String comment,
    String currentCategoryId,
    String currentQuestionId,
  ) async {
    try {
      // Reference to the Firestore collection "Comment"
      CollectionReference comments =
          FirebaseFirestore.instance.collection('Comment');

      // Add the comment data to Firestore
      await comments.add({
        'username': username,
        'comment': comment,
        'categoryId': currentCategoryId,
        'questionId': currentQuestionId,
        'UpOrDown': 1,
        'timestamp': FieldValue
            .serverTimestamp(), // optional, adds timestamp to the comment
      });

      print("Comment added successfully!");
    } catch (e) {
      print("Error adding comment: $e");
    }
  }

  Future<void> fetchQuestion() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch all questions for the selected subcategory
      QuerySnapshot questionsSnapshot = await FirebaseFirestore.instance
          .collection('questions')
          .where("subcategoryId", isEqualTo: widget.SelectedCategoryId)
          .get();

      List<DocumentSnapshot> questionDocs = questionsSnapshot.docs;

      if (questionDocs.isEmpty) {
        setState(() {
          question = 'No questions found for this subcategory';
          isLoading = false;
        });
        return;
      }

      // Manual filtering and sorting logic using loops
      List<DocumentSnapshot> sortedQuestions = [];

      for (var doc in questionDocs) {
        // Safely cast doc data to Map<String, dynamic>
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        // Ensure that the document has the 'sortOrder' field
        if (data != null && data.containsKey('sortOrder')) {
          sortedQuestions.add(doc);
        }
      }

      // Sort the filtered questions in ascending order based on 'sortOrder'
      for (int i = 0; i < sortedQuestions.length - 1; i++) {
        for (int j = i + 1; j < sortedQuestions.length; j++) {
          int sortOrderI = sortedQuestions[i].get('sortOrder');
          int sortOrderJ = sortedQuestions[j].get('sortOrder');

          if (sortOrderI > sortOrderJ) {
            // Swap elements
            var temp = sortedQuestions[i];
            sortedQuestions[i] = sortedQuestions[j];
            sortedQuestions[j] = temp;
          }
        }
      }

      // Log all sorted questions
      for (var doc in sortedQuestions) {
        print(
            "Sorted Question: ${doc.get('question')} with SortOrder: ${doc.get('sortOrder')}");
        currentCategoryId = doc.get('categoryId');
      }

      totalLength = sortedQuestions.length.toString();

      setState(() {
        allQuestions = sortedQuestions;
        currentQuestionIndex = 0;
        question = allQuestions[currentQuestionIndex].get('question');
        currentQuestionId = allQuestions[currentQuestionIndex].id;
        isLoading = false;
        isNoQuestion = false;
      });
    } catch (e) {
      print('Error fetching question: $e');
      setState(() {
        question = 'Error fetching question';
        isLoading = false;
      });
    }
  }

  void nextQuestion() {
    showStats = false;
    isLoading = true;
    updateProgressValues();
    setState(() {
      isAnimationLoading = !isAnimationLoading; // Toggle the loading state
    });
    _controller.reset();
    _controller.forward();

    // Add a 2-second delay using Future.delayed
    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
    setState(() {});
    if (currentQuestionIndex < allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++; // Increment the question index
        question = allQuestions[currentQuestionIndex].get('question');
        print("Next Question Index: $currentQuestionIndex");
        print(
            "Next Question: ${allQuestions[currentQuestionIndex].get('question')}");
      });
    } else {
      setState(() {
        question = 'You have reached the end of the questions!';
        isBackButton = true; // Show "Back" button at the end
      });
      print("Reached the end of questions");
    }
    ;
  }

  void goBack() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--; // Decrement the question index
        question = allQuestions[currentQuestionIndex].get('question');
        print("Previous Question Index: $currentQuestionIndex");
        print(
            "Previous Question: ${allQuestions[currentQuestionIndex].get('question')}");
      });
    } else {
      print("No previous question available");
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  List<TextSpan> _parseStyledText(String text) {
    // Regex to match ** for bold, __ for underline, and // for italic
    final regex = RegExp(r'(\*\*)|(__)|(\/\/)');

    final List<TextSpan> spans = [];
    int currentIndex = 0;

    // Track active styles
    bool isBold = false;
    bool isUnderline = false;
    bool isItalic = false;

    // Helper function to add styled text
    void addStyledText(String text, TextStyle style) {
      if (spans.isNotEmpty && spans.last is TextSpan) {
        final lastSpan = spans.last as TextSpan;
        if (lastSpan.style == style) {
          // Merge with the previous span if the style is the same
          spans[spans.length - 1] = TextSpan(
            text: '${lastSpan.text}$text',
            style: style,
          );
          return;
        }
      }
      spans.add(TextSpan(text: text, style: style));
    }

    // Iterate through all matches of the regex
    for (final match in regex.allMatches(text)) {
      // Add normal text before any matched styled text
      if (match.start > currentIndex) {
        final normalText = text.substring(currentIndex, match.start);
        TextStyle? currentStyle;
        if (isBold) {
          currentStyle = (currentStyle ?? const TextStyle())
              .copyWith(fontWeight: FontWeight.bold);
        }
        if (isUnderline) {
          currentStyle = (currentStyle ?? const TextStyle())
              .copyWith(decoration: TextDecoration.underline);
        }
        if (isItalic) {
          currentStyle = (currentStyle ?? const TextStyle())
              .copyWith(fontStyle: FontStyle.italic);
        }
        addStyledText(normalText, currentStyle ?? const TextStyle());
      }

      // Toggle styles based on the matched marker
      if (match.group(1) != null) {
        // Toggle bold
        isBold = !isBold;
      } else if (match.group(2) != null) {
        // Toggle underline
        isUnderline = !isUnderline;
      } else if (match.group(3) != null) {
        // Toggle italic
        isItalic = !isItalic;
      }

      currentIndex = match.end;
    }

    // Add remaining normal text
    if (currentIndex < text.length) {
      final remainingText = text.substring(currentIndex);
      TextStyle? currentStyle;
      if (isBold) {
        currentStyle = (currentStyle ?? const TextStyle())
            .copyWith(fontWeight: FontWeight.bold);
      }
      if (isUnderline) {
        currentStyle = (currentStyle ?? const TextStyle())
            .copyWith(decoration: TextDecoration.underline);
      }
      if (isItalic) {
        currentStyle = (currentStyle ?? const TextStyle())
            .copyWith(fontStyle: FontStyle.italic);
      }
      addStyledText(remainingText, currentStyle ?? const TextStyle());
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
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const Options(),
                                //   ),
                                // );
                                Navigator.push(
                                  context,
                                  FadePageRoute(page: const Options()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 13, 211, 19),
                                ),
                                // color: const Color.fromARGB(255, 13, 211, 19),
                                child: const Icon(
                                  Icons.home_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Share.share(
                                  question,
                                );
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
                          ],
                        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(widget.SelectedCategoryName.toString()),
                        Text(widget.SelectSubCategoryName.toString()),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          (currentQuestionIndex + 1).toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Transform.rotate(
                          angle: 2.6,
                          child: Container(
                            width: 35,
                            height: 3,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          totalLength,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Container(
                      width: 100,
                      height: showStats == true ? 70 : 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 13, 211, 19),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : showStats
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                : isLoading
                                    ? const CircularProgressIndicator.adaptive()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children:
                                                _parseStyledText(question),
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
                const SizedBox(
                  height: 10,
                ),
                if (isStatsDisplayed)
                  if (showStats)
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.5, // Adjust height relative to screen size
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
                  isBackButton
                      ? Container(
                          height: 50,
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly, // Distribute buttons evenly
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : isNoQuestion
                          ? Container(
                              height: 50,
                              color: Colors.grey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // Distribute buttons evenly
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // await updateStats(true);
                                        // fetchAndShowStats();
                                        setState(() {
                                          showStats = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor:
                                            Colors.white, // White background
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 13, 211, 19),
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
                                                color: Colors
                                                    .grey, // Black color for "Yes"
                                                fontSize:
                                                    40, // Large size for "Yes"
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "palatino"),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // await updateStats(false);
                                        // fetchAndShowStats();
                                        setState(() {
                                          showStats = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor:
                                            Colors.white, // White background
                                        side: const BorderSide(
                                            color: Colors.grey,
                                            width: 6), // Green border
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
                                                color: Colors
                                                    .grey, // Black color for "No"
                                                fontSize:
                                                    40, // Large size for "No"
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "palatino"),
                                          ),
                                          Text(
                                            'Option 2',
                                            style: TextStyle(
                                              decoration: TextDecoration
                                                  .underline, // Underline the text
                                              decorationColor: Colors
                                                  .grey, // Color of the underline
                                              color: Colors
                                                  .grey, // Color of the text
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
                            )
              ],
            ),
            // ==================================
            !showStats
                ? const Text("")
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      color: Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Distribute buttons evenly
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return CommentBox(
                                    currentQuestionId: currentQuestionId,
                                    currentCategoryId: currentCategoryId,
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Comment',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Categories(),
                                ),
                              );
                            },
                            child: const Text(
                              'Go To Categories',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: isBackButton
                                ? () {
                                    Navigator.pop(context);
                                  }
                                : nextQuestion, // Handle Next or Back
                            child: Text(
                              isBackButton
                                  ? 'Back'
                                  : 'Next', // Display appropriate text
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
                                : Colors.transparent,
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
    required this.countryName, // Add country name parameter
  });

  @override
  State<SelectedCountryStats> createState() => _SelectedCountryStatsState();
}

class _SelectedCountryStatsState extends State<SelectedCountryStats> {
  late final double
      progressing; // Store the random progress value when widget is created

  @override
  void initState() {
    super.initState();
    // Generate random progress once when widget is created
    Random random = Random();
    progressing = 0.1 +
        random.nextDouble() * 0.4; // Generates a value between 0.1 and 0.7
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

class CommentsList extends StatelessWidget {
  const CommentsList({
    super.key,
    required this.ComentListCurrentQuestionId,
  });

  final String ComentListCurrentQuestionId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Comments')
          .where('questionId', isEqualTo: ComentListCurrentQuestionId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching comments'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No comments available'));
        }

        final comments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final commentData = comments[index];
            final comment = commentData['comment'] ?? 'No comment';
            final username = commentData['username'] ?? 'Anonymous';
            final commentId = commentData.id;
            final updown = commentData['UpOrDown'] ?? 0;

            return CommentItem(
              commentId: commentId,
              initialVoteCount: updown,
              name: username,
              comment: comment,
            );
          },
        );
      },
    );
  }
}

void showCustomSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final snackBar = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // Position from the top
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  // Insert the overlay
  overlay.insert(snackBar);

  // Remove the snackBar after a delay
  Future.delayed(const Duration(seconds: 2), () {
    snackBar.remove();
  });
}

class CommentItem extends StatefulWidget {
  final String name;
  final String comment;
  final String commentId; // Add commentId to identify the specific comment
  final int initialVoteCount; // Get initial vote count from Firestore

  const CommentItem({
    Key? key,
    required this.name,
    required this.comment,
    required this.commentId,
    required this.initialVoteCount,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isUpvoted = false;
  bool isDownvoted = false;
  int voteCount = 0;

  @override
  void initState() {
    super.initState();
    voteCount = widget.initialVoteCount;
    print(widget.name);
    print(widget.comment);
    print(widget.commentId);
    print(widget.initialVoteCount);
  }

  // Future<void> handleVote(bool isUpvote) async {
  //   final userId = "currentUserId"; // Replace with the logged-in user's ID
  //   final commentRef =
  //       FirebaseFirestore.instance.collection('Comments').doc(widget.commentId);

  //   final snapshot = await commentRef.get();

  //   if (!snapshot.exists) {
  //     // Handle error if comment doesn't exist
  //     return;
  //   }

  //   final data = snapshot.data() as Map<String, dynamic>;
  //   final votedBy = List<String>.from(data['votedBy'] ?? []);

  //   if (votedBy.contains(userId)) {
  //     // User has already voted
  //     showCustomSnackBar(context, "You can only vote once.");
  //     return;
  //   }

  //   // Update vote count and Firestore
  //   setState(() {
  //     if (isUpvote) {
  //       voteCount++;
  //       isUpvoted = true;
  //       isDownvoted = false;
  //     } else {
  //       voteCount--;
  //       isUpvoted = false;
  //       isDownvoted = true;
  //     }
  //   });

  //   await commentRef.update({
  //     'UpOrDown': FieldValue.increment(isUpvote ? 1 : -1),
  //     'votedBy': FieldValue.arrayUnion([userId]),
  //   });
  // }

  Future<void> handleVote(bool isUpvote) async {
    final userId = await getUserId(); // Persistent user ID
    final commentRef =
        FirebaseFirestore.instance.collection('Comments').doc(widget.commentId);

    final snapshot = await commentRef.get();

    if (!snapshot.exists) {
      // Handle error if comment doesn't exist
      return;
    }

    final data = snapshot.data() as Map<String, dynamic>;
    final votedBy = List<String>.from(data['votedBy'] ?? []);

    if (votedBy.contains(userId)) {
      // User has already voted
      showCustomSnackBar(context, "You can only vote once.");
      return;
    }

    // Update vote count and Firestore
    setState(() {
      if (isUpvote) {
        voteCount++;
        isUpvoted = true;
        isDownvoted = false;
      } else {
        voteCount--;
        isUpvoted = false;
        isDownvoted = true;
      }
    });

    await commentRef.update({
      'UpOrDown': FieldValue.increment(isUpvote ? 1 : -1),
      'votedBy': FieldValue.arrayUnion([userId]), // Add userId to votedBy
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              widget.name[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(widget.comment),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => handleVote(true),
                icon: Icon(
                  isUpvoted
                      ? Icons.arrow_circle_up
                      : Icons.arrow_circle_up_outlined,
                ),
                color: Colors.green,
                iconSize: 33,
              ),
              const SizedBox(height: 8),
              Text(voteCount.toString()), // Display the vote count
              IconButton(
                onPressed: () => handleVote(false),
                icon: Icon(
                  isDownvoted
                      ? Icons.arrow_circle_down
                      : Icons.arrow_circle_down_outlined,
                ),
                color: Colors.red,
                iconSize: 33,
              ),
            ],
          ),
        ],
      ),
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

void _showCommentDialog(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController commentController,
  String question,
  String currentCategoryId,
  String currentQuestionId,
) async {
  // Fetch the saved username from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedUsername = prefs.getString('username');
  if (savedUsername != null) {
    usernameController.text = savedUsername;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Rounded corners for the dialog
        ),
        title: const Text(
          'Leave a Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              // Username TextField
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 15),
              // Comment TextField
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          // Submit Button
          ElevatedButton(
            onPressed: () async {
              try {
                // Save the username to shared preferences
                await prefs.setString('username', usernameController.text);

                // Uncomment the following lines to save the comment to a database
                CollectionReference comments =
                    FirebaseFirestore.instance.collection('Comments');

                await comments.add({
                  'username': usernameController.text,
                  'comment': commentController.text,
                  'categoryId': currentCategoryId,
                  'questionId': currentQuestionId,
                  'UpOrDown': 1,
                  'timestamp':
                      FieldValue.serverTimestamp(), // optional, adds timestamp
                });

                print("Comment added successfully!");
              } catch (e) {
                print("Error adding comment: $e");
              }

              usernameController.clear();
              commentController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

class CommentBox extends StatelessWidget {
  const CommentBox({
    super.key,
    required this.currentQuestionId,
    required this.currentCategoryId,
  });

  final String currentQuestionId;
  final String currentCategoryId;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Comment Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                CommentInput(
                  currentCategoryId: currentCategoryId,
                  currentQuestionId: currentQuestionId,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // Comments List
            Expanded(
              child: CommentsList(
                ComentListCurrentQuestionId: currentQuestionId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentInput extends StatefulWidget {
  final String currentCategoryId;
  final String currentQuestionId;

  const CommentInput({
    required this.currentCategoryId,
    required this.currentQuestionId,
    super.key,
  });

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? _savedUsername;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUsername = prefs.getString('username');
    });
    if (_savedUsername != null) {
      _usernameController.text = _savedUsername!;
    }
  }

  Future<void> _submitComment() async {
    final username = _usernameController.text.trim();
    final comment = _commentController.text.trim();

    if (username.isEmpty) {
      showCustomSnackBar(context, "Username is required.");
      return;
    }
    if (comment.isEmpty) {
      showCustomSnackBar(context, "Comment cannot be empty.");
      return;
    }

    try {
      // Save or update username in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      // Submit comment to Firestore
      await FirebaseFirestore.instance.collection('Comments').add({
        'username': username,
        'comment': comment,
        'categoryId': widget.currentCategoryId,
        'questionId': widget.currentQuestionId,
        'UpOrDown': 0,
        'timestamp': FieldValue.serverTimestamp(),
        'votedBy': [],
      });

      // Clear comment field
      _commentController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      showCustomSnackBar(context, "Error submitting comment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username Field (only if not saved)
        if (_savedUsername == null)
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: const Icon(Icons.person,
                  color: Color.fromARGB(255, 13, 211, 19)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        if (_savedUsername == null) const SizedBox(height: 16),

        // Comment Field and Submit Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Write a comment...',
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                  minLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 13, 211, 19),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onPressed: _submitComment,
                child: const Icon(Icons.send, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
