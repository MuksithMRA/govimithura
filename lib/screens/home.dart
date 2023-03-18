import 'package:flutter/material.dart';
import 'package:govimithura/providers/home_provider.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer_widget.dart';
import 'menu_screens/Insects_screen.dart';
import 'menu_screens/chat_bot_screen.dart';
import 'menu_screens/crops_screen.dart';
import 'menu_screens/diseases_screen.dart';
import 'menu_screens/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeProvider pHome;
  late ImageUtilProvider pImageUtil;

  @override
  void initState() {
    super.initState();
    pHome = Provider.of<HomeProvider>(context, listen: false);
    pImageUtil = Provider.of<ImageUtilProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarThemeData theme =
        Theme.of(context).bottomNavigationBarTheme;
    List<BottomNavigationBarItem> menuItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.crop),
        label: 'Crops',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.energy_savings_leaf),
        label: 'Diseases',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.bug_report),
        label: 'Insects',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Chat Bot',
      ),
    ];
    List<HomeScreenItem> screens = [
      HomeScreenItem(
          title: "Welcome to Govi Mithura", screen: const HomeScreen()),
      HomeScreenItem(title: "Crops Detection", screen: const CropsScreen()),
      HomeScreenItem(
          title: "Diseases Detection", screen: const DiseasesScreen()),
      HomeScreenItem(title: "Insects Detection", screen: const InsectsScreen()),
      HomeScreenItem(title: "Chat Bot", screen: const ChatBotScreen()),
    ];
    return Scaffold(
      extendBody: true,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            screens[context.watch<HomeProvider>().selectedScreenIndex].title),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<HomeProvider>().selectedScreenIndex,
        selectedIconTheme: theme.selectedIconTheme,
        unselectedIconTheme: theme.unselectedIconTheme,
        items: menuItems,
        onTap: (index) {
          pHome.onNavigationChange(index);
          pImageUtil.clearImage();
        },
      ),
      body: screens[context.watch<HomeProvider>().selectedScreenIndex].screen,
    );
  }
}

class HomeScreenItem {
  final String title;
  final Widget screen;

  HomeScreenItem({required this.title, required this.screen});
}
