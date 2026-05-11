import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/Bloc/SelectRoute_State.dart';
import 'package:second/Bloc/selectRoute_Cubit.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Notfication_Cubit.dart';
import 'package:second/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    context.read<SelectRoute>().getNotifications();

    context.read<NotificationCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(S.of(context).NotficationHistory),
        centerTitle: true,
      ),
      body: BlocBuilder<SelectRoute, RouteState>(
        builder: (context, state) {
          final cubit = context.read<SelectRoute>();

          /// 🔄 Loading
          if (state is NotificationLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// ❌ Error
          if (state is NotificationErrorState) {
            return Center(
              child: Text(
                S.of(context).NotFoundInNotifications,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          /// 📭 Empty
          if (cubit.notifications.isEmpty) {
            return const Center(
              child: Text("No Notifications Yet"),
            );
          }

          /// ✅ Success
          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getNotifications();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cubit.notifications.length,
              itemBuilder: (context, index) {
                final item = cubit.notifications[index];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔔 Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// 📄 Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// Message
                            Text(
                              item.message,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// Date
                            Text(
                              item.sendAt,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
