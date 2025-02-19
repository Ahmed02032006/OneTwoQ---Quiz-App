import 'package:flutter/material.dart';
import 'package:quiz_app/pages/options.dart';
import 'package:quiz_app/pages/sub_categories.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  final List<Map<String, String>> imageData = const [
    {
      "imagePath": "assets/icons/Icon1SideA.png",
      "categoryNAME": "Animal",
      "categoryID": "qiX4orh1CUlLYnwPrL7t"
    },
    {
      "imagePath": "assets/icons/Icon2SideA.png",
      "categoryNAME": "Automotive",
      "categoryID": "vUSZwE5IBdV7LXTBI6R2"
    },
    {
      "imagePath": "assets/icons/Icon3SideA.png",
      "categoryNAME": "Entertainment",
      "categoryID": "OEi6NoO64UHgMXmhrySO"
    },
    {
      "imagePath": "assets/icons/Icon5SideA.png",
      "categoryNAME": "Food",
      "categoryID": "yWPR43dxo6O5M48AD7Mp"
    },
    {
      "imagePath": "assets/icons/Icon4SideA.png",
      "categoryNAME": "Fun",
      "categoryID": "LKPLh8TziRVuEpDvlFZs"
    },
    {
      "imagePath": "assets/icons/Icon9SideA.png",
      "categoryNAME": "Health",
      "categoryID": "fGL4TdrmKC6RGYiCiElj"
    },
    {
      "imagePath": "assets/icons/Icon8SideA.png",
      "categoryNAME": "History",
      "categoryID": "6LQxrGbjSHvvnCEXOiLK"
    },
    {
      "imagePath": "assets/icons/Icon12SideA.png",
      "categoryNAME": "Hypothetical",
      "categoryID": "6RwQD1LVJgm3QNsZi8m1",
    },
    {
      "imagePath": "assets/icons/Icon10SideA.png",
      "categoryNAME": "In the Moment",
      "categoryID": "VDkm84EGFi68nYXDktoC"
    },
    {
      "imagePath": "assets/icons/Icon14SideA.png",
      "categoryNAME": "Life",
      "categoryID": "WdHxSAsc3Sip48HBpd8f"
    },
    {
      "imagePath": "assets/icons/Icon11SideA.png",
      "categoryNAME": "Music",
      "categoryID": "N2x9mJqdGTShua64osLf"
    },
    {
      "imagePath": "assets/icons/Icon17SideA.png",
      "categoryNAME": "Nature",
      "categoryID": "VDkm84EGFi68nYXDktoC"
    },
    {
      "imagePath": "assets/icons/Icon13SideA.png",
      "categoryNAME": "Random",
      "categoryID": "zFH4NWj1xoIwrQRFyPvj"
    },
    {
      "imagePath": "assets/icons/Icon19SideA.png",
      "categoryNAME": "Science",
      "categoryID": "w9w1TGH0CSbYbp83aO20"
    },
    {
      "imagePath": "assets/icons/Icon15SideA.png",
      "categoryNAME": "Space",
      "categoryID": "DexR5qQrY6niZssl9aJL"
    },
    {
      "imagePath": "assets/icons/Icon6SideA.png",
      "categoryNAME": "Sport",
      "categoryID": "xaqvzbd5oaRj7asdQUFy"
    },
    {
      "imagePath": "assets/icons/Icon16SideA.png",
      "categoryNAME": "Technology",
      "categoryID": "UnYaEBouegz2wIUqbGUp"
    },
    {
      "imagePath": "assets/icons/Icon7SideA.png",
      "categoryNAME": "Travel",
      "categoryID": "AxAvElBNcpynDEtFMo6P"
    },
    {
      "imagePath": "assets/icons/Icon18SideA.png",
      "categoryNAME": "Work",
      "categoryID": "VmQo9nmHfDA1uXfSWS3r"
    },
    {
      "imagePath": "assets/icons/Icon20SideA.png",
      "categoryNAME": "One Two Q",
      "categoryID": "vTYCgTVtqxjJxcErFvjV"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200
        ? 5
        : screenWidth > 800
            ? 4
            : screenWidth > 600
                ? 3
                : 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/preloader.png',
                    height: screenWidth > 600 ? 150 : 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: imageData.length,
                      itemBuilder: (context, index) {
                        final imagePath = imageData[index]['imagePath']!;
                        final categoryNames = imageData[index]['categoryNAME']!;
                        final categoryId = imageData[index]['categoryID']!;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubCategories(
                                  selectedCategoryName: categoryNames,
                                  selectedCategoryId: categoryId,
                                ),
                              ),
                            );
                          },
                          child: Tooltip(
                            message: categoryNames,
                            child: SizedBox(
                              width: screenWidth > 600 ? 180 : 150,
                              height: screenWidth > 600 ? 180 : 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    imagePath,
                                    width: screenWidth > 600 ? 150 : 130,
                                    height: screenWidth > 600 ? 150 : 130,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8),
                                  // Text(
                                  //   categoryNames,
                                  //   style: TextStyle(
                                  //     fontSize: screenWidth > 600 ? 16 : 14,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  //   textAlign: TextAlign.center,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Options(),
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
