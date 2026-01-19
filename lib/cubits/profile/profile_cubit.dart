import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/profile_services.dart';
import '../../services/storage_service.dart';
import '../../models/user_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _profileService;
  final StorageService _storageService = StorageService();

  ProfileCubit(this._profileService) : super(ProfileInitial());

  /// Loads the user profile from the backend
  /// 
  /// KEY CHANGE: Load cached data first (no loading state), then refresh from API
  /// This prevents the loading indicator from showing on page entry
  /// 
  /// Flow:
  /// 1. Load cached data from storage immediately (ProfileLoaded)
  /// 2. Fetch fresh data from API in the background
  /// 3. Update state with fresh data when available
  Future<void> loadProfile() async {
    try {
      print('ProfileCubit: Loading profile...');

      // KEY CHANGE: Try to load from cache first - NO LOADING STATE
      final cachedData = await _storageService.getUserData();
      if (cachedData != null) {
        print('ProfileCubit: Using cached data');
        final cachedUser = User(
          id: cachedData['id'] ?? '',
          email: cachedData['email'] ?? '',
          name: cachedData['name'] ?? '',
          profileImage: cachedData['profileImage'],
        );
        // Emit cached data immediately - page shows instantly
        emit(ProfileLoaded(cachedUser));
      }

      // Now fetch fresh data in the background (no loading state emitted)
      print('ProfileCubit: Fetching fresh data from API...');
      final result = await _profileService.getProfile();
      print('ProfileCubit: Result success = ${result.success}');

      if (result.success && result.user != null) {
        print('ProfileCubit: Emitting ProfileLoaded with fresh data');
        // Update with fresh data from API
        emit(ProfileLoaded(result.user!));
      } else if (cachedData == null) {
        // Only show error if we don't have cached data
        print('ProfileCubit: Emitting ProfileError');
        emit(ProfileError(result.message));
      }
      // If we have cached data but API fails, keep showing cached data
    } catch (e) {
      print('ProfileCubit: Exception = $e');
      // Only emit error if we don't have any data loaded
      if (state is! ProfileLoaded) {
        emit(ProfileError('Failed to load profile: $e'));
      }
    }
  }

  /// Updates the profile image with a new photo URL
  /// 
  /// Note: The API expects a photo URL string, not a file path
  /// If you're uploading from gallery, you'll need to upload the file
  /// to a storage service first and get the URL
  /// 
  /// @param photoUrl: The URL of the new profile photo
  /// 
  /// Flow:
  /// 1. Emit ProfileImageUploading state (shows loading indicator)
  /// 2. Call ProfileService.updateProfileImage() with the photo URL
  /// 3. If successful, emit ProfileImageUploaded (shows success message)
  /// 4. After 500ms, transition to ProfileLoaded with updated user data
  /// 5. If failed, emit ProfileError
  Future<void> uploadProfileImage(String photoUrl) async {
    try {
      emit(ProfileImageUploading());
      print('ProfileCubit: Uploading image: $photoUrl');

      final result = await _profileService.updateProfileImage(photoUrl);
      print('ProfileCubit: Upload result = ${result.success}');

      if (result.success && result.user != null) {
        print('ProfileCubit: Image uploaded successfully');
        emit(ProfileImageUploaded(result.user!));
        
        // After a short delay, transition back to ProfileLoaded
        await Future.delayed(const Duration(milliseconds: 500));
        emit(ProfileLoaded(result.user!));
      } else {
        print('ProfileCubit: Upload failed');
        emit(ProfileError(result.message));
      }
    } catch (e) {
      print('ProfileCubit: Upload exception = $e');
      emit(ProfileError('Failed to upload image: $e'));
    }
  }

  /// Resets the profile state to initial
  /// Useful when logging out or navigating away from profile
  void reset() {
    emit(ProfileInitial());
  }
}