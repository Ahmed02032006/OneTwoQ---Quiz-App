import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/admin/screens/questions.dart';

class AdminSubCategory extends StatefulWidget {
  const AdminSubCategory({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  _AdminSubCategoryState createState() => _AdminSubCategoryState();
}

class _AdminSubCategoryState extends State<AdminSubCategory> {
  final TextEditingController _subcategoryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedCategoryId;
  String _searchQuery = '';

  bool isQuestionsDisplayed = false;

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('Settings')
          .doc('2fbG1GP9nX7XJrgGaA6H')
          .get();
      if (doc.exists) {
        var isQuestionsDisplay = doc.data()?['isQuestionsDisplayed'];
        setState(() {
          isQuestionsDisplayed = isQuestionsDisplay;
        });
      } else {
        debugPrint("Document does not exist");
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SubCategory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sub Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddSubcategoryModal(context);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Create Subcategory',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 450,
              child: _buildDataTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionText(String description) {
    if (description.length > 10) {
      return Text(description.substring(0, 10) + '...');
    } else {
      return Text(description);
    }
  }

  void _showAddSubcategoryModal(BuildContext context) {
    _selectedCategoryId = null;
    _subcategoryController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Subcategory'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      hint: const Text('Select Parent Category'),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      items: snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc['name']),
                        );
                      }).toList(),
                      validator: (value) => value == null
                          ? 'Please select a parent category'
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subcategoryController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Subcategory'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subcategory name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _addSubcategory(
                    _selectedCategoryId!,
                    _subcategoryController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Subcategory created successfully')),
                  );
                  _subcategoryController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSubcategory(
      String categoryId, String subcategoryName) async {
    try {
      await FirebaseFirestore.instance.collection('subcategories').add({
        'categoryId': categoryId,
        'subcategory': subcategoryName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding subcategory: $e');
    }
  }

  // Widget _buildDataTable() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream:
  //         FirebaseFirestore.instance.collection('subcategories').snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //         return const Center(child: Text('No subcategories found.'));
  //       }

  //       final subcategories = snapshot.data!.docs.where((doc) {
  //         final subcategory = doc['subcategory'].toString().toLowerCase();
  //         return subcategory.contains(_searchQuery);
  //       }).toList();

  //       return SingleChildScrollView(
  //         scrollDirection: Axis.vertical,
  //         child: DataTable(
  //           columnSpacing: 16.0,
  //           columns: const [
  //             DataColumn(label: Text('Subcategory')),
  //             DataColumn(label: Text('Category')),
  //             DataColumn(label: Text('Action')),
  //           ],
  //           rows: subcategories.map((doc) {
  //             return DataRow(cells: [
  //               DataCell(Text(doc['subcategory'].substring(
  //                   0,
  //                   doc['subcategory'].length > 10
  //                       ? 10
  //                       : doc['subcategory'].length))),
  //               DataCell(FutureBuilder<DocumentSnapshot>(
  //                 future: FirebaseFirestore.instance
  //                     .collection('categories')
  //                     .doc(doc['categoryId'])
  //                     .get(),
  //                 builder: (context, snapshot) {
  //                   if (!snapshot.hasData) return const Text('Loading...');
  //                   if (!snapshot.data!.exists) {
  //                     return _buildDescriptionText("No Found");
  //                   }
  //                   return _buildDescriptionText(snapshot.data!['name']);
  //                 },
  //               )),
  // DataCell(Row(
  //   children: [
  //     IconButton(
  //       icon: const Icon(
  //         Icons.edit,
  //         color: Colors.black,
  //       ),
  //       onPressed: () {
  //         _showEditSubcategoryModal(context, doc.id,
  //             doc['subcategory'], doc['categoryId']);
  //       },
  //     ),
  //     IconButton(
  //       icon: const Icon(
  //         Icons.delete,
  //         color: Colors.black,
  //       ),
  //       onPressed: () {
  //         _showDeleteSubcategoryDialog(context, doc.id);
  //       },
  //     ),
  //     ElevatedButton(
  //       onPressed: () {
  //         Navigator.of(context).push(
  //           MaterialPageRoute(
  //             builder: (context) => const Questions(),
  //           ),
  //         );
  //       },
  //       child: const Text('View Questions'),
  //     ),
  //   ],
  // )),
  //             ]);
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildDataTable() {
    // Pagination variables
    const int rowsPerPage = 7;
    int currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('subcategories')
              .where("categoryId", isEqualTo: widget.categoryId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final subcategories = snapshot.data!.docs.where((doc) {
              final subcategory = doc['subcategory'] as String;
              return subcategory.toLowerCase().contains(_searchQuery);
            }).toList();

            final totalPages = (subcategories.length / rowsPerPage).ceil();

            // Paginated rows
            final paginatedSubcategories = subcategories
                .skip(currentPage * rowsPerPage)
                .take(rowsPerPage)
                .toList();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Subcategory')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: paginatedSubcategories.map((doc) {
                        final subcategoryId = doc.id;
                        final subcategory = doc['subcategory'] as String;
                        final categoryId = doc['categoryId'] as String;

                        return DataRow(
                          cells: [
                            DataCell(Text(subcategory)),
                            DataCell(
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(categoryId)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text('...');
                                  }
                                  return Text(
                                      snapshot.data!['name'] ?? 'Unknown');
                                },
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _showEditSubcategoryModal(
                                          context,
                                          subcategoryId,
                                          doc['subcategory'],
                                          doc['categoryId']);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _showDeleteSubcategoryDialog(
                                        context,
                                        subcategoryId,
                                      );
                                    },
                                  ),
                                  if (isQuestionsDisplayed)
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Questions(
                                              subCategoryId: subcategoryId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'View Questions',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: currentPage > 0
                          ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                          : null,
                    ),
                    Text(
                      'Page ${currentPage + 1} of $totalPages',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: currentPage < totalPages - 1
                          ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Existing edit and delete modal functions remain unchanged...

  void _showEditSubcategoryModal(BuildContext context, String subcategoryId,
      String subcategoryName, String categoryId) {
    _subcategoryController.text = subcategoryName;
    _selectedCategoryId = categoryId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Subcategory'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      hint: const Text('Select Parent Category'),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value!;
                        });
                      },
                      items: snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc['name']),
                        );
                      }).toList(),
                      validator: (value) => value == null
                          ? 'Please select a parent category'
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subcategoryController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Subcategory'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subcategory name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _updateSubcategory(
                    subcategoryId,
                    _selectedCategoryId!,
                    _subcategoryController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Subcategory updated successfully')),
                  );
                  _subcategoryController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateSubcategory(
      String subcategoryId, String categoryId, String subcategoryName) async {
    try {
      await FirebaseFirestore.instance
          .collection('subcategories')
          .doc(subcategoryId)
          .update({
        'categoryId': categoryId,
        'subcategory': subcategoryName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating subcategory: $e');
    }
  }

  void _showDeleteSubcategoryDialog(
      BuildContext context, String subcategoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subcategory'),
          content:
              const Text('Are you sure you want to delete this subcategory?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _deleteSubcategory(subcategoryId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Subcategory deleted successfully')),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSubcategory(String subcategoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('subcategories')
          .doc(subcategoryId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting subcategory: $e');
    }
  }
}
