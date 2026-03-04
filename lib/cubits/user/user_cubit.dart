import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart';
import '../../services/profile_services.dart'; // NEW: Import ProfileService
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final StorageService _storageService;
  final ProfileService _profileService = ProfileService(); // NEW: Add ProfileService

  UserCubit(this._storageService) : super(UserInitial());

  /// Loads user data from cache first, then fetches from backend
  /// This provides instant UI updates with cached data
  Future<void> loadUser() async {
    try {
      print('UserCubit: Loading user...');
      
      // STEP 1: Load from cache first (instant display - no loading state)
      final userData = await _storageService.getUserData();
      if (userData != null) {
        print('UserCubit: Found cached data');
        final cachedUser = User(
          id: userData['id']!,
          email: userData['email']!,
          name: userData['name']!,
          profileImage: userData['profileImage'],
        );
        // Emit cached data immediately for instant display
        emit(UserLoaded(cachedUser));
      }

      // STEP 2: Fetch fresh data from backend
      print('UserCubit: Fetching fresh data from API...');
      final result = await _profileService.getProfile();
      
      if (result.success && result.user != null) {
        print('UserCubit: Fresh data loaded successfully');
        print('UserCubit: Profile image = ${result.user!.profileImage}');
        
        // Update with fresh data from API
        emit(UserLoaded(result.user!));
      } else if (userData == null) {
        // Only show error if we don't have cached data
        print('UserCubit: No cached data and API failed');
        emit(UserLoggedOut());
      }
      // If we have cached data but API fails, keep showing cached data
      
    } catch (e) {
      print('UserCubit: Exception = $e');
      // Only emit error if we don't have any data loaded
      if (state is! UserLoaded) {
        emit(UserError("Failed to load user data: $e"));
      }
    }
  }

  /// Sets user data directly (useful after login)
  void setUser(User user) {
    emit(UserLoaded(user));
  }

  /// Updates only the profile image
  /// This is called when user updates their profile photo
  Future<void> updateProfileImage(String imageUrl) async {
    try {
      print('UserCubit: Updating profile image to: $imageUrl');
      
      // Call backend API to update profile image
      final result = await _profileService.updateProfileImage(imageUrl);
      
      if (result.success && result.user != null) {
        print('UserCubit: Profile image updated successfully');
        emit(UserLoaded(result.user!));
      } else {
        print('UserCubit: Failed to update profile image');
        // If API update fails but we have current user, just update locally
        if (state is UserLoaded) {
          final currentUser = (state as UserLoaded).user;
          // Use nullable parameter to allow setting null
          final updatedUser = User(
            id: currentUser.id,
            email: currentUser.email,
            name: currentUser.name,
            profileImage: imageUrl,
          );
          emit(UserLoaded(updatedUser));
          
          // Save to cache
          await _storageService.saveProfileImage(imageUrl);
        }
      }
    } catch (e) {
      print('UserCubit: Exception updating profile image = $e');
      
      // Fallback: Update locally even if API fails
      if (state is UserLoaded) {
        final currentUser = (state as UserLoaded).user;
        final updatedUser = User(
          id: currentUser.id,
          email: currentUser.email,
          name: currentUser.name,
          profileImage: imageUrl,
        );
        emit(UserLoaded(updatedUser));
        await _storageService.saveProfileImage(imageUrl);
      }
    }
  }

  /// Logout user and clear all data
  Future<void> logout() async {
    try {
      await _storageService.clearAll();
      emit(UserLoggedOut());
    } catch (e) {
      emit(UserError("Failed to logout: $e"));
    }
  }

  /// Get current user object (null if not logged in)
  User? get currentUser {
    if (state is UserLoaded) {
      return (state as UserLoaded).user;
    }
    return null;
  }

  /// Get user name (returns "Guest" if not logged in)
  String get userName {
    if (state is UserLoaded) {
      return (state as UserLoaded).user.name;
    }
    return "Guest";
  }

  /// Get profile image URL (null if not available)
  String? get profileImageUrl {
    if (state is UserLoaded) {
      return (state as UserLoaded).user.profileImage;
    }
    return null;
  }
}