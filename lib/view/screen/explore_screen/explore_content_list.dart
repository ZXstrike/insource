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
    return RefreshIndicator(
      onRefresh: listProvider.onRefresh,
      child: SingleChildScrollView(
        child: Column(children: [
          Consumer<ExploreListViewProvider>(
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 1.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: const Color.fromRGBO(10, 10, 10, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Text(
                      'Today\'s art ideas',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      value.todaysIdea,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Consumer<ExploreListViewProvider>(builder: (context, value, child) {
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
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  cacheExtent: 60000,
                  itemCount: value.contentList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: ContentCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
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
                );
              }
            }
          }),
        ]),
      ),
    );
  }
}
