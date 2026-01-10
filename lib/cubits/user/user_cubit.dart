import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final StorageService _storageService;

  UserCubit(this._storageService) : super(UserInitial());

  Future<void> loadUser() async {
    try {
      emit(UserLoading());
      final userData = await _storageService.getUserData();

      if (userData != null) {
        final user = User(
          id: userData['id']!,
          email: userData['email']!,
          name: userData['name']!,
        );
        emit(UserLoaded(user));
      } else {
        emit(UserLoggedOut());
      }
    } catch (e) {
      emit(UserError("Faild to load user data: $e"));
    }
  }

  void setUser(User user) {
    emit(UserLoaded(user));
  }

  Future<void> logout() async {
    try {
      await _storageService.clearAll();
      emit(UserLoggedOut());
    } catch (e) {
      emit(UserError("Faild to logout: $e"));
    }
  }

  User? get currentUser {
    if (state is UserLoaded) {
      return (state as UserLoaded).user;
    }
    return null;
  }

  String get userName {
    if (state is UserLoaded) {
      return (state as UserLoaded).user.name;
    }
    return "Guest";
  }
}
