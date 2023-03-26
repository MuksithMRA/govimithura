import 'package:flutter/material.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/buttons/custom_elevated_button.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';
import 'package:provider/provider.dart';

class InsectControlMethodPost extends StatefulWidget {
  const InsectControlMethodPost({super.key});

  @override
  State<InsectControlMethodPost> createState() =>
      _InsectControlMethodPostState();
}

class _InsectControlMethodPostState extends State<InsectControlMethodPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late PostProvider pPost;
  @override
  void initState() {
    super.initState();
    pPost = Provider.of<PostProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Insect Control Method'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: ScreenSize.width,
            height: ScreenSize.height - (ScreenSize.appBarHeight + 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                PrimaryTextField(
                  onChanged: (value) {
                    pPost.setPostTitle(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please write a title';
                    }
                    return null;
                  },
                  hintText: 'Title',
                ),
                spacingWidget(20, SpaceDirection.vertical),
                PrimaryTextField(
                  onChanged: (value) {
                    pPost.setPostContent(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please write a method';
                    }
                    return null;
                  },
                  maxLines: 10,
                  hintText: 'Write a Method...',
                ),
                spacingWidget(20, SpaceDirection.vertical),
                CustomElevatedButton(
                    text: "Post",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await LoadingOverlay.of(context)
                            .during(pPost.addPost(context));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
