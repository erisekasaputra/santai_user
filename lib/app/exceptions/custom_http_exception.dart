class CustomHttpException implements Exception {
  final int statusCode;
  final String message;

  CustomHttpException(this.statusCode, this.message);

  @override
  String toString() => 'CustomHttpException: [$statusCode] $message';
}