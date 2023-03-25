import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/screens/login.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../utils/screen_size.dart';
import '../widgets/utils/buttons/custom_elevated_button.dart';
import '../widgets/utils/common_widget.dart';
import '../widgets/utils/text_fields/primary_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthenticationProvider pAuthentication;

  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

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
            key: registerFormKey,
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
                      PrimaryTextField(
                        label: "First name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          pAuthentication.setFirstName(value.trim());
                        },
                      ),
                      spacingWidget(20, SpaceDirection.vertical),
                      PrimaryTextField(
                        label: "Last name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          pAuthentication.setLastName(value.trim());
                        },
                      ),
                      spacingWidget(20, SpaceDirection.vertical),
                      PrimaryTextField(
                        label: "Email address",
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
                        label: "Password",
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
                      spacingWidget(20, SpaceDirection.vertical),
                      PrimaryTextField(
                        isPassword: true,
                        label: "Confirm password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          } else if (value !=
                              pAuthentication.authModel.password) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          pAuthentication.setConfirmPassword(value.trim());
                        },
                      ),
                      spacingWidget(30, SpaceDirection.vertical),
                      CustomElevatedButton(
                        text: "Register ",
                        onPressed: () async {
                          if (registerFormKey.currentState!.validate()) {
                            LoadingOverlay overlay = LoadingOverlay.of(context);
                            bool success = await overlay
                                .during(pAuthentication.register());
                            if (success) {
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
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
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: "Login",
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
        ),
      ),
    );
  }
}
