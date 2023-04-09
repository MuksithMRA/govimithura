import 'package:flutter/material.dart';
import 'package:govimithura/models/chat_response.dart';
import 'package:govimithura/providers/ml_provider.dart';
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';
import 'package:provider/provider.dart';
import '../../utils/screen_size.dart';
import '../../widgets/utils/common_widget.dart';
import '../../widgets/utils/image_util.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: ScreenSize.height -
                (ScreenSize.appBarHeight + ScreenSize.height * 0.12),
            width: ScreenSize.width,
            color: Theme.of(context).primaryColor,
            child: Column(
              children: const [
                CustomAssetImage(assetName: "chat_bots_home.png")
              ],
            ),
          ),
          Positioned(
            top: ScreenSize.height * 0.12,
            height: ScreenSize.height * 0.715,
            width: ScreenSize.width,
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
                              icon: const Icon(Icons.settings,
                                  color: Colors.black)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Consumer<MLProvider>(
                    builder: (context, pML, child) {
                      return Column(
                        children: [
                          SizedBox(
                            height: ScreenSize.height * 0.55,
                            width: ScreenSize.width,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  pML.chatResponses.length,
                                  (index) => _chatBubble(
                                    pML.chatResponses[index],
                                    context,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: PrimaryTextField(
                                  onChanged: (value) {
                                    pML.setMessgeText(value.trim());
                                  },
                                  hintText: "Type a message",
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
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
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
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/user.png"),
            ),
          if (chat.isResponse) spacingWidget(10, SpaceDirection.horizontal),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
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
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/user.png"),
            ),
        ],
      ),
    );
  }
}
