import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/constants/user_types.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/screens/admin_home.dart';
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
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pAuthentication =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenSize.height,
          width: ScreenSize.width,
          child: Form(
            key: loginFormKey,
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
                      PrimaryTextField(
                        label: "Enter your email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          } else if (!(value.contains("@") &&
                              value.contains("."))) {
                            return 'Enter valid Email Address';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          pAuthentication.setEmail(value.trim());
                        },
                      ),
                      spacingWidget(20, SpaceDirection.vertical),
                      PrimaryTextField(
                        isPassword: true,
                        label: "Enter password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          pAuthentication.setPassWord(value.trim());
                        },
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
                          if (loginFormKey.currentState!.validate()) {
                            bool success = await LoadingOverlay.of(context)
                                .during(pAuthentication.login());
                            if (success) {
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        pAuthentication.authModel.userType ==
                                                UserType.user
                                            ? const Home()
                                            : const AdminHome(),
                                  ),
                                );
                              }
                            } else {
                              if (mounted) {
                                Utils.showSnackBar(
                                    context, ErrorModel.errorMessage);
                              }
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
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
        ),
      ),
    );
  }
}
