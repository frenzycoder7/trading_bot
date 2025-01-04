import 'package:flutter/material.dart';
import 'package:trading_bot/modules/home/widgets/tabItem.widget.dart';
import 'package:trading_bot/modules/home/widgets/animated_tab_container.widget.dart';

class TabPageController extends StatefulWidget {
  final List<Widget> pages;
  final List<String> tabs;
  final double tabHeight;
  final Color? backgroundColor;

  const TabPageController({
    super.key,
    required this.pages,
    required this.tabs,
    this.tabHeight = 50,
    this.backgroundColor,
  }) : assert(pages.length == tabs.length,
            'Pages and tabs must have the same length');

  @override
  State<TabPageController> createState() => _TabPageControllerState();
}

class _TabPageControllerState extends State<TabPageController> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    final page = (_pageController.page ?? 0).round();
    if (page != _currentIndex) {
      setState(() => _currentIndex = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page View
        Expanded(
          child: PageView(
            controller: _pageController,
            children: widget.pages,
          ),
        ),
        // Bottom Tab Bar
        AnimatedTabContainer(
          height: widget.tabHeight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.tabs.length,
              (index) => CustomTabItem(
                text: widget.tabs[index],
                isSelected: index == _currentIndex,
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 20)
      ],
    );
  }
}
