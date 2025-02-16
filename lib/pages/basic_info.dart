import 'package:flutter/material.dart';
import 'package:quiz_app/pages/questions.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  String? selectedGender;
  String? selectedCountry;
  bool sameGenderName = false;
  DateTime? selectedDate;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                      color: const Color.fromARGB(
                          255, 13, 211, 19), // Updated color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Aligning the column content to the center
                      children: [
                        const Text(
                          'Please enter your birth year:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign:
                              TextAlign.center, // This will center the text
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            enabled: false,
                            style: const TextStyle(
                              color: Colors.white
                            ),
                            controller: TextEditingController(
                              text: selectedDate != null
                                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                  : '',
                            ),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, // White underline border
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              hintText: '',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 1st Container for Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(
                        bottom: 10), // Reduced bottom margin
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 13, 211, 19), // Green background
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

                const SizedBox(
                  height: 10,
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 70),
                //   child: Container(
                //     margin: const EdgeInsets.only(bottom: 20),
                //     decoration: BoxDecoration(
                //       color: Colors.grey, // Green background for consistency
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //     child: Center(
                //       // Center the dropdown container in the parent widget
                //       child: SizedBox(
                //         width: MediaQuery.of(context).size.width *
                //             0.6, // 60% of the screen width
                //         child: DropdownButtonFormField<String>(
                //           decoration: const InputDecoration(
                //             border: OutlineInputBorder(),
                //             enabledBorder: InputBorder
                //                 .none, // Removing default border for consistency
                //           ),
                //           value: selectedCountry,
                //           onChanged: (String? value) {
                //             setState(() {
                //               selectedCountry = value;
                //             });
                //           },
                //           hint: const Text(
                //             'Country Select',
                //             style: TextStyle(
                //                 color: Colors.white), // White hint text
                //           ),
                //           items: <String>['USA', 'CAN', 'UK', 'AUS']
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(
                //                 value,
                //                 style: const TextStyle(
                //                     color:
                //                         Colors.white), // White text for items
                //               ),
                //             );
                //           }).toList(),
                //           dropdownColor: Colors
                //               .grey, // Set dropdown background color to gray
                //           style: const TextStyle(
                //               color: Colors
                //                   .white), // White text for the selected value
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                CountryDropdown(),

                // 4. Container for Gender Selection and Checkboxes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 13, 211, 19), // Updated color
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
                              fontSize: 20, // Font size for better visibility
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Row for the labels (Male, Female, Non-Binary)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Male',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16), // Adjusted font size
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'Female',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16), // Adjusted font size
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'Non-Binary',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16), // Adjusted font size
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  10), // Add space between checkboxes and labels
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Male Checkbox
                              Transform.scale(
                                scale: 1.5, // Increase the size of the checkbox
                                child: Checkbox(
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ), // White border color
                                  fillColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ), // Background color when checked (optional)
                                  checkColor: Colors.black,
                                  value: selectedGender == 'male',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedGender = value!
                                          ? 'male'
                                          : ''; // Assign 'male' or empty
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              // Female Checkbox
                              Transform.scale(
                                scale: 1.5, // Increase the size of the checkbox
                                child: Checkbox(
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ), // White border color
                                  fillColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ), // Background color when checked (optional)
                                  checkColor: Colors.black,
                                  value: selectedGender == 'female',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedGender = value!
                                          ? 'female'
                                          : ''; // Assign 'female' or empty
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              // Non-Binary Checkbox
                              Transform.scale(
                                scale: 1.5, // Increase the size of the checkbox
                                child: Checkbox(
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ), // White border color
                                  fillColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ), // Background color when checked (optional)
                                  checkColor: Colors.black,
                                  value: selectedGender == 'non-binary',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedGender = value!
                                          ? 'non-binary'
                                          : ''; // Assign 'non-binary' or empty
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
                const SizedBox(
                  height: 50,
                ),
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
                    builder: (context) => const Questions(),
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
  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  String? selectedCountry;

  // List of all country names
final List<String> countryNames = [
  'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia',
  'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 
  'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi', 
  'Cabo Verde', 'Cambodia', 'Cameroon', 'Canada', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 
  'Comoros', 'Congo (Congo-Brazzaville)', 'Congo (Congo-Kinshasa)', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic',
  'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea',
  'Estonia', 'Eswatini', 'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece',
  'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia',
  'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kiribati', 'Korea (North)',
  'Korea (South)', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein',
  'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania',
  'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar',
  'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Macedonia', 'Norway', 
  'Oman', 'Pakistan', 'Palau', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal', 'Qatar',
  'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa',
  'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia',
  'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 
  'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago',
  'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States',
  'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City', 'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe'
];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey, // Background color
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6, // 60% width
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: InputBorder.none, // Removing default border for consistency
              ),
              value: selectedCountry,
              onChanged: (String? value) {
                setState(() {
                  selectedCountry = value;
                });
              },
              hint: const Text(
                'Country Select',
                style: TextStyle(color: Colors.white), // White hint text
              ),
              items: countryNames.map<DropdownMenuItem<String>>((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(
                    country,
                    style: const TextStyle(color: Colors.white), // White text for items
                  ),
                );
              }).toList(),
              dropdownColor: Colors.grey, // Set dropdown background color
              style: const TextStyle(color: Colors.white), // White text for the selected value
            ),
          ),
        ),
      ),
    );
  }
}
