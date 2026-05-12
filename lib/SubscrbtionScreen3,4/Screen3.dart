import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:second/SubscrbtionScreen3,4/Bloc/Cubit.dart';
import 'package:second/SubscrbtionScreen3,4/Bloc/State.dart';
import 'package:second/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<SubscriptionCubitS3>();

    cubit.checkStatus();

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      cubit.checkStatus();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(S.of(context).subscriptionStatus),
      ),
      body: BlocListener<SubscriptionCubitS3, SubscriptionState>(
        listener: (context, state) async {
          if (state is SubscriptionAccepted ||
              state is SubscriptionRejected ||
              state is SubscriptionActive) {
            timer?.cancel();
          }

          if (state is SubscriptionError) {
            timer?.cancel();

            final prefs = await SharedPreferences.getInstance();

            await prefs.remove('subscription_id');

            Navigator.pushNamedAndRemoveUntil(
              context,
              "test_page",
              (route) => false,
            );
          }
        },
        child: BlocBuilder<SubscriptionCubitS3, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SubscriptionPending) {
              return _buildPending();
            }

            if (state is SubscriptionAccepted) {
              return _buildAccepted(context);
            }

            if (state is SubscriptionRejected) {
              return _buildRejected(context);
            }
            if (state is SubscriptionActive) {
              return _buildActive(context);
            }
            if (state is SubscriptionError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildPending() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
      child: Center(
        child: Text(
          S.of(context).waitingApproval,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildAccepted(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                S.of(context).approvedSubscription,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(SharedPreferences.getInstance().then((prefs) {
                  String? subscriptionId = prefs.getString('subscription_id');
                  print(
                      "Subscription ID from SharedPreferences: $subscriptionId");
                }));
                Navigator.pushNamed(context, "Screen4");
              },
              child: Text(S.of(context).nextToPayment),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejected(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).rejectedSubscription,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();

              await prefs.remove('subscription_id');

              print("subscription_id deleted successfully");

              Navigator.pushNamed(context, "test_page");
            },
            child: Text(S.of(context).backToHome),
          ),
        ],
      ),
    );
  }

  Widget _buildActive(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).alreadySubscribed,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "test_page");
              },
              child: Text(S.of(context).goToHome),
            ),
          ],
        ),
      ),
    );
  }
}
