import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/screens/register.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:govimithura/widgets/utils/buttons/custom_elevated_button.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthenticationProvider pAuthentication;

  @override
  void initState() {
    super.initState();
    pAuthentication =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: ScreenSize.height,
        width: ScreenSize.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const LogoText(),
                  spacingWidget(30, SpaceDirection.vertical),
                  Text(
                    'Welcome again to Govimithura',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  const PrimaryTextField(
                    label: "Enter your email",
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  const PrimaryTextField(
                    label: "Enter password",
                  ),
                  spacingWidget(10, SpaceDirection.vertical),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  CustomElevatedButton(
                    text: "Login",
                    onPressed: () async {
                      bool success = await LoadingOverlay.of(context)
                          .during(pAuthentication.login());
                      if (success) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Home(),
                            ),
                          );
                        }
                      } else {
                        if (mounted) {
                          Utils.showSnackBar(context, ErrorModel.errorMessage);
                        }
                      }
                    },
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
