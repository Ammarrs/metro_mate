import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:second/Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import 'package:second/Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_State.dart';
/*class VerifyEmail extends StatelessWidget {
   VerifyEmail();

  @override
  Widget build(BuildContext context) {

    final cubit= context.read<ForgetPasswordCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
     body:BlocConsumer<ForgetPasswordCubit,ForgetPassword_State>(
       listener: (context,state){
         if (state is ForgetPasswordSucsees) {
           Navigator.pushNamed(
             context, 'NewpasswordPage',

           );
         }
         else if(state is ForgetPasswordError){
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Valid Otp")));
         }

       },
       builder: (context,state) {

         return ListView(
             children: [
               Center(
                 child: Container(
                     width: 150,height: 150,
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
                     child: Icon(Icons.verified_user_sharp,size: 80,color: Colors.white,)

                 ),


               ),
               SizedBox(height: 40,),

         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text('Verify Your Email',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
               SizedBox(height: 15,),

               Text.rich(
                 textAlign: TextAlign.center,
                 style: TextStyle(fontSize: 15,color: Colors.grey),
                 TextSpan(
                   text: "Enter the 5-digit code we sent to \n ",
                   children: [
                     TextSpan(
                       text: 'e', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.blueAccent),
                     ),
                     TextSpan(
                       text: "to verify your \nidentity."

                     )
                   ],

                 ),
               ),
               SizedBox(height: 80,),
               state is ForgetPasswordLoding? CircularProgressIndicator(): OTPTextField(
                 onChanged: cubit.ChangOtp,

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
               SizedBox(height: 70,),

               Center(
                 child: MaterialButton(onPressed: (){},
                   child: Text("Resend Code",style: TextStyle(color: Colors.blueAccent,fontWeight:FontWeight.bold),),),
               )

             ],
           ),
         ),
             ]);
       }
     )
    ,

    );
  }
}*/
