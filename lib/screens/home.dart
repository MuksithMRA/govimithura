import 'package:flutter/material.dart';
import 'package:govimithura/providers/home_provider.dart';
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

  @override
  void initState() {
    super.initState();
    pHome = Provider.of<HomeProvider>(context, listen: false);
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
    List<Widget> screens = [
      const HomeScreen(),
      const CropsScreen(),
      const DiseaseScreen(),
      const InsectsScreen(),
      const ChatBotScreen(),
    ];
    return Scaffold(
      extendBody: true,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<HomeProvider>().selectedScreenIndex,
        selectedIconTheme: theme.selectedIconTheme,
        unselectedIconTheme: theme.unselectedIconTheme,
        items: menuItems,
        onTap: (index) => pHome.onNavigationChange(index),
      ),
      body: screens[context.watch<HomeProvider>().selectedScreenIndex],
    );
  }
}
