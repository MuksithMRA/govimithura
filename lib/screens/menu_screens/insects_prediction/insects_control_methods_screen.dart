import 'package:flutter/material.dart';
import 'package:govimithura/screens/menu_screens/insects_prediction/insect_control_method_post.dart';
import 'package:govimithura/widgets/expandable_post.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';

class InsectsControlMethodsScreen extends StatefulWidget {
  const InsectsControlMethodsScreen({super.key});

  @override
  State<InsectsControlMethodsScreen> createState() =>
      _InsectsControlMethodsScreenState();
}

class _InsectsControlMethodsScreenState
    extends State<InsectsControlMethodsScreen> {
  bool isBookMarked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Pest Control Methods'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                  spacingWidget(10, SpaceDirection.horizontal),
                  Flexible(
                      child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        SlidePageRoute(page: const InsectControlMethodPost()),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Write a Method...',
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            ...List.generate(
              5,
              (index) => ExpandablePost(index: index),
            ),
          ],
        ),
      ),
    );
  }
}
