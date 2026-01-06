import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ChangePassword_Cubit.dart';
import 'ChangePassword_State.dart';
class Changepassword extends StatelessWidget {
  const Changepassword({super.key});

  @override
  Widget build(BuildContext context) {


    final ForgetPasswordKey=GlobalKey<FormState>();
    final cubit= context.read<ChangePasswordCubit>();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<ChangePasswordCubit,ChangePassword_State>(
            listener: (context,state){
              if (state is ChangePasswordSucsees) {
                Navigator.pushNamed(
                  context, 'test_page',

                );
              }
              else if(state is ChangePasswordError){
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
                        Text("OldPassword",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
                        TextFormField(

                          obscureText: !cubit.oldPasswordVisable,
                          onChanged: cubit.ChangeOldPassword,
                          validator: cubit.ValidateOldPassword,
                          decoration: InputDecoration(

                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                            hint: Text("Enter Old Password"),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(onPressed: (){
                              cubit.OldPasswordVisable();
                            }, icon: Icon(cubit.oldPasswordVisable?Icons.remove_red_eye:Icons.visibility_off)),


                          ),
                        ),
                        SizedBox(height: 15,),

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






                      ],
                    ),

                  )

                  ,
                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:  state is ChangePasswordLoding?  CircularProgressIndicator():  MaterialButton(onPressed: (){
                      if(ForgetPasswordKey.currentState!.validate()){
                        cubit.ChangeNewPassword();



                      }

                    },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: Color(0xff5A72A0),
                      minWidth: double.infinity,
                      height: 45,
                      child: Text("Send New Password ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
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
