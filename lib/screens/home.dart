import 'package:flutter/material.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/providers/home_provider.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/screens/login.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer_widget.dart';
import 'menu_screens/insects_prediction/Insects_screen.dart';
import 'menu_screens/chat_bot_screen.dart';
import 'menu_screens/crop_prediction/crops_screen.dart';
import 'menu_screens/crop_diseases/diseases_screen.dart';
import 'menu_screens/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeProvider pHome;
  late ImageUtilProvider pImageUtil;
  late AuthenticationProvider pAuthentication;

  @override
  void initState() {
    super.initState();
    pHome = Provider.of<HomeProvider>(context, listen: false);
    pImageUtil = Provider.of<ImageUtilProvider>(context, listen: false);
    pAuthentication =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarThemeData theme =
        Theme.of(context).bottomNavigationBarTheme;
    List<BottomNavigationBarItem> menuItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.forest_rounded),
        label: 'Crops',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.eco_rounded),
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
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
          screens[context.watch<HomeProvider>().selectedScreenIndex].title),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => confirmationDialog(
                context,
                title: "Logout from Govi Mithura",
                yesFunction: () async {
                  await pAuthentication.signOut();
                  pHome.onNavigationChange(0);
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
            );
          },
          icon: const Icon(Icons.logout),
        )
      ],
    );

    ScreenSize.initAppBarHeight(appBar);
    return Scaffold(
      extendBody: true,
      drawer: const DrawerWidget(),
      appBar: appBar,
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
