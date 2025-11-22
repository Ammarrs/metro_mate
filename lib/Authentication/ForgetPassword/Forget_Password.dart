import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import 'package:second/Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_State.dart';
class ForgetPassword extends StatelessWidget {
   ForgetPassword();

  @override
  Widget build(BuildContext context) {
    final EmailControllerPassword=TextEditingController();
    final ForgetPasswordKey=GlobalKey<FormState>();
    return  Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child:  BlocConsumer<ForgetPasswordCubit,ForgetPassword_State> (
          listener: (context,state){

            if (state is ForgetPasswordSucsees){

                Navigator.pushNamed(
                    context,'NewpasswordPage',
                    arguments: EmailControllerPassword.text
                );



            }
            else if(state is ForgetPasswordError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Valid Email")));
            }

          },
            builder: (context,state) {
              final cubit= context.read<ForgetPasswordCubit>();

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
                          child: Icon(Icons.email,size: 80,color: Colors.white,)

                      ),


                    ),
                    SizedBox(height: 40,),
                    Center(
                        child: Text("Forgot Password?",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                    ),
                    SizedBox(height: 20,),
                    Center(
                        child: Text('Don\'t worry! Enter your email address and\n we\'ll send you a code to reset your\n password.',
                          style: TextStyle(
                            fontSize: 17,
                              color: Colors.grey),
                          textAlign: TextAlign.center,
                        )
                    ),
                ]),
                    SizedBox(height: 30,),
                    Text("Email Address",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),

                   Form(
                            key: ForgetPasswordKey,
                              child:TextFormField(
                                controller: EmailControllerPassword,
                                onChanged: cubit.ChangeEmail,
                                validator: cubit.ValidateEmail,
                                decoration: InputDecoration(

                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                  hint: Text("Enter your Email Address"),
                                  prefixIcon: Icon(Icons.email),


                                ),
                              ),

                          )

                      ,
                    SizedBox(height: 20,),

              Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:  state is ForgetPasswordLoding?  CircularProgressIndicator():  MaterialButton(onPressed: (){

                        if(ForgetPasswordKey.currentState!.validate()){
                          cubit.SendCode();

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


