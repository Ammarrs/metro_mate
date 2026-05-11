import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second/generated/l10n.dart';
import 'package:second/services/profile_services.dart';

import '../cubits/profile/profile_cubit.dart';
import '../cubits/profile/profile_state.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/user/user_cubit.dart';
import '../cubits/user/user_state.dart';
import '../components/app_preference_card.dart';
import '../components/security_privacy_card.dart';
import '../components/account_card.dart';
import '../components/help_support_card.dart';
import '../components/about_card.dart';
import '../components/settings_card.dart'; // kPrimaryBlue, kCardMaxWidth

// ─────────────────────────────────────────────────────────────────────────────
// Entry point — provides both cubits
// ─────────────────────────────────────────────────────────────────────────────
class ProfileSettingsPageView extends StatelessWidget {
  const ProfileSettingsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileCubit(ProfileService())..loadProfile(),
        ),
        BlocProvider(create: (_) => SettingsCubit()),
      ],
      child: const _ProfileSettingsPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main page
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileSettingsPage extends StatefulWidget {
  const _ProfileSettingsPage();

  @override
  State<_ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<_ProfileSettingsPage> {
  final ImagePicker _picker = ImagePicker();

  // ── Image rendering ────────────────────────────────────────────────────────
  Widget _buildProfileImage(String? imageString, String displayName) {
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

    Widget fallback() => Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54, width: 2),
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

    if (imageString == null || imageString.isEmpty) return fallback();

    Widget imageWidget;

    if (imageString.startsWith('/')) {
      final file = File(imageString);
      if (!file.existsSync()) return fallback();
      imageWidget = Image.file(file,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback());
    } else if (imageString.startsWith('data:image/')) {
      try {
        final Uint8List bytes = base64Decode(imageString.split(',').last);
        imageWidget = Image.memory(bytes,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback());
      } catch (_) {
        return fallback();
      }
    } else {
      imageWidget = Image.network(
        imageString,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : fallback(),
      );
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
      ),
      child: ClipOval(child: imageWidget),
    );
  }

  // ── Image picking ──────────────────────────────────────────────────────────
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
            backgroundColor: Colors.red,
          ),
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
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showImageSourceOptions() async {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).chooseProfilePhoto,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Color(0xFF5B8FB9)),
                title: Text(S.of(context).chooseFromGallery),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.camera_alt, color: Color(0xFF5B8FB9)),
                title: Text(S.of(context).takePhoto),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.grey),
                title: Text(S.of(context).cancel),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Edit name dialog ───────────────────────────────────────────────────────
  Future<void> _showEditNameDialog(
      BuildContext context, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Name',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              prefixIcon:
                  const Icon(Icons.person_outline, color: Color(0xFF5B8FB9)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF5B8FB9), width: 2),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name cannot be empty';
              if (v.trim().length < 2) return 'At least 2 characters';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B8FB9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newName = controller.text.trim();
                Navigator.pop(dialogCtx);
                if (newName != currentName) {
                  context.read<ProfileCubit>().updateUsername(newName);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> _handleLogout(BuildContext context) async {
    await context.read<UserCubit>().logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'loginPage',
        (route) => false,
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            context.read<UserCubit>().setUser(state.user);
          } else if (state is ProfileImageUploaded) {
            context.read<UserCubit>().setUser(state.user);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.current.profileUpdated),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileNameUpdating) {
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
            // ── Resolve display values ─────────────────────────────────
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

            return CustomScrollView(
              slivers: [
                // ── Collapsible gradient header ──────────────────────
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: const Color(0xFF5B8FB9),
                  // leading: IconButton(
                  //   icon: const Icon(Icons.arrow_back, color: Colors.white),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _ProfileHeader(
                      displayName: displayName,
                      displayEmail: displayEmail,
                      profileImageUrl: profileImageUrl,
                      profileState: profileState,
                      buildProfileImage: _buildProfileImage,
                      onImageTap: profileState is ProfileImageUploading
                          ? null
                          : _showImageSourceOptions,
                      onEditName: () =>
                          _showEditNameDialog(context, displayName),
                    ),
                  ),
                ),

                // ── Settings cards ───────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxWidth: kCardMaxWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Section label
                              const Text(
                                'Settings',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A2E3D),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 20),

                              const AppPreferencesCard(),
                              const SizedBox(height: 16),
                              const SecurityPrivacyCard(),
                              const SizedBox(height: 16),
                              const AccountCard(),
                              const SizedBox(height: 16),
                              const HelpSupportCard(),
                              const SizedBox(height: 16),
                              // ── Logout button ──────────────────────
                              _LogoutButton(
                                onTap: () => _handleLogout(context),
                              ),
                              const SizedBox(height: 24),
                              const AboutCard(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile header widget (inside SliverAppBar)
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final String displayName;
  final String displayEmail;
  final String? profileImageUrl;
  final ProfileState profileState;
  final Widget Function(String?, String) buildProfileImage;
  final VoidCallback? onImageTap;
  final VoidCallback onEditName;

  const _ProfileHeader({
    required this.displayName,
    required this.displayEmail,
    required this.profileImageUrl,
    required this.profileState,
    required this.buildProfileImage,
    required this.onImageTap,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A6FA5), Color(0xFF5BC8E8)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
          child: Row(
            children: [
              // ── Avatar ──────────────────────────────────────────────
              GestureDetector(
                onTap: onImageTap,
                child: Stack(
                  children: [
                    buildProfileImage(profileImageUrl, displayName),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: profileState is ProfileImageUploading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF5B8FB9),
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Color(0xFF5B8FB9),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 18),

              // ── Name & email ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: profileState is ProfileNameUpdating
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 13,
                                      height: 13,
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
                        // Edit pen icon
                        if (profileState is! ProfileNameUpdating)
                          GestureDetector(
                            onTap: onEditName,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white70,
                                size: 17,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Email
                    Text(
                      displayEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 8),

                    // "Tap photo to change" hint
                    Row(
                      children: const [
                        Icon(Icons.touch_app,
                            color: Colors.white38, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'Tap photo to change',
                          style:
                              TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logout button
// ─────────────────────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
                SizedBox(width: 10),
                Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}