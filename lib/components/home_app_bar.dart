import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String greeting;
  final String userName;
  final double balance;
  final int notificationCount;
  final VoidCallback? onDepositPressed;
  final VoidCallback? onNotificationPressed;

  const HomeAppBar({
    Key? key,
    this.greeting = 'Good afternoon!',
    this.userName = 'ammar',
    this.balance = 150.50,
    this.notificationCount = 1,
    this.onDepositPressed,
    this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5B8FB9), Color(0xFF7AB8D9), Color(0xFF87CEEB)],
        ),
      ),
      padding: const EdgeInsets.only(top: 85.0, left: 30.0, right: 30.0),
      child: Column(
        children: [
          // Header with profile and notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'Profile');
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onNotificationPressed,
                child: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            notificationCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Wallet Balance Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Wallet Balance',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'EGP ${balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onDepositPressed,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text(
                    'Deposit Money',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// // Example usage:
// class ExampleScreen extends StatelessWidget {
//   const ExampleScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             TransitHeaderComponent(
//               greeting: 'Good afternoon!',
//               userName: 'ammar',
//               balance: 150.50,
//               notificationCount: 1,
//               onDepositPressed: () {
//                 print('Deposit pressed');
//               },
//               onNotificationPressed: () {
//                 print('Notification pressed');
//               },
//             ),
//             Expanded(
//               child: Container(
//                 color: Colors.white,
//                 child: const Center(
//                   child: Text('Rest of your content here'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
