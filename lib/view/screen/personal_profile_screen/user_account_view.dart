import 'package:flutter/material.dart';
import 'package:insource/view/screen/personal_profile_screen/tabs_view/liked_content_view.dart';
import 'package:insource/view/screen/personal_profile_screen/tabs_view/personal_content_list_view.dart';
import 'package:insource/viewmodel/account_view_provider.dart';
import 'package:insource/viewmodel/personal_list_view_provider.dart';
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView>
    with TickerProviderStateMixin {
  late AccountViewProvider accountProvider;

  @override
  void initState() {
    super.initState();

    Provider.of<PersonalListViewProvider>(context, listen: false)
        .getContentList();

    accountProvider = Provider.of<AccountViewProvider>(context, listen: false);

    accountProvider.context = context;

    accountProvider.tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: accountProvider.signOut,
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              )
            ],
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(200)),
            child: Consumer<AccountViewProvider>(
              builder: (context, value, child) => Image(
                width: 125,
                height: 125,
                fit: BoxFit.cover,
                image: NetworkImage(value.userData.imageUrl, scale: 0.1),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<AccountViewProvider>(
            builder: (context, value, child) => Text(
              value.userData.username,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Consumer<AccountViewProvider>(
            builder: (context, value, child) => Text(
              value.userData.email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 10, 10, 10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  spreadRadius: -10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child:
                TabBar(controller: accountProvider.tabController, tabs: const [
              Tab(
                text: 'Created',
              ),
              Tab(
                text: 'Liked',
              ),
            ]),
          ),
          Expanded(
            child: TabBarView(
                controller: accountProvider.tabController,
                children: const [UserContentList(), LikedContentList()]),
          )
        ],
      ),
    );
  }
}
