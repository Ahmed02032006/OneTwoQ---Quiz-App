import 'package:flutter/material.dart';
import 'package:quiz_app/admin/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/admin/screens/comments.dart';

class Questions extends StatefulWidget {
  const Questions({super.key, required this.subCategoryId});

  final String subCategoryId;

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final TextEditingController _questionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedCategoryId;
  String? _selectedSubcategoryId;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
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
                  'Questions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddQuestionModal(context);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Create Questions',
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
                prefixIcon: Icon(Icons.search),
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

  void _showAddQuestionModal(BuildContext context) {
    _questionController.clear();
    _selectedCategoryId = null;
    _selectedSubcategoryId = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add New Question'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _questionController,
                      decoration:
                          const InputDecoration(labelText: 'Enter Question'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter question';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.format_bold),
                          onPressed: () {
                            _applyStyleToSelectedText('**');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.format_italic),
                          onPressed: () {
                            _applyStyleToSelectedText('_');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.format_underline),
                          onPressed: () {
                            _applyStyleToSelectedText('__');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                          hint: const Text('Select Category'),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                              _selectedSubcategoryId = null;
                            });
                          },
                          items: snapshot.data!.docs.map((doc) {
                            return DropdownMenuItem<String>(
                              value: doc.id,
                              child: Text(doc['name']),
                            );
                          }).toList(),
                          validator: (value) =>
                              value == null ? 'Please select a category' : null,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    if (_selectedCategoryId != null)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('subcategories')
                            .where('categoryId', isEqualTo: _selectedCategoryId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButtonFormField<String>(
                            value: _selectedSubcategoryId,
                            hint: const Text('Select Subcategory'),
                            onChanged: (value) {
                              setState(() {
                                _selectedSubcategoryId = value;
                              });
                            },
                            items: snapshot.data!.docs.map((doc) {
                              return DropdownMenuItem<String>(
                                value: doc.id,
                                child: Text(doc['subcategory']),
                              );
                            }).toList(),
                            validator: (value) => value == null
                                ? 'Please select a subcategory'
                                : null,
                          );
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
                      await _addQuestion(
                        _questionController.text,
                        _selectedCategoryId!,
                        _selectedSubcategoryId!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Question created successfully')),
                      );
                      _questionController.clear();
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
      },
    );
  }

  void _applyStyleToSelectedText(String style) {
    final text = _questionController.text;
    final selection = _questionController.selection;
    if (selection.start == selection.end) return; // No text selected

    final selectedText = text.substring(selection.start, selection.end);
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$style$selectedText$style',
    );

    _questionController.text = newText;
    _questionController.selection = TextSelection.fromPosition(
      TextPosition(offset: selection.start + style.length),
    );
  }

  Future<void> _addQuestion(
      String question, String categoryId, String subcategoryId) async {
    try {
      await FirebaseFirestore.instance.collection('questions').add({
        'question': question,
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'sortOrder': 0, // Default value for sortOrder
      });
    } catch (e) {
      print('Error adding question: $e');
    }
  }

  Widget _buildDescriptionText(String description) {
    if (description.length > 10) {
      return Text(description.substring(0, 10) + '...');
    } else {
      return Text(description);
    }
  }

  Widget _buildDataTable() {
    final hardcodedSortOrders = {
      'question1Id': 1,
      'question2Id': 2,
      'question3Id': 3,
      // Add more hardcoded IDs and sortOrder values as needed
    };

    // Pagination variables
    const int rowsPerPage = 7;
    int currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('questions')
              .where("subcategoryId", isEqualTo: widget.subCategoryId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final questions = snapshot.data!.docs.where((doc) {
              final question = doc['question'] as String;
              return question.toLowerCase().contains(_searchQuery);
            }).toList();

            // Sort questions based on sortOrder
            questions.sort((a, b) {
              final aSortOrder = hardcodedSortOrders[a.id] ?? 0;
              final bSortOrder = hardcodedSortOrders[b.id] ?? 0;
              return aSortOrder.compareTo(bSortOrder);
            });

            final totalPages = (questions.length / rowsPerPage).ceil();

            // Paginated rows
            final paginatedQuestions = questions
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
                        DataColumn(label: Text('Sort Order')),
                        DataColumn(label: Text('Question')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Subcategory')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: paginatedQuestions.map((doc) {
                        final questionId = doc.id;
                        final question = doc['question'] as String;
                        final categoryId = doc['categoryId'] as String;
                        final subcategoryId = doc['subcategoryId'] as String;

                        return DataRow(
                          cells: [
                            // ===============================================================
                            DataCell(
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('questions')
                                    .doc(questionId)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text('Loading...');
                                  }

                                  var data = snapshot.data!.data()
                                      as Map<String, dynamic>?;
                                  if (data == null ||
                                      !data.containsKey('sortOrder')) {
                                    return const Text('No sortOrder found');
                                  }

                                  var sortOrder = data['sortOrder'];
                                  if (sortOrder == null) {
                                    return const Text('No sortOrder found');
                                  }

                                  return Row(
                                    children: [
                                      // Minus button
                                      SizedBox(
                                        width: 150,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  color: Colors.green,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    int newSortOrder =
                                                        sortOrder - 1;

                                                    // Fetch all documents to ensure the new sortOrder doesn't duplicate any existing one
                                                    var querySnapshot =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'questions')
                                                            .where('sortOrder',
                                                                isEqualTo:
                                                                    newSortOrder)
                                                            .get();

                                                    if (querySnapshot
                                                        .docs.isEmpty) {
                                                      // Update only if no document has the same sortOrder
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'questions')
                                                          .doc(questionId)
                                                          .update({
                                                        'sortOrder':
                                                            newSortOrder
                                                      });
                                                    } else {
                                                      // If the number already exists, increment other sortOrder values
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'questions')
                                                          .where('sortOrder',
                                                              isGreaterThanOrEqualTo:
                                                                  newSortOrder)
                                                          .get()
                                                          .then(
                                                              (querySnapshot) {
                                                        for (var doc
                                                            in querySnapshot
                                                                .docs) {
                                                          // Increment all sortOrder values greater than or equal to the new value
                                                          int currentSortOrder =
                                                              doc['sortOrder'];
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'questions')
                                                              .doc(doc.id)
                                                              .update({
                                                            'sortOrder':
                                                                currentSortOrder +
                                                                    1
                                                          });
                                                        }
                                                      });
                                                      // Finally, update the current document's sortOrder
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'questions')
                                                          .doc(questionId)
                                                          .update({
                                                        'sortOrder':
                                                            newSortOrder
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            // Display the sortOrder number
                                            Text(
                                              sortOrder.toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(width: 2),
                                            // Plus button
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  color: Colors.green,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    int newSortOrder =
                                                        sortOrder + 1;

                                                    // Fetch all documents to ensure the new sortOrder doesn't duplicate any existing one
                                                    var querySnapshot =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'questions')
                                                            .where('sortOrder',
                                                                isEqualTo:
                                                                    newSortOrder)
                                                            .get();

                                                    if (querySnapshot
                                                        .docs.isEmpty) {
                                                      // Update only if no document has the same sortOrder
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'questions')
                                                          .doc(questionId)
                                                          .update({
                                                        'sortOrder':
                                                            newSortOrder
                                                      });
                                                    } else {
                                                      // If the number already exists, increment other sortOrder values
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'questions')
                                                          .where('sortOrder',
                                                              isGreaterThanOrEqualTo:
                                                                  newSortOrder)
                                                          .get()
                                                          .then(
                                                              (querySnapshot) {
                                                        for (var doc
                                                            in querySnapshot
                                                                .docs) {
                                                          // Increment all sortOrder values greater than or equal to the new value
                                                          int currentSortOrder =
                                                              doc['sortOrder'];
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'questions')
                                                              .doc(doc.id)
                                                              .update({
                                                            'sortOrder':
                                                                currentSortOrder +
                                                                    1
                                                          });
                                                        }
                                                      });
                                                      // Finally, update the current document's sortOrder
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'questions')
                                                          .doc(questionId)
                                                          .update({
                                                        'sortOrder':
                                                            newSortOrder
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            DataCell(
                              _buildDescriptionText(question),
                            ),
                            DataCell(FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(categoryId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('...');
                                }
                                return Text(snapshot.data!['name']);
                              },
                            )),
                            DataCell(FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('subcategories')
                                  .doc(subcategoryId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('...');
                                }
                                return Text(snapshot.data!['subcategory']);
                              },
                            )),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _showEditQuestionModal(
                                          context, questionId, question);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _deleteQuestion(questionId);
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Comments(
                                            questionId: questionId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View Comments',
                                      style: TextStyle(
                                        fontSize: 13,
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

  void _showEditQuestionModal(
      BuildContext context, String questionId, String question) {
    final TextEditingController _editQuestionController =
        TextEditingController(text: question);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Question'),
          content: TextField(
            controller: _editQuestionController,
            decoration: const InputDecoration(labelText: 'Edit Question'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedQuestion = _editQuestionController.text;
                await FirebaseFirestore.instance
                    .collection('questions')
                    .doc(questionId)
                    .update({'question': updatedQuestion});
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteQuestion(String questionId) async {
    await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .delete();
  }
}
