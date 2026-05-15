import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/Bloc/Navigate_cubit.dart';
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

    timer = Timer.periodic(
      const Duration(seconds: 60),
      (_) {
        cubit.checkStatus();
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          S.of(context).subscriptionStatus,
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<SubscriptionCubitS3, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionAccepted ||
              state is SubscriptionRejected ||
              state is SubscriptionRenew ||
              state is SubscriptionExpired ||
              state is SubscriptionmanualRenew ||
              state is SubscriptionActive) {
            timer?.cancel();
          }

          // Subscription was deleted on the backend (or never existed).
          // The cubit already cleared the local subscription_id.
          // Pop back to SubscriptionPage — its .then() callback will call
          // _checkSubscription(), which will now show Screen 1 (fresh flow).
          if (state is SubscriptionNotFound) {
            timer?.cancel();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              Navigator.of(context).pop();
            });
          }
        },
        child: BlocBuilder<SubscriptionCubitS3, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading || state is SubscriptionNotFound) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SubscriptionmanualRenew) {
              Navigator.pushNamed(
                context,
                "Screen4",
              );
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
            if (state is SubscriptionExpired) {
              return _buildExpired(context);
            }

            if (state is SubscriptionActive) {
              return _buildActive(
                context,
                state.data,
              );
            }

            if (state is SubscriptionRenew) {
              return _buildRenew(
                context,
                state.data,
              );
            }

            // if (state is SubscriptionError) {
            //   return Center(
            //     child: Text(state.message),
            //   );
            // }

            if (state is SubscriptionError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${state.message}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<Navigate_Cubit>().ChangeIndex(0);

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "test_page",
                          (route) => false,
                        );
                      },
                      child: Text(
                        S.of(context).backToHome,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "Subscription",
                        );
                      },
                      child: Text(
                        S.of(context).returnToSubscripe,
                      ),
                    )
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// Pending
  Widget _buildPending() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              S.of(context).waitingApproval,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<Navigate_Cubit>().ChangeIndex(0);

              Navigator.pushNamedAndRemoveUntil(
                context,
                "test_page",
                (route) => false,
              );
            },
            child: Text(
              S.of(context).backToHome,
            ),
          ),
        ],
      ),
    );
  }

  /// Accepted
  Widget _buildAccepted(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 20.0,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 30.0,
              ),
              child: Text(
                S.of(context).approvedSubscription,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(
                  SharedPreferences.getInstance().then((prefs) {
                    String? subscriptionId = prefs.getString('subscription_id');

                    print(
                      "Subscription ID : "
                      "$subscriptionId",
                    );
                  }),
                );

                Navigator.pushNamed(
                  context,
                  "Screen4",
                );
              },
              child: Text(
                S.of(context).nextToPayment,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<Navigate_Cubit>().ChangeIndex(0);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "test_page",
                  (route) => false,
                );
              },
              child: Text(
                S.of(context).backToHome,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Rejected
  Widget _buildRejected(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).rejectedSubscription,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              context.read<Navigate_Cubit>().ChangeIndex(0);
              final prefs = await SharedPreferences.getInstance();

              await prefs.setBool(
                "subscription_seen",
                false,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                "test_page",
                (route) => false,
              );
            },
            child: Text(
              S.of(context).backToHome,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "Subscription",
              );
            },
            child: Text(
              S.of(context).returnToSubscripe,
            ),
          )
        ],
      ),
    );
  }

  /// Active
  Widget _buildActive(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final subscription = data['subscription'];

    final office = data['office'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/190/190411.png",
              height: 100,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      S.of(context).subscriptionActive,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5A72A0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  buildItem(
                    S.of(context).userName,
                    "${data['userName']}",
                  ),
                  buildItem(
                    S.of(context).category,
                    "${subscription['category']}",
                  ),
                  buildItem(
                    S.of(context).duration,
                    "${subscription['duration']}",
                  ),
                  buildItem(
                    S.of(context).price,
                    "${subscription['price']} EGP",
                  ),
                  buildItem(
                    S.of(context).startDate,
                    "${subscription['start_date']}",
                  ),
                  buildItem(
                    S.of(context).endDate,
                    "${subscription['end_date']}",
                  ),
                  buildItem(
                    S.of(context).startStation,
                    "${subscription['start_station']}",
                  ),
                  buildItem(
                    S.of(context).endStation,
                    "${subscription['end_station']}",
                  ),
                  buildItem(
                    S.of(context).office,
                    "${office['name']}",
                  ),
                  buildItem(
                    S.of(context).workingHours,
                    "${office['workingHours']['from']}"
                    " - "
                    "${office['workingHours']['to']}",
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5A72A0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<Navigate_Cubit>().ChangeIndex(0);

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "test_page",
                          (route) => false,
                        );
                      },
                      child: Text(
                        S.of(context).goToHome,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Renew
  Widget _buildRenew(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final subscription = data['subscription'];

    final office = data['office'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/1048/1048953.png",
              height: 100,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      S.of(context).subscriptionNeedRenew,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  buildItem(
                    S.of(context).userName,
                    "${data['userName']}",
                  ),
                  buildItem(
                    S.of(context).category,
                    "${subscription['category']}",
                  ),
                  buildItem(
                    S.of(context).duration,
                    "${subscription['duration']}",
                  ),
                  buildItem(
                    S.of(context).price,
                    "${subscription['price']} EGP",
                  ),
                  buildItem(
                    S.of(context).startDate,
                    "${subscription['start_date']}",
                  ),
                  buildItem(
                    S.of(context).endDate,
                    "${subscription['end_date']}",
                  ),
                  buildItem(
                    S.of(context).startStation,
                    "${subscription['start_station']}",
                  ),
                  buildItem(
                    S.of(context).endStation,
                    "${subscription['end_station']}",
                  ),
                  buildItem(
                    S.of(context).office,
                    "${office['name']}",
                  ),
                  buildItem(
                    S.of(context).workingHours,
                    "${office['workingHours']['from']}"
                    " - "
                    "${office['workingHours']['to']}",
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff5A72A0),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<Navigate_Cubit>().ChangeIndex(0);

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "test_page",
                              (route) => false,
                            );
                          },
                          child: Text(
                            S.of(context).backToHome,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xff5A72A0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    S.of(context).confirmRenew,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        S.of(context).no,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        final messenger =
                                            ScaffoldMessenger.of(context);

                                        String message = await context
                                            .read<SubscriptionCubitS3>()
                                            .confirmRenew();

                                        if (!mounted) return;

                                        messenger.showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(message),
                                          ),
                                        );

                                        context
                                            .read<SubscriptionCubitS3>()
                                            .checkStatus();
                                      },
                                      child: Text(
                                        S.of(context).yes,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            S.of(context).renew,
                            style: const TextStyle(
                              color: Color(0xff5A72A0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Expired
  Widget _buildExpired(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/1828/1828843.png",
              height: 120,
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    S.of(context).subscriptionExpired,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).subscriptionExpiredMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5A72A0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        context.read<Navigate_Cubit>().ChangeIndex(0);
                        final prefs = await SharedPreferences.getInstance();

                        await prefs.setBool(
                          "subscription_seen",
                          false,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "test_page",
                          (route) => false,
                        );
                      },
                      child: Text(
                        S.of(context).backToHome,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "Subscription",
                        );
                      },
                      child: Text(
                        S.of(context).returnToSubscripe,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
      ),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
