import 'package:flutter_gram/resources/auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User get getUser => _user!;
  final AuthMethod _authMethod = AuthMethod();

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
