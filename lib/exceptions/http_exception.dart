class HttpExceptionApplication implements Exception {
  final String msg;
  final int statusCode;

  HttpExceptionApplication({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
