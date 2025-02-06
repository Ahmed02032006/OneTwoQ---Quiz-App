import 'package:flutter/material.dart';
import 'package:quiz_app/admin/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, this.questionId});

  final String? questionId;

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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

  Widget _buildDataTable() {
  const int rowsPerPage = 10;
  int currentPage = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Comments')
            .where("questionId", isEqualTo: widget.questionId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final comments = snapshot.data!.docs.where((doc) {
            final comment = doc['comment'] as String;
            return comment.toLowerCase().contains(_searchQuery);
          }).toList();

          if (comments.isEmpty) {
            return const Center(
              child: Text(
                'No comments available.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final totalPages = (comments.length / rowsPerPage).ceil();
          final paginatedComments = comments
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
                      DataColumn(label: Text('Comment')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Question')),
                      DataColumn(label: Text('Category')),
                    ],
                    rows: paginatedComments.map((doc) {
                      final commentText = doc['comment'] as String;
                      final username = doc['username'] as String;
                      final questionId = doc['questionId'] as String;
                      final categoryId = doc['categoryId'] as String;

                      return DataRow(
                        cells: [
                          DataCell(Text(commentText)),
                          DataCell(Text(username)),
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
                                final question =
                                    snapshot.data?.get('question') ?? 'Unknown';
                                return Text(question);
                              },
                            ),
                          ),
                          DataCell(
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(categoryId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('Loading...');
                                }
                                final category =
                                    snapshot.data?.get('name') ?? 'Unknown';
                                return Text(category);
                              },
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


}
