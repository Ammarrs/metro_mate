import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/profile_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _profileService;

  ProfileCubit(this._profileService) : super(ProfileInitial());

  // Load user profile from backend
  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      print('ProfileCubit: Loading profile...');

      final result = await _profileService.getProfile();
      print('ProfileCubit: Result success = ${result.success}');

      if (result.success && result.user != null) {
        print('ProfileCubit: Emitting ProfileLoaded');
        emit(ProfileLoaded(result.user!));
      } else {
        print('ProfileCubit: Emitting ProfileError');
        emit(ProfileError(result.message));
      }
    } catch (e) {
      print('ProfileCubit: Exception = $e');
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  // Upload new profile image
  Future<void> uploadProfileImage(String imagePath) async {
    try {
      emit(ProfileImageUploading());
      print('ProfileCubit: Uploading image from $imagePath');

      final result = await _profileService.updateProfileImage(imagePath);
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

  void reset() {
    emit(ProfileInitial());
  }
}