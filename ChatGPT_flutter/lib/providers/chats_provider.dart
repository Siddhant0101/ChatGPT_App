import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> savedChats = []; // Add a variable to store the saved chats

  List<ChatModel> get getChatList {
    return chatList;
  }

  List<ChatModel> get getSavedChats {
    return savedChats; // Return the list of saved chats
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }

  void saveChat(ChatModel chat) {
    savedChats.add(chat); // Add a chat to the list of saved chats
    notifyListeners();
  }

  void removeChat(ChatModel chat) {
    savedChats.remove(chat); // Remove a chat from the list of saved chats
    notifyListeners();
  }

  void regenerateResponse() {
    // Check if there is a previous message from the bot
    if (chatList.isNotEmpty && chatList.last.chatIndex % 2 == 1) {
      final previousMessage = chatList.last;
      final regeneratedMessage = // Implement the logic to regenerate the response based on the previous message
          "Regenerated response";

      chatList.add(ChatModel(
          msg: regeneratedMessage, chatIndex: previousMessage.chatIndex + 1));
      notifyListeners();
    }
  }

  void continueGenerating() {
    // Check if there is a previous message from the bot
    if (chatList.isNotEmpty && chatList.last.chatIndex % 2 == 1) {
      final previousMessage = chatList.last;
      final continuedMessage = // Implement the logic to continue generating the response based on the previous message
          "Continued response";

      chatList.add(ChatModel(
          msg: continuedMessage, chatIndex: previousMessage.chatIndex + 1));
      notifyListeners();
    }
  }
}
