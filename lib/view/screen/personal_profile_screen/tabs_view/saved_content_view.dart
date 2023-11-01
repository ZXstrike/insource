import 'package:flutter/material.dart';
import 'package:insource/view/widgets/content_card.dart';
import 'package:insource/viewmodel/saved_list_view_provider.dart';
import 'package:provider/provider.dart';

class SavedContentList extends StatefulWidget {
  const SavedContentList({super.key});

  @override
  State<SavedContentList> createState() => _SavedContentListState();
}

class _SavedContentListState extends State<SavedContentList> {
  late final SavedListViewProvider listProvider;

  @override
  void initState() {
    super.initState();

    listProvider = Provider.of<SavedListViewProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedListViewProvider>(builder: (context, value, child) {
      if (value.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (value.contentList.isEmpty) {
          return const Center(
            child: Text(
              'There is nothing, Huh?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: listProvider.onRefresh,
            child: ListView.builder(
              cacheExtent: 60000,
              itemCount: value.contentList.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: ContentCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  radius: 15,
                  contentImage: NetworkImage(
                    value.contentList[index].imageUrl,
                    scale: 0.1,
                  ),
                  profileImage: NetworkImage(
                      value.contentList[index].creatorPicture,
                      scale: 0.005),
                  title: value.contentList[index].title,
                  creator: value.contentList[index].creatorName,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  likeIcon: value.contentList[index].liked
                              .contains(value.currentUser?.uid) ==
                          true
                      ? const Icon(
                          Icons.favorite,
                          size: 35,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.favorite_outline_outlined,
                          size: 35,
                          color: Colors.white,
                        ),
                  likeFunction: () => listProvider.likeContent(index),
                  saveIcon: value.contentList[index].saved
                              .contains(value.currentUser?.uid) ==
                          true
                      ? const Icon(
                          Icons.bookmark,
                          size: 35,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.bookmark_border_outlined,
                          size: 35,
                          color: Colors.white,
                        ),
                  saveFunction: () => listProvider.saveContent(index),
                ),
              ),
            ),
          );
        }
      }
    });
  }
}
