import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../Authentication_Cubit/Register_Cubit/Register_Cubit.dart';
import '../../Authentication_Cubit/Register_Cubit/Register_State.dart';
class RegisterOtp extends StatelessWidget {
  RegisterOtp();


  @override
  Widget build(BuildContext context) {

    final EmailData=ModalRoute.of(context)!.settings.arguments ;
    final cubit= context.read<RegisterCubit>();


    return  Scaffold(
        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(

          leadingWidth: 60,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 150.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "Register");
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white54,
              ),
              label: const Text(
                "Back",
                style: TextStyle(color: Colors.white54),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),

          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A6BAA),
                  Color(0xFF47C7E0),
                ],
              ),
            ),
          ),

          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xffA8CBDF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.email,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter the code we sent to your email",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          toolbarHeight: 250,
        ),


        body:BlocConsumer<RegisterCubit,Register_State>(
          listener: (context,state){
            if (state is RegisterSucsess){
              Navigator.pushNamed(
                  context,'Home',

              );

            }
            else if(state is RegisterError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Enter Valid Otp")));
            }
            if (state is RegisterSucsessOTP){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("  Otp Resend")));
            }
            else if(state is RegisterErrorOTP){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Enter Valid Otp")));
            }

          },



          builder: (context,state) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                  child: Container(
                        width: 50,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:Offset(1, 2),
                      )],
                      color: Colors.white
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Verification Code',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text.rich(
                            TextSpan(
                              text: "We've sent a 5-digit verification code \nto ",
                              children: [
                                TextSpan(
                                  text: '$EmailData', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                            SizedBox(height: 30,),
                            state is RegisterLoading? CircularProgressIndicator(): OTPTextField(
                              onChanged:cubit.ChangOtp ,
                            length: 5,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 50,
                            style:  TextStyle(
                              fontSize: 20,

                            ),
                            textFieldAlignment: MainAxisAlignment.spaceEvenly,
                            fieldStyle: FieldStyle.box,
                            keyboardType: TextInputType.number,


                            outlineBorderRadius: 30,

                            otpFieldStyle: OtpFieldStyle(
                              backgroundColor: Colors.white70,


                              focusBorderColor: Colors.blue,
                            ),
                            onCompleted: (e){
                              cubit.ChangOtp(e);
                              cubit.VerfiyOtp();

                            },
                          ),
                          SizedBox(height: 45,),
                          Center(child: Text('Didn\'t receive the code?')),
                          Center(
                            child: MaterialButton(onPressed: (){
                              cubit.RsendOtp();
                            },
                            child: Text("Resend Code",style: TextStyle(color: Colors.blueAccent,fontWeight:FontWeight.bold),),),
                          )

                        ],
                      ),
                    ),

                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                  child: Container(
                    width: 50,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:Offset(1, 2),
                        )],
                        color: Color(0xffEBF2FB)
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Tip: Check your spam folder if you don't see the email in your inbox.",style:
                     TextStyle(fontSize: 18,color: Color(0xff1C398D)) ,
                      )
                      ),
                    ),
                ),



              ]
            );
          }
        )


    );
  }
}
