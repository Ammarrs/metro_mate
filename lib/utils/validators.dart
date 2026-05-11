// import 'package:flutter/material.dart';
// import 'package:second/generated/l10n.dart';

// class Validators {
// static String? validateEmail(
// BuildContext context,
// String? value,
// ) {
// if (value == null || value.isEmpty) {
// return S.of(context).emailRequired;
// }


// final emailRegex =
//     RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

// if (!emailRegex.hasMatch(value)) {
//   return S.of(context).invalidEmail;
// }

// return null;


// }

// static String? validatePassword(
// BuildContext context,
// String? value, {
// int minLength = 6,
// }) {
// if (value == null || value.isEmpty) {
// return S.of(context).passwordRequired;
// }


// if (value.length < minLength) {
//   return S.of(context).passwordMinLength(minLength);
// }

// return null;


// }

// static String? validateName(
// BuildContext context,
// String? value,
// ) {
// if (value == null || value.isEmpty) {
// return S.of(context).nameRequired;
// }


// if (value.length < 2) {
//   return S.of(context).nameTooShort;
// }

// return null;


// }

// static String? validatePhone(
// BuildContext context,
// String? value,
// ) {
// if (value == null || value.isEmpty) {
// return S.of(context).phoneRequired;
// }


// final phoneRegex = RegExp(r'^\d{10,15}$');

// if (!phoneRegex.hasMatch(value)) {
//   return S.of(context).invalidPhone;
// }

// return null;


// }

// static String? validateConfirmPassword(
// BuildContext context,
// String? value,
// String password,
// ) {
// if (value == null || value.isEmpty) {
// return S.of(context).confirmPasswordRequired;
// }


// if (value != password) {
//   return S.of(context).passwordsDoNotMatch;
// }

// return null;


// }

// static String? validateSSN(
// BuildContext context,
// String? value,
// ) {
// if (value == null || value.isEmpty) {
// return S.of(context).ssnRequired;
// }


// if (value.length != 14) {
//   return S.of(context).invalidSSN;
// }

// return null;


// }

// static String? validateAge(
// BuildContext context,
// String? value,
// ) {
// if (value == null || value.isEmpty) {
// return S.of(context).ageRequired;
// }


// final age = int.tryParse(value);

// if (age == null) {
//   return S.of(context).invalidAge;
// }

// if (age < 18 || age > 100) {
//   return S.of(context).invalidAgeRange;
// }

// return null;


// }
// }
