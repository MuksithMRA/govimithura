import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/screens/login.dart';

import '../utils/screen_size.dart';
import '../widgets/utils/buttons/custom_elevated_button.dart';
import '../widgets/utils/common_widget.dart';
import '../widgets/utils/text_fields/primary_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                    'Welcome to Govimithura',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  const PrimaryTextField(
                    label: "Full name",
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  const PrimaryTextField(
                    label: "Phone number",
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  const PrimaryTextField(
                    label: "Password",
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  const PrimaryTextField(
                    label: "Confirm Password",
                  ),
                  spacingWidget(30, SpaceDirection.vertical),
                  CustomElevatedButton(
                    text: "Register ",
                    onPressed: () {},
                  ),
                  spacingWidget(20, SpaceDirection.vertical),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: "Login",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
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
