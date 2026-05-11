import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';
import '../cubits/user/user_cubit.dart';
import '../cubits/user/user_state.dart';

class HomeAppBar extends StatelessWidget {
  final String? greeting;
  final double balance;
  final int notificationCount;
  final VoidCallback? onDepositPressed;
  final VoidCallback? onNotificationPressed;

  const HomeAppBar({
    Key? key,
    this.greeting,
    this.balance = 150.50,
    this.notificationCount = 1,
    this.onDepositPressed,
    this.onNotificationPressed,
  }) : super(key: key);

  Widget _buildProfileImage(String? imageString, String displayName) {
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

    Widget fallbackCircle() => Center(
          child: Text(initial,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
        );

    if (imageString == null || imageString.isEmpty) return fallbackCircle();

    Widget imageWidget;

    if (imageString.startsWith('/')) {
      final file = File(imageString);
      if (!file.existsSync()) return fallbackCircle();
      imageWidget = Image.file(file,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackCircle());
    } else if (imageString.startsWith('data:image/')) {
      try {
        final Uint8List bytes = base64Decode(imageString.split(',').last);
        imageWidget = Image.memory(bytes,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallbackCircle());
      } catch (_) {
        return fallbackCircle();
      }
    } else {
      imageWidget = Image.network(imageString,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackCircle(),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : fallbackCircle());
    }

    return ClipOval(child: imageWidget);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;

    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.1,
        maxHeight: screenHeight * 0.15,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5B8FB9), Color(0xFF7AB8D9), Color(0xFF87CEEB)],
        ),
      ),
      padding: EdgeInsets.only(
        top: safeAreaTop + 20,
        left: screenWidth * 0.06,
        right: screenWidth * 0.06,
        bottom: 20,
      ),
      child: Column(
        children: [
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'Profile');
                      },
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          String? profileImageUrl;
                          String displayName = 'Guest';

                          if (state is UserLoaded) {
                            profileImageUrl = state.user.profileImage;
                            displayName = state.user.name;
                          }

                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: _buildProfileImage(
                                profileImageUrl, displayName),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    /// Greeting
                    Expanded(
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          String displayName = 'Guest';

                          if (state is UserLoaded) {
                            displayName = state.user.name;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting ?? s.WelcomeBack, // ✅ مترجمة
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// Notification
              GestureDetector(
                onTap: onNotificationPressed,
                child: Stack(
                  children: [
                    Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 28),
                    if (notificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Text(
                            notificationCount.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // SizedBox(height: screenHeight * 0.02),

          // /// Wallet
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: screenWidth * 0.04,
          //     vertical: 16,
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.25),
          //     borderRadius: BorderRadius.circular(16),
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Row(
          //           children: [
          //             // const Icon(Icons.account_balance_wallet_outlined,
          //             //     color: Colors.white),
          //             // const SizedBox(width: 16),
          //             // Column(
          //             //   crossAxisAlignment: CrossAxisAlignment.start,
          //             //   children: [
          //             //     Text(
          //             //       s.Wallet, // ✅ مترجمة
          //             //       style: const TextStyle(color: Colors.white70),
          //             //     ),
          //             //     Text(
          //             //       '${s.EGP} ${balance.toStringAsFixed(2)}',
          //             //       style: const TextStyle(
          //             //           color: Colors.white,
          //             //           fontSize: 18,
          //             //           fontWeight: FontWeight.bold),
          //             //     ),
          //             //   ],
          //             // ),
          //           ],
          //         ),
          //       ),
          //       // TextButton(
          //       //   onPressed: onDepositPressed,
          //       //   child: Text(
          //       //     s.payButton, // ✅ مترجمة
          //       //     style: const TextStyle(color: Colors.white),
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
