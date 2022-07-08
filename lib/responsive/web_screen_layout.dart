import 'package:flutter/material.dart';
import 'package:flutter_gram/utils/global_variables.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart';
import '../utils/colors.dart';
import '../widgets/logout_dialog.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  late PageController pageController;

  int page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
    setState(() {
      page = page;
    });
  }

  void pageChanged(int currpage) {
    setState(() {
      page = currpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
              onPressed: () => navigationTap(0),
              icon: Icon(
                Icons.home,
                color: page == 0 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () => navigationTap(1),
              icon: Icon(Icons.search,
                  color: page == 1 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () => navigationTap(2),
              icon: Icon(Icons.add_a_photo,
                  color: page == 2 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () => navigationTap(3),
              icon: Icon(Icons.favorite,
                  color: page == 3 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () => navigationTap(4),
              icon: Icon(Icons.person,
                  color: page == 4 ? primaryColor : secondaryColor)),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: homeScreenItems,
        onPageChanged: pageChanged,
      ),
    );
  }
}
