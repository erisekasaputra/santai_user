class OrderActiveResponse {
  final bool isSuccess;
  final List<OrderActiveResponseData> data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;
  final dynamic next;

  OrderActiveResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
    this.next,
  });
}

class OrderActiveResponseData {
  String id;
  String secret;
  String status;
  int step;
  List<String> statuses;

  OrderActiveResponseData({
    required this.id,
    required this.secret,
    required this.status,
    required this.step,
    required this.statuses,
  });
}
