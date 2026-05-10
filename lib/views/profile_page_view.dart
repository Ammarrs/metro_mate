import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';
import 'package:second/services/profile_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import '../cubits/profile/profile_cubit.dart';
import '../cubits/profile/profile_state.dart';
import '../cubits/user/user_cubit.dart';
import '../cubits/user/user_state.dart';
import 'settings.dart';

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

  // Handles: local file path, base64 data URI (old), or remote URL
  // Uses Stack+ClipOval instead of CircleAvatar.backgroundImage
  // so the fallback letter always shows on error
  Widget _buildProfileImage(String? imageString, String displayName) {
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

    Widget fallbackCircle() => Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(initial,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w500)),
          ),
        );

    if (imageString == null || imageString.isEmpty) return fallbackCircle();

    Widget imageWidget;

    // Local file path
    if (imageString.startsWith('/')) {
      final file = File(imageString);
      if (!file.existsSync()) return fallbackCircle();
      imageWidget = Image.file(file,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackCircle());
    }
    // Old base64 data URI
    else if (imageString.startsWith('data:image/')) {
      try {
        final bytes = base64Decode(imageString.split(',').last);
        imageWidget = Image.memory(bytes,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallbackCircle());
      } catch (_) {
        return fallbackCircle();
      }
    }
    // Remote URL
    else {
      imageWidget = Image.network(imageString,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackCircle(),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : fallbackCircle());
    }

    return ClipOval(child: imageWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ── Image picking ──────────────────────────────────────────────────────────

  /// Pick image from gallery and upload as multipart (no base64)
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 60,
      );
      if (image != null && mounted) {
        context.read<ProfileCubit>().uploadProfileImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${S.of(context).errorPickingImage}: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 60,
      );
      if (image != null && mounted) {
        context.read<ProfileCubit>().uploadProfileImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${S.of(context).errorTakingPhoto}: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

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
                Text(
                  S.of(context).chooseProfilePhoto,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading:
                      const Icon(Icons.photo_library, color: Color(0xFF4A6FA5)),
                  title: Text(S.of(context).chooseFromGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.camera_alt, color: Color(0xFF4A6FA5)),
                  title: Text(S.of(context).takePhoto),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.grey),
                  title: Text(S.of(context).cancel),
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Sync fresh profile data to global UserCubit
            context.read<UserCubit>().setUser(state.user);
          } else if (state is ProfileImageUploaded) {
            // Use setUser — NOT updateProfileImage (which would re-trigger upload)
            context.read<UserCubit>().setUser(state.user);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.current.profileUpdated),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileNameUpdating) {
            // Sync the still-current user to UserCubit while the update is in flight
            context.read<UserCubit>().setUser(state.user);
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
            } else if (profileState is ProfileNameUpdating) {
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
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Title
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).profile,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  S.current.manageAccount,
                                  style: const TextStyle(
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
                                    _buildProfileImage(
                                        profileImageUrl, displayName),
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
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: profileState
                                                is ProfileImageUploading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
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
                                    // ── Name row with pen edit indicator ──
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: profileState is ProfileNameUpdating
                                              // While saving: dim name + spinner
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(
                                                      width: 14,
                                                      height: 14,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        displayName,
                                                        style: const TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              // Normal: full-brightness name
                                              : Text(
                                                  displayName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                        ),
                                        // Pen icon — hidden while update is in flight
                                        if (profileState is! ProfileNameUpdating)
                                          GestureDetector(
                                            onTap: () =>
                                                _showEditNameDialog(context, displayName),
                                            child: const Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white70,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                      ],
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
                                  title: S.of(context).settingsPrivacy,
                                  onTap: () => Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(MaterialPageRoute(
                                    builder: (_) => const SettingsPage(),
                                  )),
                                ),
                                const Divider(height: 1),
                                _buildMenuItem(
                                  icon: Icons.logout,
                                  title: S.of(context).signOut,
                                  titleColor: Colors.red,
                                  iconColor: Colors.red,
                                  onTap: () async {
                                    await context.read<UserCubit>().logout();
                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        'loginPage',
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

  /// Shows a dialog that lets the user edit their display name.
  /// Calls [ProfileCubit.updateUsername] on confirm.
  Future<void> _showEditNameDialog(
      BuildContext context, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Edit Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                prefixIcon:
                    const Icon(Icons.person_outline, color: Color(0xFF4A6FA5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF4A6FA5), width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name cannot be empty';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6FA5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newName = controller.text.trim();
                  Navigator.pop(dialogContext);
                  // Only call API if the name actually changed
                  if (newName != currentName) {
                    context.read<ProfileCubit>().updateUsername(newName);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
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