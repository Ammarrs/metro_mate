import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second/Bloc/LocaliztionCubit/Localization_Cubit.dart';
import 'package:second/ChangePassword/ChangePassword_Cubit.dart';
import 'package:second/components/home_app_bar.dart';
import 'package:second/cubits/logout/logout_cubit.dart';
import 'package:second/cubits/logout/logout_state.dart';
import 'package:second/cubits/user/user_cubit.dart';
import 'package:second/generated/l10n.dart';
import 'package:second/services/auth_service.dart';
import 'package:second/services/storage_service.dart';
import 'package:second/views/login_view.dart';
import 'package:second/views/profile_page_view.dart';
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
import 'Buy_Ticket/VisaCard_Page.dart';
import 'ChangePassword/ChangePassword.dart';
import 'NavigationBar_Page/Home.dart';
import 'NavigationBar_Page/Tickets.dart';
import 'NavigationBar_Page/setting.dart';
import 'NavigationBar_Page/wallet.dart';
import 'views/settings.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'RouteDeatils.dart';
import 'OnbordingScreens.dart';
import 'block/Cubit.dart';
import 'Authentication/ForgetPassword/Forget_Password.dart';
import 'Authentication/ForgetPassword/NewPassword_Page.dart';
import 'Authentication/Regestration/Register_Otp.dart';
import 'Authentication/Regestration/Register_page.dart';
import 'Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import 'Authentication_Cubit/Register_Cubit/Register_Cubit.dart';

import 'components/wallet.dart';
import 'cubits/login/login_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
              'Profile': (context) => ProfilePageView(),
              'ConfirmFawrypage': (context) => ConfirmFawrypage(),
              'ConfirmVisacardPage': (context) => ConfirmVisacardPage(),
              'Fawry': (context) => FawryPage(),
            },
            builder: (context, child) {
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
class test_page extends StatelessWidget {
  test_page({super.key});

  final List<Widget> pages = [Home(), Tickets(), Wallet(), SettingsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFD),
      body: BlocBuilder<Navigate_Cubit, int>(
        builder: (context, state) {
          return pages[state];
        },
      ),
      bottomNavigationBar: BlocBuilder<Navigate_Cubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue.shade300,
            unselectedItemColor: Colors.grey,
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
                  icon: Icon(Icons.account_balance_wallet),
                  label: S.of(context).wallet),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: S.of(context).settings),
            ],
          );
        },
      ),
    );
  }
}
