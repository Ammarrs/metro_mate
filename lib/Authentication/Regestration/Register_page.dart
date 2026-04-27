import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second/generated/l10n.dart' show S;

import '../../Authentication_Cubit/Register_Cubit/Register_Cubit.dart';
import '../../Authentication_Cubit/Register_Cubit/Register_State.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailController = TextEditingController();
    final FormKey = GlobalKey<FormState>();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 150.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "loginPage");
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white54,
              ),
              label: Text(
                S.of(context).Back,
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
            children: [
              Container(
                child: Icon(
                  FontAwesomeIcons.trainSubway,
                  size: 70,
                  color: Colors.white,
                ),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xffA8CBDF),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                S.of(context).MetroMate,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).CreateAccount,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          toolbarHeight: 250,
          leadingWidth: 80,
          centerTitle: true,
        ),
        body: BlocConsumer<RegisterCubit, Register_State>(
            listener: (context, state) {
          if (state is RegisterSucsess) {
            Navigator.pushNamed(context, 'RegisterOtp',
                arguments: EmailController.text);
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.Error)));
          }
        }, builder: (context, state) {
          final cubit = context.read<RegisterCubit>();
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(S.of(context).ProfilePicture,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        //SizedBox(width: 40,),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: cubit.profileImage != null
                              ? FileImage(cubit.profileImage!)
                              : null,
                          child: cubit.profileImage == null
                              ? Icon(FontAwesomeIcons.user,
                                  size: 60, color: Colors.grey)
                              : null,
                        ),

                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xff5A72A0),
                          child: PopupMenuButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(S.of(context).Camera),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    cubit.pickImage(ImageSource.camera);
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Text(S.of(context).Gallery),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    cubit.pickImage(ImageSource.gallery);
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(S.of(context).UploadProfilePicture)
                  ],
                ),
              ),
              Form(
                  key: FormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).FullName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          onChanged: cubit.ChangeName,
                          validator: cubit.ValidateName,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            hint: Text(S.of(context).EnterFullName),
                            prefixIcon: Icon(FontAwesomeIcons.user),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).EmailAddress,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: EmailController,
                          onChanged: cubit.ChangeEmail,
                          validator: cubit.ValidateEmail,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            hint: Text(S.of(context).EnterEmail),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).Password,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          onChanged: cubit.ChangePassword,
                          validator: cubit.ValidatePassword,
                          obscureText: !cubit.passwordVisable,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              hint: Text(S.of(context).EnterPassword),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.PasswordVisable();
                                  },
                                  icon: Icon(cubit.passwordVisable
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).ConfirmPassword,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          onChanged: cubit.ChangeConfimPassword,
                          validator: cubit.ValidateConfimPassword,
                          obscureText: !cubit.ConfirmPasswordVisable,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              hint: Text(S.of(context).EnterConfirmPassword),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.ConPasswordVisable();
                                  },
                                  icon: Icon(cubit.ConfirmPasswordVisable
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).PhoneNumber,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          onChanged: cubit.ChangePhone,
                          validator: cubit.validatePhone,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            hint: Text(S.of(context).EnterPhone),
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).Gender,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        RadioListTile(
                          value: 'male',
                          groupValue: cubit.gender,
                          onChanged: (value) {
                            if (value != null) {
                              cubit.ChangeGender(value);
                            }
                          },
                          title: Text(
                            S.of(context).Male,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile(
                            value: 'female',
                            groupValue: cubit.gender,
                            onChanged: (value) {
                              if (value != null) {
                                cubit.ChangeGender(value);
                              }
                            },
                            title: Text(
                              S.of(context).Female,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: state is RegisterLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.blue,
                      ))
                    : MaterialButton(
                        onPressed: () {
                          if (FormKey.currentState!.validate()) {
                            if (!cubit.CheckGender()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(S.of(context).ChooseGender)));
                            } else {
                              cubit.SignUp();
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Color(0xff5A72A0),
                        minWidth: double.infinity,
                        height: 45,
                        child: Text(
                          S.of(context).SignUp,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).AlreadyHaveAccount),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'loginPage');
                    },
                    child: Text(
                      S.of(context).Login,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        }));
  }
}
