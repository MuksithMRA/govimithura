import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/screens/register.dart';
import 'package:govimithura/services/auth_service.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/buttons/custom_elevated_button.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const Home(),
                      //   ),
                      // );
                      AuthService authService = AuthService();
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
