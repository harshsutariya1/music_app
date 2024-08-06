class AppFailure {
  final String message;

  AppFailure([this.message = "Sorry, an unexpencted error occured!"]);

  @override
  String toString() => 'AppFailure(message: $message)';
}
