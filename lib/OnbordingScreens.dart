import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:second/views/login_view.dart';


import 'package:shared_preferences/shared_preferences.dart';


import 'block/Cubit.dart';
import 'block/state_cubit.dart';
import 'main.dart';


class Onbordingscreen extends StatelessWidget {
  const Onbordingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        if (state is OnBordingIntial) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is OnBordingSeen) {
          return LoginPage();
        } else {
          final controller=PageController();
          return Scaffold(
            body: PageView(
              controller: controller,

              children: [

                Container(
                  width: double.infinity,
                  height:double.infinity,

                  decoration: BoxDecoration(
                  color: Color(0xff6D94BB)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 240.0,top: 20),
                            child: TextButton(

                              onPressed: () async {
                                await context.read<OnBoardingCubit>().SetSeen();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) =>  LoginPage()),
                                );
                              },
                              child: const Text(
                                "Skip",
                                style: TextStyle(color: Color(0xff6B7688),fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Image.asset("assets/images/location.jpeg",width: 250,height: 250),
                          SizedBox(height: 20,),
                          Text('Find Your Way', style: TextStyle(fontSize: 32)),
                          SizedBox(height: 20,),
                          Text(textAlign: TextAlign.center,
                            'Easily check metro routes and directions\n from one station to another.', style: TextStyle(fontSize: 16) ,),
                          SizedBox(height: 150,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Container(
                            width: 30,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xff5A72A0),
                            ),
                          ),SizedBox(width: 6,),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),

                              ),SizedBox(width: 6,)
                              ,Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),
                              )

                            ],

                          ),

                          SizedBox(height: 30,),
                          MaterialButton(onPressed: () {
                            controller.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
                          },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              height: 40,
                              minWidth: double.infinity,
                              color: Color(0xff5A72A0),
                              child: Text('Next   >',style: TextStyle(fontSize: 20,color: Colors.white),) ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height:double.infinity,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF6DD5FA), // Light Blue
                        Color(0xFF2980B9), // Deep Blue
                      ],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 240.0,top: 20),
                            child: TextButton(

                              onPressed: () async {
                                await context.read<OnBoardingCubit>().SetSeen();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) =>  LoginPage()),
                                );
                              },
                              child: const Text(
                                "Skip",
                                style: TextStyle(color: Color(0xff6B7688),fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Image.asset("assets/images/Ticket.jpeg"),
                          SizedBox(height: 20,),
                          Text('Buy Tickets', style: TextStyle(fontSize: 32)),
                          SizedBox(height: 20,),
                          Text(textAlign: TextAlign.center,
                            'Purchase daily tickets instantly with your\n card or wallet.', style: TextStyle(fontSize: 16) ,),
                          SizedBox(height: 150,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),
                              ),SizedBox(width: 6,),
                              Container(
                                width: 30,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:Colors.blue.shade300
                                ),

                              ),SizedBox(width: 6,)
                              ,Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),
                              )

                            ],

                          ),

                          SizedBox(height: 30,),
                          MaterialButton(onPressed: () {
                            controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
                          },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              height: 40,
                              minWidth: double.infinity,
                              color:Colors.blue.shade300,
                              child: Text('Next   >',style: TextStyle(fontSize: 20,color: Colors.white),) ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height:double.infinity,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFA6C9E2), // Light Blue
                        Color(0xFF6FAEDB), // Soft Blue
                      ],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 240.0,top: 20),
                            child: TextButton(

                              onPressed: () async {
                                await context.read<OnBoardingCubit>().SetSeen();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) =>  LoginPage()),
                                );
                              },
                              child: const Text(
                                "Skip",
                                style: TextStyle(color: Color(0xff6B7688),fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Image.asset('assets/images/Graduate.jpeg',width: 250,height: 250,),
                          SizedBox(height: 20,),
                          Text('Student Discounts', style: TextStyle(fontSize: 32)),
                          SizedBox(height: 20,),
                          Text(textAlign: TextAlign.center,
                            'Get metro subscriptions at discounted \nprices for students.', style: TextStyle(fontSize: 16) ,),
                          SizedBox(height: 150,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),
                              ),SizedBox(width: 6,),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),

                              ),SizedBox(width: 6,)
                              ,Container(
                                width: 30,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white54
                                ),
                              )

                            ],

                          ),

                          SizedBox(height: 30,),
                          MaterialButton(onPressed: () async {
                            await context.read<OnBoardingCubit>().SetSeen();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) =>  LoginPage()),
                            );
                          },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              height: 40,
                              minWidth: double.infinity,
                              color: Colors.white54,
                              child: Text('Get Started   >',style: TextStyle(fontSize: 20,color: Colors.white),) ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
