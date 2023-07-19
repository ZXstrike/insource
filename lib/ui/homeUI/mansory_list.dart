import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';

class MansoryList extends StatefulWidget {
  const MansoryList({super.key});

  @override
  State<MansoryList> createState() => _MansoryListState();
}

class _MansoryListState extends State<MansoryList> {
  final ScrollController _scrollController = ScrollController();
  List listContent = [];

  void _getData() {
    final firedb = FirebaseFirestore.instance;

    firedb.collection('ContentData').get().then(
      (querySnapshot) {
        debugPrint('Susccessfully');
        for (var docSnapshot in querySnapshot.docs) {
          final doc = docSnapshot.data();
          final data = {
            'Id': docSnapshot.id,
            'title': doc['title'],
            'imageUrl': doc['imageUrl'],
          };
          listContent.add(data);
        }
        setState(() {});
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // _loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getData();
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: MasonryView(
        itemRadius: 0,
        itemPadding: 0,
        listOfItem: listContent,
        numberOfColumn: 2,
        itemBuilder: (contentData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/PostDetail',
                    arguments: contentData['id']);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(contentData['imageUrl']),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      contentData['title'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
