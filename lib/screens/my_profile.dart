import 'package:flutter/material.dart';
import 'package:govimithura/models/user_model.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/providers/storage_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:govimithura/widgets/drawer_widget.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/field_editor.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: pAuthentication.getCurentUserModel(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
                                snapshot.data!.profilePic,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: FloatingActionButton(
                                heroTag: 'add_profile_pic',
                                mini: true,
                                elevation: 0,
                                onPressed: () async {
                                  await Utils.pickImage(ImageSource.camera,
                                      const Size(100, 100), context);
                                  if (mounted) {
                                    String? profileUrl =
                                        await LoadingOverlay.of(context).during(
                                            context
                                                .read<StorageProvider>()
                                                .uploadImage(context));
                                    if (profileUrl != null) {
                                      await pAuthentication.updateSingleField(
                                          "profilePic", profileUrl);
                                    }
                                  }
                                },
                                child: const Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        ),
                        spacingWidget(20, SpaceDirection.horizontal),
                        Flexible(
                          child: Text(
                            '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
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
                          subtitle: Text(snapshot.data!.firstName),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => FieldEditor(
                                        title: 'First Name',
                                        text: snapshot.data!.firstName,
                                      ));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_2_rounded),
                          title: const Text('Last Name'),
                          subtitle: Text(snapshot.data!.lastName),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => FieldEditor(
                                  title: 'Last Name',
                                  text: snapshot.data!.lastName,
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email_rounded),
                          title: const Text('Email'),
                          subtitle: Text(snapshot.data!.authModel!.email),
                          trailing: const IconButton(
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
}
