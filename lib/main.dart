import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second/Bloc/LocaliztionCubit/Localization_Cubit.dart';

import 'package:second/ChangePassword/ChangePassword_Cubit.dart';
import 'package:second/Shuttle%20bus/ShuttleBus.dart';
import 'package:second/Shuttle%20bus/ShuttleBusRoute.dart';
import 'package:second/SubscrbtionScreen3,4/Bloc/Cubit.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Local_Notfication.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Notfication_Cubit.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Notfication_History.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/push_notfication_SERVICE.dart';
import 'package:second/SubscrbtionScreen3,4/Screen3.dart';
import 'package:second/SubscrbtionScreen3,4/Screen4.dart';
import 'package:second/SubscrbtionScreen3,4/SubscriptionCashPage.dart';
import 'package:second/SubscrbtionScreen3,4/SubscrptionConfurmVisa.dart';
import 'package:second/cubits/logout/logout_cubit.dart';
import 'package:second/cubits/logout/logout_state.dart';
import 'package:second/cubits/user/user_cubit.dart';
import 'package:second/firebase_options.dart';
import './cubits/subscription/subscription_cubit.dart';
import 'views/ProfileSettingsPage.dart';

import 'package:second/generated/l10n.dart';
import 'package:second/services/auth_service.dart';
import 'package:second/services/storage_service.dart';
import 'package:second/views/login_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'Bloc/Navigate_cubit.dart';
import 'Bloc/selectRoute_Cubit.dart';
import 'Buy_Ticket/ChosePaymentMethod.dart';
import 'Buy_Ticket/Confirm_FawryPage.dart';
import 'Buy_Ticket/Confirm_VisaCard_Page.dart';
import 'Buy_Ticket/CreditDetils.dart';
import 'Buy_Ticket/Fawry_Page.dart';
import 'Buy_Ticket/PaymentFinish.dart';
import 'Buy_Ticket/Select Quantity.dart';
import 'ChangePassword/ChangePassword.dart';
import 'NavigationBar_Page/Home.dart';
import 'NavigationBar_Page/Tickets.dart';
import './views/subscription.dart';

import 'RouteDeatils.dart';
import 'OnbordingScreens.dart';
import 'block/Cubit.dart';
import 'Authentication/ForgetPassword/Forget_Password.dart';
import 'Authentication/ForgetPassword/NewPassword_Page.dart';
import 'Authentication/Regestration/Register_Otp.dart';
import 'Authentication/Regestration/Register_page.dart';
import 'Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import 'Authentication_Cubit/Register_Cubit/Register_Cubit.dart';

import 'cubits/login/login_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Future.wait([
    PushNotficationService.init(),
    LocalNotificationService.init(),
  ]);

  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  } else if (Platform.isIOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }

  runApp(const MetroApp());
}

class MetroApp extends StatelessWidget {
  const MetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationCubit(),
        ),
        BlocProvider(create: (context) => ChangePasswordCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ForgetPasswordCubit()),
        BlocProvider(create: (context) => LoginCubit(AuthService())),
        BlocProvider(create: (context) => Navigate_Cubit()),
        BlocProvider(create: (context) => SelectRoute()),
        BlocProvider(create: (context) => OnBoardingCubit()..CheckSeen()),
        BlocProvider(
            create: (context) => UserCubit(StorageService())..loadUser()),
        BlocProvider(create: (context) => LogOutCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(
          create: (context) => SubscriptionCubit(),
        ),
        BlocProvider(create: (context) => SubscriptionCubitS3(Dio())),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          Locale currentLocale = const Locale('en');

          if (state is ChangeLocaleState) {
            currentLocale = state.locale;
          }

          return MaterialApp(
            locale: currentLocale,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: const SplashRouter(),
            routes: {
              'test_page': (context) => test_page(),
              'Home': (context) => Home(),
              'loginPage': (context) => const LoginPage(),
              'Register': (context) => RegisterPage(),
              'RegisterOtp': (context) => RegisterOtp(),
              'ForgetPassword': (context) => ForgetPassword(),
              'NewpasswordPage': (context) => NewpasswordPage(),
              'detalis': (context) => Routedeatils(),
              'SelectQuantity': (context) => SelectQuantity(),
              'Chosepaymentmethod': (context) => Chosepaymentmethod(),
              'Creditdetils': (context) => Creditdetils(),
              'finish': (context) => Paymentfinish(),
              'ChangePassword': (context) => Changepassword(),
              'Onbordingscreen': (context) => Onbordingscreen(),
              'Profile': (context) => ProfileSettingsPageView(),
              'ConfirmFawrypage': (context) => ConfirmFawrypage(),
              'ConfirmVisacardPage': (context) => ConfirmVisacardPage(),
              'Fawry': (context) => FawryPage(),
              'Screen3': (context) => Screen3(),
              "Shuttlebusroute": (context) => Shuttlebusroute(),
              "Screen4": (context) => Screen4(),
              "SubscrptionConfirmVisacardPage": (context) =>
                  SubscrptionConfirmVisacardPage(),
              "SubscrptionCashPage": (context) => SubscrptionCashPage(),
              "NotificationScreen": (context) => NotificationScreen(),
            },
            builder: (context, child) {
              PushNotficationService.setContext(context);

              return BlocListener<LogOutCubit, LogOutState>(
                listener: (context, state) {
                  if (state is LogOutSuccessful) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

/// Splash Router
class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final token = await StorageService().getToken();
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.read<UserCubit>().loadUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => test_page()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Onbordingscreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF5B8FB9),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}

/// Main App Shell
class test_page extends StatefulWidget {
  test_page({super.key});

  @override
  State<test_page> createState() => _test_pageState();
}

class _test_pageState extends State<test_page> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PushNotficationService.setContext(context);

      LocalNotificationService.streamController.stream.listen((event) {
        Navigator.pushNamed(context, 'NotificationScreen');
      });
    });
  }

  List<Widget> NavigationBarpage = [
    Home(),
    Tickets(),
    Shuttlebus(),
    SubscriptionPage(),
    ProfileSettingsPageView(),
  ];

  List<PreferredSizeWidget> getAppBars(BuildContext context) {
    return [
      AppBar(
        title: null,
        automaticallyImplyLeading: false,
      ),
      AppBar(
        backgroundColor: Colors.white,
        title: Text(S.of(context).tickets),
        automaticallyImplyLeading: false,
      ),
      AppBar(
        backgroundColor: Colors.white,
        title: Text(S.of(context).shuttleBus),
        automaticallyImplyLeading: false,
      ),
      AppBar(
        backgroundColor: Colors.white,
        title: Text(S.of(context).subscription),
        automaticallyImplyLeading: false,
      ),
    ];
  }

  int CurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navState = context.watch<Navigate_Cubit>().state;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffFCFCFD),
      // Hide AppBar for tabs 0 (Home), 2 (ShuttleBus), 4 (Profile+Settings)
      // because each of those manages its own AppBar internally
      appBar: [0, 2, 4].contains(navState)
          ? null
          : getAppBars(context)[navState],
      body: BlocBuilder<Navigate_Cubit, int>(
        builder: (context, state) {
          return NavigationBarpage[state];
        },
      ),
      bottomNavigationBar:
          BlocBuilder<Navigate_Cubit, int>(builder: (context, state) {
        return BottomNavigationBar(
            currentIndex: state,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue.shade300,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            onTap: (value) {
              context.read<Navigate_Cubit>().ChangeIndex(value);
              context.read<SelectRoute>().Hide();
              context.read<SelectRoute>().ClearSelection();
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  label: S.of(context).home),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.ticket),
                  label: S.of(context).tickets),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.bus),
                  label: S.of(context).shuttleBus),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_rounded),
                  label: S.of(context).subscription),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: S.of(context).settingsScreenTitle),
            ]);
      }),
    );
  }
}