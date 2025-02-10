import 'package:flutter/material.dart';
import 'package:quiz_app/admin/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/admin/screens/subcategory.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _selectedCategoryId;
  late String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
      ),
      drawer: const NavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddCategoryModal(context);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Create Category',
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

  void _showAddCategoryModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'Enter Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
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
                  await _addCategory(
                    _nameController.text,
                    _descriptionController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Category created successfully')),
                  );
                  _nameController.clear();
                  _descriptionController.clear();
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

  Future<void> _addCategory(String name, String description) async {
    try {
      await FirebaseFirestore.instance.collection('categories').add({
        'name': name,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

  // Widget _buildDataTable() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('categories').snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //         return const Center(child: Text('No categories found.'));
  //       }

  //       final categories = snapshot.data!.docs.where((category) {
  //         final name = (category['name'] ?? '').toString().toLowerCase();
  //         final description =
  //             (category['description'] ?? '').toString().toLowerCase();
  //         return name.contains(_searchQuery.toLowerCase()) ||
  //             description.contains(_searchQuery.toLowerCase());
  //       }).toList();

  //       return SingleChildScrollView(
  //         scrollDirection: Axis.vertical,
  //         child: DataTable(
  //           columnSpacing: 16.0,
  //           columns: const [
  //             DataColumn(label: Text('Name')),
  //             DataColumn(label: Text('Description')),
  //             DataColumn(label: Text('Action')),
  //           ],
  //           rows: categories.map((category) {
  //             return DataRow(cells: [
  //               DataCell(Text(category['name'] ?? 'N/A')),
  //               DataCell(
  //                 _buildDescriptionText(
  //                   category['description'],
  //                 ),
  //               ),
  // DataCell(
  //   Row(
  //     children: [
  //       IconButton(
  //         icon: const Icon(
  //           Icons.edit,
  //           color: Colors.black,
  //         ),
  //         onPressed: () {
  //           _showEditCategoryModal(
  //             context,
  //             category.id,
  //             category['name'] ?? '',
  //             category['description'] ?? '',
  //           );
  //         },
  //       ),
  //       IconButton(
  //         icon: const Icon(
  //           Icons.delete,
  //           color: Colors.black,
  //         ),
  //         onPressed: () {
  //           _showDeleteCategoryDialog(
  //             context,
  //             category.id,
  //           );
  //         },
  //       ),
  //       ElevatedButton(
  //         onPressed: () {
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => Subcategories(),
  //             ),
  //           );
  //         },
  //         child: const Text(
  //           'View Sub Categories',
  //           style: TextStyle(
  //             fontSize: 13,
  //             color: Colors.black,
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // ),
  //             ]);
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

  int _itemsPerPage = 7; // Items per page
  int currentPage = 0; // Tracks the current page
  int totalPages = 1; // Default total pages
  DocumentSnapshot? _lastDocument; // Tracks the last document for next page
  DocumentSnapshot?
      _firstDocument; // Tracks the first document for previous page
  bool _isLoading = false; // Prevents multiple simultaneous requests

  Future<void> _loadPage({bool isNext = true}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('categories')
        .orderBy('name')
        .limit(_itemsPerPage);

    if (isNext && _lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    } else if (!isNext && _firstDocument != null) {
      query =
          query.endBeforeDocument(_firstDocument!).limitToLast(_itemsPerPage);
    }

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _firstDocument = snapshot.docs.first;
      _lastDocument = snapshot.docs.last;

      setState(() {
        currentPage = isNext ? currentPage + 1 : currentPage - 1;
        totalPages = (snapshot.size < _itemsPerPage && isNext)
            ? currentPage + 1
            : totalPages;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildDataTable() {
    // Pagination variables
    const int rowsPerPage = 7;
    int currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final categories = snapshot.data!.docs.where((doc) {
              final name = doc['name'] as String;
              return name.toLowerCase().contains(_searchQuery);
            }).toList();

            final totalPages = (categories.length / rowsPerPage).ceil();

            // Paginated rows
            final paginatedCategories = categories
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
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: paginatedCategories.map((doc) {
                        final categoryId = doc.id;
                        final name = doc['name'] as String;
                        final description =
                            doc['description'] ?? 'No description';

                        return DataRow(
                          cells: [
                            DataCell(Text(name)),
                            DataCell(
                              _buildDescriptionText(description),
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
                                      _showEditCategoryModal(
                                        context,
                                        categoryId,
                                        name ?? '',
                                        description ?? '',
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _showDeleteCategoryDialog(
                                        context,
                                        categoryId,
                                      );
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdminSubCategory(
                                            categoryId: categoryId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View Sub Categories',
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
                // Pagination Controls
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

  Widget _buildDescriptionText(String description) {
    if (description.length > 10) {
      return Text(description.substring(0, 10) + '...');
    } else {
      return Text(description);
    }
  }

  void _showEditCategoryModal(BuildContext context, String categoryId,
      String name, String description) {
    _selectedCategoryId = categoryId;
    _nameController.text = name;
    _descriptionController.text = description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'Enter Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
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
                  await _updateCategory(
                    _selectedCategoryId,
                    _nameController.text,
                    _descriptionController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Category updated successfully')),
                  );
                  _nameController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Submit',
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

  Future<void> _updateCategory(
      String categoryId, String name, String description) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update({
        'name': name,
        'description': description,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating category: $e');
    }
  }

  void _showDeleteCategoryDialog(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _deleteCategory(categoryId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Category deleted successfully')),
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

  Future<void> _deleteCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting category: $e');
    }
  }
}
