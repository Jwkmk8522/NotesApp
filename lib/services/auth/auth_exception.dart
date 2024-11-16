//login view
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Regestr view
class WeakPasswordAuthException implements Exception {}

class EmailAlredyInUseAuthException implements Exception {}

// Generic auth exception
class GenericAuthException implements Exception {}

class UserNotLogedinUserAuthException implements Exception {}
