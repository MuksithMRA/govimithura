class ChatResponse {
  ChatStatus status;
  String message;
  bool isResponse;

  ChatResponse({
    this.status = ChatStatus.success,
    this.message = "",
    this.isResponse = true,
  });
}

enum ChatStatus { success, error, typing }
