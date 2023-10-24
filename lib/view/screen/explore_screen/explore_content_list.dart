import 'package:flutter/material.dart';
import 'package:insource/view/widgets/content_card.dart';
import 'package:insource/viewmodel/content_list_view_provider.dart';
import 'package:provider/provider.dart';

class ContentList extends StatefulWidget {
  const ContentList({super.key});

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  late final ExploreListViewProvider listProvider;

  @override
  void initState() {
    super.initState();

    listProvider = Provider.of<ExploreListViewProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreListViewProvider>(builder: (context, value, child) {
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ContentCard(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                icon: value.contentList[index].liked
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
              ),
            ),
          ),
        );
      }
    });
  }
}
