// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to Metro Mate!`
  String get welcomeMessage {
    return Intl.message(
      'Welcome to Metro Mate!',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Sign Up`
  String get signupButton {
    return Intl.message('Sign Up', name: 'signupButton', desc: '', args: []);
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logoutButton {
    return Intl.message('Logout', name: 'logoutButton', desc: '', args: []);
  }

  /// `Home`
  String get homeScreenTitle {
    return Intl.message('Home', name: 'homeScreenTitle', desc: '', args: []);
  }

  /// `Profile`
  String get profileScreenTitle {
    return Intl.message(
      'Profile',
      name: 'profileScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsScreenTitle {
    return Intl.message(
      'Settings',
      name: 'settingsScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get Back {
    return Intl.message('Back', name: 'Back', desc: '', args: []);
  }

  /// `Metro Mate `
  String get MetroMate {
    return Intl.message('Metro Mate ', name: 'MetroMate', desc: '', args: []);
  }

  /// `Create Account`
  String get CreateAccount {
    return Intl.message(
      'Create Account',
      name: 'CreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Profile Picture`
  String get ProfilePicture {
    return Intl.message(
      'Profile Picture',
      name: 'ProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Click to upload a profile picture`
  String get UploadProfilePicture {
    return Intl.message(
      'Click to upload a profile picture',
      name: 'UploadProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get FullName {
    return Intl.message('Full Name', name: 'FullName', desc: '', args: []);
  }

  /// `Enter your Full Name`
  String get EnterFullName {
    return Intl.message(
      'Enter your Full Name',
      name: 'EnterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get EmailAddress {
    return Intl.message(
      'Email Address',
      name: 'EmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get EnterEmail {
    return Intl.message(
      'Enter your email',
      name: 'EnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message('Password', name: 'Password', desc: '', args: []);
  }

  /// `Enter your password`
  String get EnterPassword {
    return Intl.message(
      'Enter your password',
      name: 'EnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get ConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'ConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Your Password`
  String get EnterConfirmPassword {
    return Intl.message(
      'Confirm Your Password',
      name: 'EnterConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get PhoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'PhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Phone number`
  String get EnterPhone {
    return Intl.message(
      'Enter your Phone number',
      name: 'EnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get Gender {
    return Intl.message('Gender', name: 'Gender', desc: '', args: []);
  }

  /// `Male`
  String get Male {
    return Intl.message('Male', name: 'Male', desc: '', args: []);
  }

  /// `Female`
  String get Female {
    return Intl.message('Female', name: 'Female', desc: '', args: []);
  }

  /// `Choose Type Of Gender`
  String get ChooseGender {
    return Intl.message(
      'Choose Type Of Gender',
      name: 'ChooseGender',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignUp {
    return Intl.message('Sign Up', name: 'SignUp', desc: '', args: []);
  }

  /// `Already have an account?`
  String get AlreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'AlreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get Login {
    return Intl.message('Log in', name: 'Login', desc: '', args: []);
  }

  /// `Camera`
  String get Camera {
    return Intl.message('Camera', name: 'Camera', desc: '', args: []);
  }

  /// `Gallery`
  String get Gallery {
    return Intl.message('Gallery', name: 'Gallery', desc: '', args: []);
  }

  /// `Verify Your Email`
  String get VerifyEmail {
    return Intl.message(
      'Verify Your Email',
      name: 'VerifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code we sent to your email`
  String get EnterCode {
    return Intl.message(
      'Enter the code we sent to your email',
      name: 'EnterCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Otp`
  String get InvalidOtp {
    return Intl.message(
      'Enter Valid Otp',
      name: 'InvalidOtp',
      desc: '',
      args: [],
    );
  }

  /// `Otp Resend`
  String get OtpResent {
    return Intl.message('Otp Resend', name: 'OtpResent', desc: '', args: []);
  }

  /// `Verification Code`
  String get VerificationCode {
    return Intl.message(
      'Verification Code',
      name: 'VerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `We've sent a 5-digit verification code to `
  String get OtpMessagePrefix {
    return Intl.message(
      'We\'ve sent a 5-digit verification code to ',
      name: 'OtpMessagePrefix',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get DidntReceive {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'DidntReceive',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get ResendCode {
    return Intl.message('Resend Code', name: 'ResendCode', desc: '', args: []);
  }

  /// `Tip: Check your spam folder if you don't see the email in your inbox.`
  String get TipMessage {
    return Intl.message(
      'Tip: Check your spam folder if you don\'t see the email in your inbox.',
      name: 'TipMessage',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get ForgotPasswordTitle {
    return Intl.message(
      'Forgot Password?',
      name: 'ForgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Don't worry! Enter your email address and we'll send you a code to reset your password.`
  String get ForgotPasswordDescription {
    return Intl.message(
      'Don\'t worry! Enter your email address and we\'ll send you a code to reset your password.',
      name: 'ForgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get SendCode {
    return Intl.message('Send Code', name: 'SendCode', desc: '', args: []);
  }

  /// `Enter a valid email`
  String get InvalidEmail {
    return Intl.message(
      'Enter a valid email',
      name: 'InvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Create New Password`
  String get CreateNewPassword {
    return Intl.message(
      'Create New Password',
      name: 'CreateNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your new password must be different from previously used passwords.`
  String get PasswordInstruction {
    return Intl.message(
      'Your new password must be different from previously used passwords.',
      name: 'PasswordInstruction',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get NewPassword {
    return Intl.message(
      'New Password',
      name: 'NewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter New Password`
  String get EnterNewPassword {
    return Intl.message(
      'Enter New Password',
      name: 'EnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get ConfirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'ConfirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reenter New Password`
  String get ReenterNewPassword {
    return Intl.message(
      'Reenter New Password',
      name: 'ReenterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 5-digit code we sent to`
  String get OtpInstruction {
    return Intl.message(
      'Enter the 5-digit code we sent to',
      name: 'OtpInstruction',
      desc: '',
      args: [],
    );
  }

  /// `to verify your identity.`
  String get VerifyIdentity {
    return Intl.message(
      'to verify your identity.',
      name: 'VerifyIdentity',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get OldPassword {
    return Intl.message(
      'Old Password',
      name: 'OldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Old Password`
  String get EnterOldPassword {
    return Intl.message(
      'Enter Old Password',
      name: 'EnterOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send New Password`
  String get SendNewPassword {
    return Intl.message(
      'Send New Password',
      name: 'SendNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Metro Mate`
  String get AppName {
    return Intl.message('Metro Mate', name: 'AppName', desc: '', args: []);
  }

  /// `Welcome back!`
  String get WelcomeBack {
    return Intl.message(
      'Welcome back!',
      name: 'WelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message('Email', name: 'Email', desc: '', args: []);
  }

  /// `Password must be at least 8 characters`
  String get PasswordTooShort {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'PasswordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get ForgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'ForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get SignIn {
    return Intl.message('Sign In', name: 'SignIn', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get NoAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'NoAccount',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get Skip {
    return Intl.message('Skip', name: 'Skip', desc: '', args: []);
  }

  /// `Next >`
  String get Next {
    return Intl.message('Next >', name: 'Next', desc: '', args: []);
  }

  /// `Get Started  >`
  String get GetStarted {
    return Intl.message(
      'Get Started  >',
      name: 'GetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Way`
  String get OnboardingTitle1 {
    return Intl.message(
      'Find Your Way',
      name: 'OnboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Easily check metro routes and directions from one station to another.`
  String get OnboardingDesc1 {
    return Intl.message(
      'Easily check metro routes and directions from one station to another.',
      name: 'OnboardingDesc1',
      desc: '',
      args: [],
    );
  }

  /// `Buy Tickets`
  String get OnboardingTitle2 {
    return Intl.message(
      'Buy Tickets',
      name: 'OnboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Purchase daily tickets instantly with your card or wallet.`
  String get OnboardingDesc2 {
    return Intl.message(
      'Purchase daily tickets instantly with your card or wallet.',
      name: 'OnboardingDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Student Discounts`
  String get OnboardingTitle3 {
    return Intl.message(
      'Student Discounts',
      name: 'OnboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Get metro subscriptions at discounted prices for students.`
  String get OnboardingDesc3 {
    return Intl.message(
      'Get metro subscriptions at discounted prices for students.',
      name: 'OnboardingDesc3',
      desc: '',
      args: [],
    );
  }

  /// `Route Details`
  String get routeDetails {
    return Intl.message(
      'Route Details',
      name: 'routeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Trip Information`
  String get tripInformation {
    return Intl.message(
      'Trip Information',
      name: 'tripInformation',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `min`
  String get minutes {
    return Intl.message('min', name: 'minutes', desc: '', args: []);
  }

  /// `Distance`
  String get distance {
    return Intl.message('Distance', name: 'distance', desc: '', args: []);
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `Ticket Price`
  String get ticketPrice {
    return Intl.message(
      'Ticket Price',
      name: 'ticketPrice',
      desc: '',
      args: [],
    );
  }

  /// `Buy Ticket For This Route`
  String get buyTicketRoute {
    return Intl.message(
      'Buy Ticket For This Route',
      name: 'buyTicketRoute',
      desc: '',
      args: [],
    );
  }

  /// `Line 1`
  String get Line1 {
    return Intl.message('Line 1', name: 'Line1', desc: '', args: []);
  }

  /// `Line 2`
  String get Line2 {
    return Intl.message('Line 2', name: 'Line2', desc: '', args: []);
  }

  /// `Line 3`
  String get Line3 {
    return Intl.message('Line 3', name: 'Line3', desc: '', args: []);
  }

  /// `Fastest Route`
  String get FastestRoute {
    return Intl.message(
      'Fastest Route',
      name: 'FastestRoute',
      desc: '',
      args: [],
    );
  }

  /// `Best Route`
  String get BestRoute {
    return Intl.message('Best Route', name: 'BestRoute', desc: '', args: []);
  }

  /// `KM`
  String get KM {
    return Intl.message('KM', name: 'KM', desc: '', args: []);
  }

  /// `EGP`
  String get EGP {
    return Intl.message('EGP', name: 'EGP', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Manage your account`
  String get manageAccount {
    return Intl.message(
      'Manage your account',
      name: 'manageAccount',
      desc: '',
      args: [],
    );
  }

  /// `Profile image updated successfully!`
  String get profileUpdated {
    return Intl.message(
      'Profile image updated successfully!',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Choose Profile Photo`
  String get chooseProfilePhoto {
    return Intl.message(
      'Choose Profile Photo',
      name: 'chooseProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Choose from Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Take a Photo`
  String get takePhoto {
    return Intl.message('Take a Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Settings & Privacy`
  String get settingsPrivacy {
    return Intl.message(
      'Settings & Privacy',
      name: 'settingsPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Error picking image:`
  String get errorPickingImage {
    return Intl.message(
      'Error picking image:',
      name: 'errorPickingImage',
      desc: '',
      args: [],
    );
  }

  /// `Error taking photo:`
  String get errorTakingPhoto {
    return Intl.message(
      'Error taking photo:',
      name: 'errorTakingPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message('Settings', name: 'Settings', desc: '', args: []);
  }

  /// `Manage your account`
  String get ManageAccount {
    return Intl.message(
      'Manage your account',
      name: 'ManageAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get SignOut {
    return Intl.message('Sign Out', name: 'SignOut', desc: '', args: []);
  }

  /// `Settings & Privacy`
  String get SettingsPrivacy {
    return Intl.message(
      'Settings & Privacy',
      name: 'SettingsPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Version `
  String get Version {
    return Intl.message('Version ', name: 'Version', desc: '', args: []);
  }

  /// `Terms of Service`
  String get TermsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'TermsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get PrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'PrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get Account {
    return Intl.message('Account', name: 'Account', desc: '', args: []);
  }

  /// `History`
  String get History {
    return Intl.message('History', name: 'History', desc: '', args: []);
  }

  /// `View your recent trips`
  String get ViewYourRecentTrips {
    return Intl.message(
      'View your recent trips',
      name: 'ViewYourRecentTrips',
      desc: '',
      args: [],
    );
  }

  /// `App Preferences`
  String get AppPreferences {
    return Intl.message(
      'App Preferences',
      name: 'AppPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message('Language', name: 'Language', desc: '', args: []);
  }

  /// `Choose your preferred language`
  String get ChooseLanguage {
    return Intl.message(
      'Choose your preferred language',
      name: 'ChooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get DarkMode {
    return Intl.message('Dark Mode', name: 'DarkMode', desc: '', args: []);
  }

  /// `Switch to dark theme`
  String get SwitchDarkTheme {
    return Intl.message(
      'Switch to dark theme',
      name: 'SwitchDarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Sound Effects`
  String get SoundEffects {
    return Intl.message(
      'Sound Effects',
      name: 'SoundEffects',
      desc: '',
      args: [],
    );
  }

  /// `Enable app sounds`
  String get EnableSounds {
    return Intl.message(
      'Enable app sounds',
      name: 'EnableSounds',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message('English', name: 'English', desc: '', args: []);
  }

  /// `Arabic`
  String get Arabic {
    return Intl.message('Arabic', name: 'Arabic', desc: '', args: []);
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Get Directions`
  String get GetDirections {
    return Intl.message(
      'Get Directions',
      name: 'GetDirections',
      desc: '',
      args: [],
    );
  }

  /// `Opening Maps...`
  String get OpeningMaps {
    return Intl.message(
      'Opening Maps...',
      name: 'OpeningMaps',
      desc: '',
      args: [],
    );
  }

  /// `Error Loading Station`
  String get ErrorLoadingStation {
    return Intl.message(
      'Error Loading Station',
      name: 'ErrorLoadingStation',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get TryAgain {
    return Intl.message('Try Again', name: 'TryAgain', desc: '', args: []);
  }

  /// `Location Permission Required`
  String get LocationPermissionRequired {
    return Intl.message(
      'Location Permission Required',
      name: 'LocationPermissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enable location permission in settings`
  String get EnableLocationFromSettings {
    return Intl.message(
      'Please enable location permission in settings',
      name: 'EnableLocationFromSettings',
      desc: '',
      args: [],
    );
  }

  /// `We need your location to find nearest metro`
  String get NeedLocation {
    return Intl.message(
      'We need your location to find nearest metro',
      name: 'NeedLocation',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get OpenSettings {
    return Intl.message(
      'Open Settings',
      name: 'OpenSettings',
      desc: '',
      args: [],
    );
  }

  /// `Grant Permission`
  String get GrantPermission {
    return Intl.message(
      'Grant Permission',
      name: 'GrantPermission',
      desc: '',
      args: [],
    );
  }

  /// `Location Services Disabled`
  String get LocationServicesDisabled {
    return Intl.message(
      'Location Services Disabled',
      name: 'LocationServicesDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Enable Location`
  String get EnableLocation {
    return Intl.message(
      'Enable Location',
      name: 'EnableLocation',
      desc: '',
      args: [],
    );
  }

  /// `Finding nearest station...`
  String get FindingStation {
    return Intl.message(
      'Finding nearest station...',
      name: 'FindingStation',
      desc: '',
      args: [],
    );
  }

  /// `Could not open maps`
  String get CouldNotOpenMaps {
    return Intl.message(
      'Could not open maps',
      name: 'CouldNotOpenMaps',
      desc: '',
      args: [],
    );
  }

  /// ` min walk`
  String get MinWalk {
    return Intl.message(' min walk', name: 'MinWalk', desc: '', args: []);
  }

  /// `N/A`
  String get NotAvailable {
    return Intl.message('N/A', name: 'NotAvailable', desc: '', args: []);
  }

  /// `Walking`
  String get walking {
    return Intl.message('Walking', name: 'walking', desc: '', args: []);
  }

  /// `Help & Support`
  String get HelpSupport {
    return Intl.message(
      'Help & Support',
      name: 'HelpSupport',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get HelpCenter {
    return Intl.message('Help Center', name: 'HelpCenter', desc: '', args: []);
  }

  /// `FAQs and guides`
  String get FAQsGuides {
    return Intl.message(
      'FAQs and guides',
      name: 'FAQsGuides',
      desc: '',
      args: [],
    );
  }

  /// `Contact Support`
  String get ContactSupport {
    return Intl.message(
      'Contact Support',
      name: 'ContactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Get help from our team`
  String get GetHelpFromTeam {
    return Intl.message(
      'Get help from our team',
      name: 'GetHelpFromTeam',
      desc: '',
      args: [],
    );
  }

  /// `Buy Tickets`
  String get buyTickets {
    return Intl.message('Buy Tickets', name: 'buyTickets', desc: '', args: []);
  }

  /// `Choose Payment Method`
  String get choosePaymentMethod {
    return Intl.message(
      'Choose Payment Method',
      name: 'choosePaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Credit / Debit Card`
  String get creditDebitCard {
    return Intl.message(
      'Credit / Debit Card',
      name: 'creditDebitCard',
      desc: '',
      args: [],
    );
  }

  /// `Visa, Mastercard accepted`
  String get visaMastercardAccepted {
    return Intl.message(
      'Visa, Mastercard accepted',
      name: 'visaMastercardAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Choose Type Of Payment Method`
  String get choosePaymentError {
    return Intl.message(
      'Choose Type Of Payment Method',
      name: 'choosePaymentError',
      desc: '',
      args: [],
    );
  }

  /// `Pay EG`
  String get payEg {
    return Intl.message('Pay EG', name: 'payEg', desc: '', args: []);
  }

  /// `Payment Process Summary`
  String get paymentSummary {
    return Intl.message(
      'Payment Process Summary',
      name: 'paymentSummary',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message('User Name', name: 'userName', desc: '', args: []);
  }

  /// `Payment ID`
  String get paymentId {
    return Intl.message('Payment ID', name: 'paymentId', desc: '', args: []);
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Total Paid`
  String get totalPaid {
    return Intl.message('Total Paid', name: 'totalPaid', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Pay`
  String get payButton {
    return Intl.message('Pay', name: 'payButton', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Something went wrong. Please try again.`
  String get iframeNullError {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'iframeNullError',
      desc: '',
      args: [],
    );
  }

  /// `Bill Reference`
  String get billReference {
    return Intl.message(
      'Bill Reference',
      name: 'billReference',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home`
  String get backToHome {
    return Intl.message('Back to Home', name: 'backToHome', desc: '', args: []);
  }

  /// `Select Quantity`
  String get selectQuantity {
    return Intl.message(
      'Select Quantity',
      name: 'selectQuantity',
      desc: '',
      args: [],
    );
  }

  /// `each`
  String get each {
    return Intl.message('each', name: 'each', desc: '', args: []);
  }

  /// `ticket`
  String get ticket {
    return Intl.message('ticket', name: 'ticket', desc: '', args: []);
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Route Summary`
  String get routeSummary {
    return Intl.message(
      'Route Summary',
      name: 'routeSummary',
      desc: '',
      args: [],
    );
  }

  /// `Continue To Payment`
  String get continueToPayment {
    return Intl.message(
      'Continue To Payment',
      name: 'continueToPayment',
      desc: '',
      args: [],
    );
  }

  /// `Security & Privacy`
  String get securityPrivacy {
    return Intl.message(
      'Security & Privacy',
      name: 'securityPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Biometric Login`
  String get biometricLogin {
    return Intl.message(
      'Biometric Login',
      name: 'biometricLogin',
      desc: '',
      args: [],
    );
  }

  /// `Use fingerprint or face ID`
  String get biometricDesc {
    return Intl.message(
      'Use fingerprint or face ID',
      name: 'biometricDesc',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Update your account password`
  String get changePasswordDesc {
    return Intl.message(
      'Update your account password',
      name: 'changePasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `Use fingerprint or face ID`
  String get biometricSubtitle {
    return Intl.message(
      'Use fingerprint or face ID',
      name: 'biometricSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Update your account password`
  String get updatePassword {
    return Intl.message(
      'Update your account password',
      name: 'updatePassword',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Push Notifications`
  String get pushNotifications {
    return Intl.message(
      'Push Notifications',
      name: 'pushNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Receive app notifications`
  String get receiveNotifications {
    return Intl.message(
      'Receive app notifications',
      name: 'receiveNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Email Notifications`
  String get emailNotifications {
    return Intl.message(
      'Email Notifications',
      name: 'emailNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Receive updates via email`
  String get receiveEmailUpdates {
    return Intl.message(
      'Receive updates via email',
      name: 'receiveEmailUpdates',
      desc: '',
      args: [],
    );
  }

  /// `SMS Alerts`
  String get smsAlerts {
    return Intl.message('SMS Alerts', name: 'smsAlerts', desc: '', args: []);
  }

  /// `Important updates via SMS`
  String get smsUpdates {
    return Intl.message(
      'Important updates via SMS',
      name: 'smsUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Marketing`
  String get marketing {
    return Intl.message('Marketing', name: 'marketing', desc: '', args: []);
  }

  /// `Promotions and offers`
  String get offersPromotions {
    return Intl.message(
      'Promotions and offers',
      name: 'offersPromotions',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get language {
    return Intl.message('English', name: 'language', desc: '', args: []);
  }

  /// `Change App Language`
  String get ChangeAppLanguage {
    return Intl.message(
      'Change App Language',
      name: 'ChangeAppLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Balance`
  String get Wallet {
    return Intl.message('Wallet Balance', name: 'Wallet', desc: '', args: []);
  }

  /// `Deposit Money`
  String get DepositMoney {
    return Intl.message(
      'Deposit Money',
      name: 'DepositMoney',
      desc: '',
      args: [],
    );
  }

  /// `Quick Actions`
  String get QuickActions {
    return Intl.message(
      'Quick Actions',
      name: 'QuickActions',
      desc: '',
      args: [],
    );
  }

  /// `Buy Daily Ticket`
  String get BuyDailyTicket {
    return Intl.message(
      'Buy Daily Ticket',
      name: 'BuyDailyTicket',
      desc: '',
      args: [],
    );
  }

  /// `Quick Purchase`
  String get QuickPurchase {
    return Intl.message(
      'Quick Purchase',
      name: 'QuickPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Get Subscription`
  String get GetSubscription {
    return Intl.message(
      'Get Subscription',
      name: 'GetSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Passes`
  String get MonthlyPasses {
    return Intl.message(
      'Monthly Passes',
      name: 'MonthlyPasses',
      desc: '',
      args: [],
    );
  }

  /// `Nearest Metro Station`
  String get NearestMetroStation {
    return Intl.message(
      'Nearest Metro Station',
      name: 'NearestMetroStation',
      desc: '',
      args: [],
    );
  }

  /// `Plan Your Route`
  String get planYourRoute {
    return Intl.message(
      'Plan Your Route',
      name: 'planYourRoute',
      desc: '',
      args: [],
    );
  }

  /// `Search station...`
  String get searchStation {
    return Intl.message(
      'Search station...',
      name: 'searchStation',
      desc: '',
      args: [],
    );
  }

  /// `Select Station`
  String get selectStation {
    return Intl.message(
      'Select Station',
      name: 'selectStation',
      desc: '',
      args: [],
    );
  }

  /// `Choose Metro Station`
  String get chooseMetroStation {
    return Intl.message(
      'Choose Metro Station',
      name: 'chooseMetroStation',
      desc: '',
      args: [],
    );
  }

  /// `Search Route`
  String get searchRoute {
    return Intl.message(
      'Search Route',
      name: 'searchRoute',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Tickets`
  String get tickets {
    return Intl.message('Tickets', name: 'tickets', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Ticket Price`
  String get ticket_price {
    return Intl.message(
      'Ticket Price',
      name: 'ticket_price',
      desc: '',
      args: [],
    );
  }

  /// `Search station...`
  String get search_station {
    return Intl.message(
      'Search station...',
      name: 'search_station',
      desc: '',
      args: [],
    );
  }

  /// `Select Station`
  String get select_station {
    return Intl.message(
      'Select Station',
      name: 'select_station',
      desc: '',
      args: [],
    );
  }

  /// `Choose Metro Station`
  String get choose_station {
    return Intl.message(
      'Choose Metro Station',
      name: 'choose_station',
      desc: '',
      args: [],
    );
  }

  /// `Select persons`
  String get select_persons {
    return Intl.message(
      'Select persons',
      name: 'select_persons',
      desc: '',
      args: [],
    );
  }

  /// `Choose Number of Persons`
  String get choose_persons {
    return Intl.message(
      'Choose Number of Persons',
      name: 'choose_persons',
      desc: '',
      args: [],
    );
  }

  /// `Calculate Price`
  String get calculate_price {
    return Intl.message(
      'Calculate Price',
      name: 'calculate_price',
      desc: '',
      args: [],
    );
  }

  /// `Trip Information`
  String get trip_information {
    return Intl.message(
      'Trip Information',
      name: 'trip_information',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get total_price {
    return Intl.message('Total Price', name: 'total_price', desc: '', args: []);
  }

  /// `Waiting until approved ⏳`
  String get waitingApproval {
    return Intl.message(
      'Waiting until approved ⏳',
      name: 'waitingApproval',
      desc: '',
      args: [],
    );
  }

  /// `Approved Subscription ✅`
  String get approvedSubscription {
    return Intl.message(
      'Approved Subscription ✅',
      name: 'approvedSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Next To Payment`
  String get nextToPayment {
    return Intl.message(
      'Next To Payment',
      name: 'nextToPayment',
      desc: '',
      args: [],
    );
  }

  /// `Rejected Subscription ❌\nCheck your Email for more details`
  String get rejectedSubscription {
    return Intl.message(
      'Rejected Subscription ❌\nCheck your Email for more details',
      name: 'rejectedSubscription',
      desc: '',
      args: [],
    );
  }

  /// `You are already subscribed ✅`
  String get alreadySubscribed {
    return Intl.message(
      'You are already subscribed ✅',
      name: 'alreadySubscribed',
      desc: '',
      args: [],
    );
  }

  /// `Go to Home`
  String get goToHome {
    return Intl.message('Go to Home', name: 'goToHome', desc: '', args: []);
  }

  /// `Subscription Payment`
  String get subscriptionPayment {
    return Intl.message(
      'Subscription Payment',
      name: 'subscriptionPayment',
      desc: '',
      args: [],
    );
  }

  /// `Choose payment method`
  String get choosePaymentMethodError {
    return Intl.message(
      'Choose payment method',
      name: 'choosePaymentMethodError',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Type`
  String get subscriptionType {
    return Intl.message(
      'Subscription Type',
      name: 'subscriptionType',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Duration`
  String get subscriptionDuration {
    return Intl.message(
      'Subscription Duration',
      name: 'subscriptionDuration',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Status`
  String get subscriptionStatus {
    return Intl.message(
      'Subscription Status',
      name: 'subscriptionStatus',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
