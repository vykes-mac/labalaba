import 'package:chat/chat.dart';
import 'package:labalaba/data/datasources/datasource_contract.dart';
import 'package:labalaba/models/chat.dart';
import 'package:labalaba/models/local_message.dart';
import 'package:labalaba/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;
  IUserService _userService;

  ChatsViewModel(this._datasource, this._userService) : super(_datasource);

  Future<List<Chat>> getChats() async {
    final chats = await _datasource.findAllChats();
    await Future.forEach(chats, (Chat chat) async {
      final ids = chat.membersId.map<String>((e) => e.keys.first).toList();
      final users = await _userService.fetch(ids);
      chat.members = users;
    });

    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    final chatId = message.groupId != null ? message.groupId : message.from;
    LocalMessage localMessage =
        LocalMessage(chatId, message, ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}
