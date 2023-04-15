import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/providers/storage_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:govimithura/widgets/drawer_widget.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../constants/images.dart';
import '../widgets/field_editor.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late AuthenticationProvider pAuthentication;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late PersistentBottomSheetController _bottomSheetController;

  @override
  void initState() {
    super.initState();
    pAuthentication =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(pAuthentication.getCurrentUser()?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data()!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(70),
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        spacingWidget(20, SpaceDirection.horizontal),
                        Stack(
                          children: [
                            CircleAvatar(
                              onBackgroundImageError: (exception, stackTrace) =>
                                  Utils.showSnackBar(
                                      context, 'Error loading image'),
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  data['profilePic'] ?? Images.defaultAvatar),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: FloatingActionButton(
                                heroTag: 'add_profile_pic',
                                mini: true,
                                elevation: 0,
                                onPressed: () async {
                                  bool isOpen = pAuthentication.isOpen;
                                  if (!isOpen) {
                                    _bottomSheetController =
                                        _key.currentState!.showBottomSheet(
                                      (_) => selectImageAddingSource(),
                                    );
                                  } else {
                                    _bottomSheetController.close();
                                  }
                                  pAuthentication.setIsOpen(!isOpen);
                                },
                                child: const Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        ),
                        spacingWidget(20, SpaceDirection.horizontal),
                        Flexible(
                          child: Text(
                            '${data['first_name']} ${data['last_name']}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                spacingWidget(20, SpaceDirection.vertical),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(70),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_rounded),
                          title: const Text('First Name'),
                          subtitle: Text(data['first_name']),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => FieldEditor(
                                        title: 'First Name',
                                        text: data['first_name'],
                                      ));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_2_rounded),
                          title: const Text('Last Name'),
                          subtitle: Text(data['last_name']),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => FieldEditor(
                                  title: 'Last Name',
                                  text: data['last_name'],
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email_rounded),
                          title: const Text('Email'),
                          subtitle: Text(data['email']),
                          trailing: const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.lock),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(Icons.password_rounded),
                          title: Text('Password'),
                          subtitle: Text("********"),
                          trailing: IconButton(
                            onPressed: null,
                            icon: Icon(Icons.lock),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget selectImageAddingSource() {
    return SizedBox(
      width: ScreenSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Upload or take a picture"),
            trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close_rounded)),
          ),
          ListTile(
            onTap: () async {
              await addProfilePic(ImageSource.camera);
              if (mounted) {
                _bottomSheetController.close();
              }
            },
            leading: const Icon(Icons.camera_rounded),
            title: const Text("Take a picture"),
          ),
          ListTile(
            onTap: () async {
              await addProfilePic(ImageSource.gallery);
              if (mounted) {
                _bottomSheetController.close();
              }
            },
            leading: const Icon(Icons.photo_rounded),
            title: const Text("Upload from gallery"),
          ),
        ],
      ),
    );
  }

  addProfilePic(ImageSource imageSource) async {
    LoadingOverlay overlay = LoadingOverlay.of(context);
    await Utils.pickImage(imageSource, const Size(100, 100), context);
    if (mounted) {
      String? profileUrl = await overlay
          .during(context.read<StorageProvider>().uploadImage(context));
      if (profileUrl != null) {
        await overlay.during(
            pAuthentication.updateSingleField("profilePic", profileUrl));
      }
    }
  }
}
