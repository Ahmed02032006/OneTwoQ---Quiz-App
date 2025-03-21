// import 'package:flutter/material.dart';
// import 'package:quiz_app/AnimationFormat/FadeAnimation.dart';
// import 'package:quiz_app/pages/questions.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class BasicInfo extends StatefulWidget {
//   const BasicInfo({super.key});

//   @override
//   _BasicInfoState createState() => _BasicInfoState();
// }

// class _BasicInfoState extends State<BasicInfo> {
//   String? selectedGender;
//   String? selectedCountry;
//   bool sameGenderName = false;
//   DateTime? selectedDate;

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 Image.asset(
//                   'assets/images/preloader.png',
//                   height: 100,
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(
//                           255, 13, 211, 19), // Updated color
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment
//                           .center, // Aligning the column content to the center
//                       children: [
//                         const Text(
//                           'Please enter your birth year:',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                           textAlign:
//                               TextAlign.center, // This will center the text
//                         ),
//                         const SizedBox(height: 10),
//                         InkWell(
//                           onTap: () => _selectDate(context),
//                           child: TextFormField(
//                             keyboardType: TextInputType.number,
//                             enabled: false,
//                             style: const TextStyle(color: Colors.white),
//                             controller: TextEditingController(
//                               text: selectedDate != null
//                                   ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
//                                   : '',
//                             ),
//                             decoration: const InputDecoration(
//                               border: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.white, // White underline border
//                                   style: BorderStyle.solid,
//                                   width: 2,
//                                 ),
//                               ),
//                               hintText: '',
//                               hintStyle: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // 1st Container for Text
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 40),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     margin: const EdgeInsets.only(
//                         bottom: 10), // Reduced bottom margin
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(
//                           255, 13, 211, 19), // Green background
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Text(
//                       'Please select your nationality, make sure to choose the country that best influences who you are as a person today',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(
//                   height: 10,
//                 ),

//                 CountryDropdown(),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(
//                           255, 13, 211, 19), // Updated color
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Text(
//                             'Please select your gender:',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20, // Font size for better visibility
//                             ),
//                           ),
//                           const SizedBox(height: 10),

//                           // Row for the labels (Male, Female, Non-Binary)
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Male',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16), // Adjusted font size
//                               ),
//                               SizedBox(
//                                 width: 40,
//                               ),
//                               Text(
//                                 'Female',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16), // Adjusted font size
//                               ),
//                               SizedBox(
//                                 width: 40,
//                               ),
//                               Text(
//                                 'Non-Binary',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16), // Adjusted font size
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                               height:
//                                   10), // Add space between checkboxes and labels
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Male Checkbox
//                               Transform.scale(
//                                 scale: 1.5, // Increase the size of the checkbox
//                                 child: Checkbox(
//                                   side: const BorderSide(
//                                     color: Colors.white,
//                                     width: 2,
//                                   ), // White border color
//                                   fillColor: WidgetStateProperty.all(
//                                     Colors.white,
//                                   ), // Background color when checked (optional)
//                                   checkColor: Colors.black,
//                                   value: selectedGender == 'male',
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       selectedGender = value!
//                                           ? 'male'
//                                           : ''; // Assign 'male' or empty
//                                     });
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 40,
//                               ),
//                               // Female Checkbox
//                               Transform.scale(
//                                 scale: 1.5, // Increase the size of the checkbox
//                                 child: Checkbox(
//                                   side: const BorderSide(
//                                     color: Colors.white,
//                                     width: 2,
//                                   ), // White border color
//                                   fillColor: WidgetStateProperty.all(
//                                     Colors.white,
//                                   ), // Background color when checked (optional)
//                                   checkColor: Colors.black,
//                                   value: selectedGender == 'female',
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       selectedGender = value!
//                                           ? 'female'
//                                           : ''; // Assign 'female' or empty
//                                     });
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 40,
//                               ),
//                               // Non-Binary Checkbox
//                               Transform.scale(
//                                 scale: 1.5, // Increase the size of the checkbox
//                                 child: Checkbox(
//                                   side: const BorderSide(
//                                     color: Colors.white,
//                                     width: 2,
//                                   ), // White border color
//                                   fillColor: WidgetStateProperty.all(
//                                     Colors.white,
//                                   ), // Background color when checked (optional)
//                                   checkColor: Colors.black,
//                                   value: selectedGender == 'non-binary',
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       selectedGender = value!
//                                           ? 'non-binary'
//                                           : ''; // Assign 'non-binary' or empty
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const Questions(),
//                   ),
//                 );
//                 // Navigator.push(
//                 //   context,
//                 //   FadePageRoute(page: const Questions()),
//                 // );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 minimumSize: const Size(double.infinity, 40),
//               ),
//               child: const Text(
//                 'Next',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CountryDropdown extends StatefulWidget {
//   @override
//   _CountryDropdownState createState() => _CountryDropdownState();
// }

// class _CountryDropdownState extends State<CountryDropdown> {
//   String? selectedCountry;
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

//         // Sort countries alphabetically by name
//         countries.sort((a, b) => a['name']!.compareTo(b['name']!));
//       });
//     } else {
//       throw Exception('Failed to load countries');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 70),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           color: Colors.grey, // Background color
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Center(
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.8, // 80% width
//             child: DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 enabledBorder:
//                     InputBorder.none, // Removing default border for consistency
//               ),
//               value: selectedCountry,
//               onChanged: (String? value) {
//                 setState(() {
//                   selectedCountry = value;
//                 });
//               },
//               hint: const Text(
//                 'Country Select',
//                 style: TextStyle(color: Colors.white), // White hint text
//               ),
//               items: countries
//                   .map<DropdownMenuItem<String>>((Map<String, String> country) {
//                 return DropdownMenuItem<String>(
//                   value: country['name'],
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width *
//                         0.5, // Constrain the width
//                     child: Row(
//                       children: [
//                         // Display flag or a placeholder if the URL is invalid
//                         country['flag'] != null && country['flag']!.isNotEmpty
//                             ? Image.network(
//                                 country['flag']!,
//                                 width: 24,
//                                 height: 16,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   // Fallback widget if the image fails to load
//                                   return Icon(Icons.flag,
//                                       size: 24, color: Colors.white);
//                                 },
//                               )
//                             : Icon(Icons.flag,
//                                 size: 24, color: Colors.white), // Placeholder
//                         const SizedBox(width: 10),
//                         Flexible(
//                           child: Text(
//                             country['name']!,
//                             style: const TextStyle(color: Colors.white),
//                             overflow: TextOverflow.ellipsis, // Handle overflow
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//               dropdownColor: Colors.grey, // Set dropdown background color
//               style: const TextStyle(
//                   color: Colors.white), // White text for the selected value
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quiz_app/pages/questions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  String? selectedGender;
  String? selectedCountry;
  DateTime? selectedDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGender = prefs.getString('gender');
      selectedCountry = prefs.getString('country');
      final savedDate = prefs.getString('birthDate');
      if (savedDate != null) {
        selectedDate = DateTime.parse(savedDate);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  int? calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      // Calculate age
      final age = calculateAge(selectedDate);

      // Save data
      await prefs.setString('gender', selectedGender!);
      await prefs.setString('country', selectedCountry!);
      await prefs.setInt('age', age ?? 0); // Save age, default to 0 if null

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Questions(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/preloader.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 13, 211, 19),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Please enter your birth year:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              enabled: false,
                              style: const TextStyle(color: Colors.white),
                              controller: TextEditingController(
                                text: selectedDate != null
                                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : '',
                              ),
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                ),
                                hintText: '',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (value) {
                                if (selectedDate == null) {
                                  return 'Please select your birth date';
                                }
                                final age = calculateAge(selectedDate);
                                if (age == null || age < 1) {
                                  return 'Please enter a valid birth date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 13, 211, 19),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Please select your nationality, make sure to choose the country that best influences who you are as a person today',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CountryDropdown(
                    onCountrySelected: (country) {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                    selectedCountry: selectedCountry,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 13, 211, 19),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Please select your gender:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Male',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(width: 40),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(width: 40),
                                Text(
                                  'Non-Binary',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    fillColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    checkColor: Colors.black,
                                    value: selectedGender == 'male',
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedGender = value! ? 'male' : '';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    fillColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    checkColor: Colors.black,
                                    value: selectedGender == 'female',
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedGender = value! ? 'female' : '';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    fillColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    checkColor: Colors.black,
                                    value: selectedGender == 'non-binary',
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedGender =
                                            value! ? 'non-binary' : '';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: _saveData,
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
                'Next',
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

class CountryDropdown extends StatefulWidget {
  final Function(String?) onCountrySelected;
  final String? selectedCountry;

  const CountryDropdown({
    required this.onCountrySelected,
    this.selectedCountry,
    Key? key,
  }) : super(key: key);

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: InputBorder.none,
              ),
              value: widget.selectedCountry,
              onChanged: widget.onCountrySelected,
              hint: const Text(
                'Country Select',
                style: TextStyle(color: Colors.white),
              ),
              items: countries
                  .map<DropdownMenuItem<String>>((Map<String, String> country) {
                return DropdownMenuItem<String>(
                  value: country['name'],
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      children: [
                        country['flag'] != null && country['flag']!.isNotEmpty
                            ? Image.network(
                                country['flag']!,
                                width: 24,
                                height: 16,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.flag,
                                      size: 24, color: Colors.white);
                                },
                              )
                            : Icon(Icons.flag, size: 24, color: Colors.white),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            country['name']!,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              dropdownColor: Colors.grey,
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your country';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
