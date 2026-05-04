import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';

import '../../Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import '../../Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_State.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword();

  @override
  Widget build(BuildContext context) {
    final EmailControllerPassword = TextEditingController();
    final ForgetPasswordKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<ForgetPasswordCubit, ForgetPassword_State>(
            listener: (context, state) {
          if (state is ForgetPasswordSucsees) {
            Navigator.pushNamed(context, 'NewpasswordPage',
                arguments: EmailControllerPassword.text);
          } else if (state is ForgetPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).InvalidEmail)));
          }
        }, builder: (context, state) {
          final cubit = context.read<ForgetPasswordCubit>();

          return ListView(
            children: [
              Column(children: [
                Center(
                  child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF4A6BAA),
                            Color(0xFF47C7E0),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.email,
                        size: 80,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                    child: Text(
                  S.of(context).ForgotPasswordTitle,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  S.of(context).ForgotPasswordDescription,
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
              ]),
              SizedBox(
                height: 30,
              ),
              Text(
                S.of(context).EmailAddress,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Form(
                key: ForgetPasswordKey,
                child: TextFormField(
                  controller: EmailControllerPassword,
                  onChanged: cubit.ChangeEmail,
                  validator: (value) {
                    final result = cubit.ValidateEmail(value);

                    if (result != null) {
                      switch (result) {
                        case "enterYourEmail":
                          return S.of(context).enterYourEmail;
                      }
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    hint: Text(S.of(context).EnterEmail),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: state is ForgetPasswordLoding
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.blue,
                      ))
                    : MaterialButton(
                        onPressed: () {
                          if (ForgetPasswordKey.currentState!.validate()) {
                            cubit.SendCode();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Color(0xff5A72A0),
                        minWidth: double.infinity,
                        height: 45,
                        child: Text(
                          S.of(context).SendCode,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
