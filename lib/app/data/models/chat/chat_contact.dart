import 'package:santai/app/core/base_response.dart';
import 'package:santai/app/domain/entities/chat/chat_contact.dart';

class ChatContactResponseModel extends BaseResponse<List<ChatContact>> {
  ChatContactResponseModel({
    required super.isSuccess,
    required List<ChatContactResponseDataModel> super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
    super.next,
  });

  factory ChatContactResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatContactResponseModel(
      isSuccess: json['isSuccess'],
      data: (json['data'] as List)
          .map((item) => ChatContactResponseDataModel.fromJson(item))
          .toList(),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
      next: json['next'],
    );
  }
}

class ChatContactResponseDataModel extends ChatContact {
  ChatContactResponseDataModel({
    required super.orderId,
    required super.lastChatTimestamp,
    required super.buyerId,
    required super.buyerName,
    required super.buyerImageUrl,
    super.mechanicId,
    super.mechanicName,
    super.mechanicImageUrl,
    super.lastChatText,
    super.chatOriginUserId,
    super.orderCompletedAtUtc,
    super.orderChatExpiredAtUtc,
    super.isOrderCompleted,
    required super.chatUpdateTimestamp,
    super.isChatExpired,
  });

  factory ChatContactResponseDataModel.fromJson(Map<String, dynamic> json) {
    return ChatContactResponseDataModel(
      orderId: json['orderId'],
      lastChatTimestamp: json['lastChatTimestamp'],
      buyerId: json['buyerId'],
      buyerName: json['buyerName'],
      buyerImageUrl: json['buyerImageUrl'],
      mechanicId: json['mechanicId'],
      mechanicName: json['mechanicName'],
      mechanicImageUrl: json['mechanicImageUrl'],
      lastChatText: json['lastChatText'],
      chatOriginUserId: json['chatOriginUserId'],
      orderCompletedAtUtc: json['orderCompletedAtUtc'] != null &&
              json['orderCompletedAtUtc'] != ''
          ? DateTime.parse(json['orderCompletedAtUtc'])
          : null,
      orderChatExpiredAtUtc: json['orderChatExpiredAtUtc'] != null &&
              json['orderChatExpiredAtUtc'] != ''
          ? DateTime.parse(json['orderChatExpiredAtUtc'])
          : null,
      isOrderCompleted: json['isOrderCompleted'] ?? false,
      chatUpdateTimestamp: json['chatUpdateTimestamp'],
      isChatExpired: json['isChatExpired'] ?? false,
    );
  }
}
