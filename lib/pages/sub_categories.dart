import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/AnimationFormat/FadeAnimation.dart';
import 'package:quiz_app/pages/specificCategoryQuestions.dart';

class SubCategories extends StatelessWidget {
  SubCategories({
    super.key,
    required this.selectedCategoryName,
    required this.selectedCategoryId,
  });

  final String selectedCategoryName;
  final String selectedCategoryId;

  Future<List<Map<String, dynamic>>> fetchSubcategories(
      String categoryId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('subcategories')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      // Include document ID in the returned list
      List<Map<String, dynamic>> subcategoriesList =
          querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return data;
      }).toList();

      return subcategoriesList;
    } catch (e) {
      print("Error fetching subcategories: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchSubcategories(selectedCategoryId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading subcategories"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No subcategories found",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  );
                }

                final subcategories = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Image.asset(
                              width: 120,
                              height: 120,
                              'assets/images/preloader.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            selectedCategoryName,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            "Slogan, different for each category",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subcategories.length,
                          itemBuilder: (context, index) {
                            final subcategory = subcategories[index];
                            final subcategoryId = subcategory['id'];
                            final subcategoryName =
                                subcategory['subcategory'] ?? 'Unnamed';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                color: index % 2 == 0
                                    ? const Color.fromARGB(255, 13, 211, 19)
                                    : Colors.grey.shade400,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Text(
                                      "${index + 1} -",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         SpecificCategoryQuestions(
                                        //       SelectedCategoryId: subcategoryId,
                                        //       SelectedCategoryName:selectedCategoryName,
                                        //       SelectSubCategoryName:subcategoryName,
                                        //     ),
                                        //   ),
                                        // );
                                        Navigator.push(
                                          context,
                                          FadePageRoute(
                                            page: SpecificCategoryQuestions(
                                              SelectedCategoryId: subcategoryId,
                                              SelectedCategoryName:
                                                  selectedCategoryName,
                                              SelectSubCategoryName:
                                                  subcategoryName,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        subcategoryName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
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
      ),
    );
  }
}
