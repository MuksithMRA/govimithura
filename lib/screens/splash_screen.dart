import 'package:flutter/material.dart';
import 'package:govimithura/constants/user_types.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/screens/admin_home.dart';
import 'package:govimithura/screens/home.dart';
import 'package:govimithura/screens/login.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';

import '../utils/screen_size.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthenticationProvider pAuthentication;
  @override
  void initState() {
    super.initState();
    pAuthentication =
        Provider.of<AuthenticationProvider>(context, listen: false);
    Future.delayed(const Duration(seconds: 3), () async {
      await pAuthentication.getCurentUserModel();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            if (pAuthentication.isLoggedIn()) {
              if (pAuthentication.authModel.userType == UserType.admin) {
                return const AdminHome();
              } else {
                return const Home();
              }
            } else {
              return const LoginScreen();
            }
          }),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: const Center(
        child: Logo(),
      ),
    );
  }
}
