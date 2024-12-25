import 'package:santai/app/domain/entities/chat/chat_contact.dart';
import 'package:santai/app/domain/repository/chat/chat_repository.dart';

class GetChatContactsByUserId {
  final ChatRepository repository;

  GetChatContactsByUserId(this.repository);
  Future<List<ChatContact>?> call() async {
    try {
      return await repository.getUserByUserType();
    } catch (e) {
      rethrow;
    }
  }
}
