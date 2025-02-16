import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Controls extends StatefulWidget {
  const Controls({super.key});

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  // For User
  bool isAppOnline = false;
  bool isStatsDisplayed = false;
  bool isButtonsDisplayed = false;
  // For Admin
  bool isCommetsDisplayed = false;
  bool isQuestionsDisplayed = false;
  bool isSubCategoriesDisplayed = false;
  bool isCategoriesDisplayed = false;

  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String documentId = "2fbG1GP9nX7XJrgGaA6H";

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("Settings").doc(documentId).get();
      if (doc.exists) {
        setState(() {
          isAppOnline = doc["isAppOnline"] ?? false;
          isStatsDisplayed = doc["isStatsDisplayed"] ?? false;
          isButtonsDisplayed = doc["isButtonDisplayed"] ?? false;
          isCommetsDisplayed = doc["isCommetsDisplayed"] ?? false;
          isQuestionsDisplayed = doc["isQuestionsDisplayed"] ?? false;
          isSubCategoriesDisplayed = doc["isSubCategoriesDisplayed"] ?? false;
          isCategoriesDisplayed = doc["isCategoriesDisplayed"] ?? false;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
      setState(() {
        isLoading = false; // Even if error occurs, stop loading
      });
    }
  }

  Future<void> updateSetting(String field, bool value) async {
    try {
      await _firestore.collection("Settings").doc(documentId).update({
        field: value,
      });
    } catch (e) {
      debugPrint("Error updating $field: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Controls",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 11, 79, 14),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Color.fromARGB(255, 3, 159, 8),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "For User :",
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlTile(
                      title: "Is App Online",
                      value: isAppOnline,
                      onChanged: (val) {
                        setState(() => isAppOnline = val);
                        updateSetting("isAppOnline", val);
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildControlTile(
                      title: "Is Stats Displayed",
                      value: isStatsDisplayed,
                      onChanged: (val) {
                        setState(() => isStatsDisplayed = val);
                        updateSetting("isStatsDisplayed", val);
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildControlTile(
                      title: "Is Buttons Displayed",
                      value: isButtonsDisplayed,
                      onChanged: (val) {
                        setState(() => isButtonsDisplayed = val);
                        updateSetting("isButtonDisplayed", val);
                      },
                    ),
                    const SizedBox(height: 25),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "For Admin :",
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlTile(
                      title: "Is Comment Displayed",
                      value: isCommetsDisplayed,
                      onChanged: (val) {
                        setState(() => isCommetsDisplayed = val);
                        updateSetting("isCommetsDisplayed", val);
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildControlTile(
                      title: "Is Question Displayed",
                      value: isQuestionsDisplayed,
                      onChanged: (val) {
                        setState(() => isQuestionsDisplayed = val);
                        updateSetting("isQuestionsDisplayed", val);
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildControlTile(
                      title: "Is SubCategories Displayed",
                      value: isSubCategoriesDisplayed,
                      onChanged: (val) {
                        setState(() => isSubCategoriesDisplayed = val);
                        updateSetting("isSubCategoriesDisplayed", val);
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildControlTile(
                      title: "Is Categories Displayed",
                      value: isCategoriesDisplayed,
                      onChanged: (val) {
                        setState(() => isCategoriesDisplayed = val);
                        updateSetting("isCategoriesDisplayed", val);
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildControlTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            letterSpacing: 1.4,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color.fromARGB(255, 3, 159, 8),
        ),
      ),
    );
  }
}
