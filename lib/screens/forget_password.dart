import 'package:flutter/material.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/utils/buttons/custom_elevated_button.dart';
import '../widgets/utils/text_fields/primary_textfield.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
      appBar: AppBar(
        title: const Text(
          "Forget Password",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LogoText(),
              spacingWidget(30, SpaceDirection.vertical),
              const Text(
                "Please enter your email address to recieve reset password link",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              spacingWidget(20, SpaceDirection.vertical),
              PrimaryTextField(
                onChanged: (value) {
                  pAuthentication.setEmail(value);
                },
                label: "Email Address",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  } else if (!(value.contains("@") && value.contains("."))) {
                    return 'Enter valid Email Address';
                  }
                  return null;
                },
              ),
              spacingWidget(20, SpaceDirection.vertical),
              CustomElevatedButton(
                text: "Send reset password link",
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    Navigator.pop(context);
                    bool isSent = await LoadingOverlay.of(context)
                        .during(pAuthentication.forgetPassword(context));
                    if (mounted && isSent) {
                      Utils.showDialogBox(context,
                          "Link sent to ${pAuthentication.authModel.email} please check your email inbox");
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
