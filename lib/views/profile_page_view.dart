import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/services/profile_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import '../cubits/profile/profile_cubit.dart';
import '../cubits/profile/profile_state.dart';
import '../cubits/user/user_cubit.dart';
import '../cubits/user/user_state.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileService())..loadProfile(),
      child: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
  }

  // KEY CHANGE: Helper function to check if string is base64 data URI
  bool _isBase64DataUri(String? imageString) {
    if (imageString == null || imageString.isEmpty) return false;
    return imageString.startsWith('data:image/');
  }

  // KEY CHANGE: Helper function to decode base64 data URI to bytes
  Uint8List? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    
    try {
      // Check if it's a data URI (data:image/jpeg;base64,...)
      if (base64String.startsWith('data:image/')) {
        // Extract the base64 part after the comma
        final base64Data = base64String.split(',').last;
        return base64Decode(base64Data);
      }
      // If it's just base64 without the data URI prefix
      return base64Decode(base64String);
    } catch (e) {
      print('Error decoding base64 image: $e');
      return null;
    }
  }

  /// Pick image from gallery and convert to base64 string
  Future<void> _pickImageFromGallery() async {
    try {
      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85, // Compress image to reduce size
      );

      if (image != null) {
        // Read image as bytes
        final bytes = await image.readAsBytes();
        
        // Convert to base64 string
        final base64String = base64Encode(bytes);
        
        // Create data URI with image type
        final imageExtension = image.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';
        
        if (imageExtension == 'png') {
          mimeType = 'image/png';
        } else if (imageExtension == 'jpg' || imageExtension == 'jpeg') {
          mimeType = 'image/jpeg';
        }
        
        // Format: data:image/jpeg;base64,/9j/4AAQSkZJRg...
        final base64Image = 'data:$mimeType;base64,$base64String';
        
        // Upload to backend (backend should store this string and return URL)
        if (mounted) {
          context.read<ProfileCubit>().uploadProfileImage(base64Image);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show options: Gallery or Camera
  Future<void> _showImageSourceOptions() async {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFF4A6FA5)),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Color(0xFF4A6FA5)),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.grey),
                  title: const Text('Cancel'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        final base64Image = 'data:image/jpeg;base64,$base64String';
        
        if (mounted) {
          context.read<ProfileCubit>().uploadProfileImage(base64Image);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Synchronize profile data with global UserCubit
            context.read<UserCubit>().setUser(state.user);
          } else if (state is ProfileImageUploaded) {
            // Update global user state with new image URL from backend
            context.read<UserCubit>().updateProfileImage(
              state.user.profileImage ?? '',
            );
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile image updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            String displayName = 'Guest';
            String displayEmail = '';
            String? profileImageUrl;

            if (profileState is ProfileLoaded) {
              displayName = profileState.user.name;
              displayEmail = profileState.user.email;
              profileImageUrl = profileState.user.profileImage;
            } else if (profileState is ProfileImageUploaded) {
              displayName = profileState.user.name;
              displayEmail = profileState.user.email;
              profileImageUrl = profileState.user.profileImage;
            } else {
              final userState = context.watch<UserCubit>().state;
              if (userState is UserLoaded) {
                displayName = userState.user.name;
                displayEmail = userState.user.email;
                profileImageUrl = userState.user.profileImage;
              }
            }

            // KEY CHANGE: Decode base64 image if needed
            final isBase64 = _isBase64DataUri(profileImageUrl);
            final imageBytes = isBase64 ? _decodeBase64Image(profileImageUrl) : null;

            return Column(
              children: [
                // Header Section with Gradient
                Container(
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.28,
                    maxHeight: screenHeight * 0.35,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF4A6FA5), Color(0xFF5BC8E8)],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Title
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Manage your account',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.02),
                          
                          // Profile Info
                          Row(
                            children: [
                              // KEY CHANGE: Profile Image with Base64 support
                              GestureDetector(
                                onTap: profileState is ProfileImageUploading
                                    ? null
                                    : _showImageSourceOptions,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      // KEY CHANGE: Use MemoryImage for base64, NetworkImage for URLs
                                      backgroundImage: isBase64 && imageBytes != null
                                          ? MemoryImage(imageBytes) as ImageProvider
                                          : (profileImageUrl != null && profileImageUrl.isNotEmpty && !isBase64)
                                              ? NetworkImage(profileImageUrl)
                                              : null,
                                      child: (profileImageUrl == null || 
                                              profileImageUrl.isEmpty ||
                                              (isBase64 && imageBytes == null))
                                          ? Text(
                                              displayName.isNotEmpty
                                                  ? displayName[0].toUpperCase()
                                                  : 'G',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: profileState is ProfileImageUploading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xFF4A6FA5),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.camera_alt,
                                                size: 16,
                                                color: Color(0xFF4A6FA5),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Name and Email - With overflow protection
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      displayEmail,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // KEY CHANGE: Removed loading indicator check
                // Menu Items - Always visible
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildMenuItem(
                                  icon: Icons.settings_outlined,
                                  title: 'Settings & Privacy',
                                  onTap: () {},
                                ),
                                const Divider(height: 1),
                                _buildMenuItem(
                                  icon: Icons.logout,
                                  title: 'Sign Out',
                                  titleColor: Colors.red,
                                  iconColor: Colors.red,
                                  onTap: () async {
                                    await context.read<UserCubit>().logout();
                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        'Login',
                                        (route) => false,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.grey[600], size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: titleColor ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (titleColor == null)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}