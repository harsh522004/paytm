import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paytm/models/user_model.dart';

final userDataProvider = StateProvider<UserModel?>((ref) => null);
final accountDataProvider = StateProvider<AccountModel?>((ref) => null);
final userListProvider = StateProvider<List<UserModel>?>((ref) => null);
