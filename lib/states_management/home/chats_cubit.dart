import 'package:bloc/bloc.dart';
import 'package:labalaba/models/chat.dart';
import 'package:labalaba/viewmodels/chats_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel viewModel;
  ChatsCubit(this.viewModel) : super([]);

  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}
