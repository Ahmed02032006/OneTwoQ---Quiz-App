import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Controls extends StatefulWidget {
  const Controls({super.key});

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  bool isAppOnline = false;
  bool isStatsDisplayed = false;
  bool isButtonsDisplayed = false;

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
        });
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
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
        title: const Text("Controls", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 11, 79, 14),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color.fromARGB(255, 3, 159, 8),
        ),
      ),
    );
  }
}
