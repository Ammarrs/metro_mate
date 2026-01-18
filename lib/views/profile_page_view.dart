import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/services/profile_services.dart';

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
  final TextEditingController _photoUrlController = TextEditingController();

  @override
  void dispose() {
    _photoUrlController.dispose();
    super.dispose();
  }

  /// Shows a dialog to input a photo URL
  /// Since the API expects a URL string, not a file upload
  /// 
  /// For actual file upload from gallery, you would need to:
  /// 1. Pick image from gallery
  /// 2. Upload it to a storage service (e.g., Firebase Storage, AWS S3)
  /// 3. Get the URL from the storage service
  /// 4. Send that URL to the API
  Future<void> _showPhotoUrlDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter the URL of your new profile photo:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _photoUrlController,
                decoration: const InputDecoration(
                  hintText: 'https://example.com/photo.jpg',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 8),
              const Text(
                'Or use this sample URL for testing:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  _photoUrlController.text = 
                      'https://t4.ftcdn.net/jpg/09/64/89/19/360_F_964891988_aeRrD7Ee7IhmKQhYkCrkrfE6UHtILfPp.jpg';
                },
                child: const Text('Use Sample Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _photoUrlController.clear();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final url = _photoUrlController.text.trim();
                if (url.isNotEmpty) {
                  Navigator.of(context).pop();
                  // Update the photo with the URL
                  context.read<ProfileCubit>().uploadProfileImage(url);
                  _photoUrlController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid URL'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Synchronize profile data with global UserCubit
            // This ensures home app bar shows updated name and photo
            context.read<UserCubit>().setUser(state.user);
          } else if (state is ProfileImageUploaded) {
            // Update global user state with new image
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
            // Priority: Use ProfileLoaded state if available, otherwise fall back to UserCubit
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
              // Fall back to global UserCubit state
              final userState = context.watch<UserCubit>().state;
              if (userState is UserLoaded) {
                displayName = userState.user.name;
                displayEmail = userState.user.email;
                profileImageUrl = userState.user.profileImage;
              }
            }

            return Column(
              children: [
                // Header Section with Gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF4A6FA5), Color(0xFF5BC8E8)],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
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
                          const SizedBox(height: 24),
                          // Profile Info
                          Row(
                            children: [
                              GestureDetector(
                                onTap: profileState is ProfileImageUploading
                                    ? null
                                    : _showPhotoUrlDialog,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      backgroundImage: (profileImageUrl != null &&
                                              profileImageUrl.isNotEmpty)
                                          ? NetworkImage(profileImageUrl)
                                          : null,
                                      child: (profileImageUrl == null ||
                                              profileImageUrl.isEmpty)
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      displayEmail,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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
                // Loading Indicator
                if (profileState is ProfileLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  // Menu Items
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