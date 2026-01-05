import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import '../../Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_State.dart';


class NewpasswordPage extends StatelessWidget {
   NewpasswordPage();

  @override
  Widget build(BuildContext context) {
    final EmailData=ModalRoute.of(context)!.settings.arguments ;

    final ForgetPasswordKey=GlobalKey<FormState>();
    final cubit= context.read<ForgetPasswordCubit>();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: Padding(
    padding: const EdgeInsets.all(15.0),
    child: BlocConsumer<ForgetPasswordCubit,ForgetPassword_State>(
        listener: (context,state){
          if (state is ForgetPasswordSucsees) {
            Navigator.pushNamed(
              context, 'Home',

            );
          }
          else if(state is ForgetPasswordError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.Error)));
          }

        },
      builder: (context,state) {

        return ListView(
        children: [
        Column(

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
        child: Icon(Icons.lock,size: 80,color: Colors.white,)

        ),


        ),
        SizedBox(height: 40,),
        Center(
        child: Text("Create New Password",
        style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black),
        )
        ),
        SizedBox(height: 20,),
        Center(
        child: Text('Your new password must be different from \npreviously used passwords.',
        style: TextStyle(
        fontSize: 17,
        color: Colors.grey),
        textAlign: TextAlign.center,
        )
        ),
        ]),
        SizedBox(height: 30,),






       Form(
        key: ForgetPasswordKey,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("NewPassword",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
            TextFormField(

            obscureText: !cubit.passwordVisble,
            onChanged: cubit.ChangePassword,
            validator: cubit.ValidatePassword,
            decoration: InputDecoration(

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            hint: Text("Enter new Password"),
            prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(onPressed: (){
                cubit.PasswordVisable();
              }, icon: Icon(cubit.passwordVisble?Icons.remove_red_eye:Icons.visibility_off)),


            ),
            ),
            SizedBox(height: 15,),
            Text("Confirm NewPassword",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
            TextFormField(
              obscureText: !cubit.conPasswordVisable,
              onChanged: cubit.ChangeConfirmPassword,
              validator: cubit.ValidateConfimPassword,
              decoration: InputDecoration(

                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                hint: Text("Re_enter new Password"),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(onPressed: (){
                  cubit.ConPasswordVisable();
                }, icon: Icon(cubit.conPasswordVisable?Icons.remove_red_eye:Icons.visibility_off)),


              ),
            ),
            SizedBox(height: 20,),
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
                          text: '$EmailData', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.blueAccent),
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


                    },

                  ),
                ],
              ),
            ),





          ],
        ),

        )

        ,
        SizedBox(height: 20,),

        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child:  state is ForgetPasswordLoding?  CircularProgressIndicator():  MaterialButton(onPressed: (){
        if(ForgetPasswordKey.currentState!.validate()){
          cubit.ResetPassword();



        }

        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff5A72A0),
        minWidth: double.infinity,
        height: 45,
        child: Text("Send Code ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
        ),
        ),


        ],
        );
      }
    ),
    ),

    );
  }
}
