import 'package:flutter/material.dart';
import 'package:govimithura/widgets/expandable_post.dart';

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
          children: List.generate(
            5,
            (index) => ExpandablePost(index: index),
          ),
        ),
      ),
    );
  }
}
