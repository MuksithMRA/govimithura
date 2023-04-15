import 'package:flutter/material.dart';
import 'package:govimithura/constants/images.dart';
import 'package:govimithura/models/chat_response.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/providers/ml_provider.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../../widgets/utils/common_widget.dart';
import '../../widgets/utils/image_util.dart';
import '../../widgets/utils/text_fields/primary_textfield.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  double keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MLProvider>(
      builder: (context, pML, child) {
        return Stack(
          children: [
            Container(
              width: ScreenSize.width,
              color: Theme.of(context).primaryColor,
              child: Column(
                children: const [
                  CustomAssetImage(assetName: "chat_bots_home.png")
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: ScreenSize.width,
              height: ScreenSize.height * 0.84,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.width * 0.05,
                  vertical: ScreenSize.height * 0.02,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                height: ScreenSize.height * 0.75,
                width: ScreenSize.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Chats",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.info,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    spacingWidget(20, SpaceDirection.vertical),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: pML.chatResponses.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _chatBubble(
                                  pML.chatResponses[index],
                                  context,
                                );
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: PrimaryTextField(
                                  onTap: () {},
                                  controller: _messageController,
                                  hintText: "Type a message",
                                  onChanged: (value) =>
                                      pML.setMessgeText(value),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      _messageController.clear();
                                      await pML.replyChat();
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _chatBubble(ChatResponse chat, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
            !chat.isResponse ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (chat.isResponse)
            CircleAvatar(
              onBackgroundImageError: (exception, stackTrace) =>
                  Utils.showSnackBar(context, 'Error loading image'),
              backgroundColor: Theme.of(context).primaryColor,
              radius: 20,
              backgroundImage: const AssetImage(Images.logo),
            ),
          if (chat.isResponse) spacingWidget(10, SpaceDirection.horizontal),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: chat.status == ChatStatus.typing
                  ? null
                  : BoxDecoration(
                      color: !chat.isResponse
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: !chat.isResponse
                              ? const Radius.circular(20)
                              : const Radius.circular(0),
                          bottomRight: !chat.isResponse
                              ? const Radius.circular(0)
                              : const Radius.circular(20)),
                    ),
              child: Text(
                chat.message,
                style: TextStyle(
                  fontSize: 15,
                  color: !chat.isResponse ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (!chat.isResponse) spacingWidget(10, SpaceDirection.horizontal),
          if (!chat.isResponse)
            CircleAvatar(
                onBackgroundImageError: (exception, stackTrace) =>
                    Utils.showSnackBar(context, 'Error loading image'),
                backgroundColor: Theme.of(context).primaryColor,
                radius: 20,
                backgroundImage: NetworkImage(context
                        .read<AuthenticationProvider>()
                        .getCurrentUser()
                        ?.photoURL ??
                    Images.defaultAvatar)),
        ],
      ),
    );
  }
}
