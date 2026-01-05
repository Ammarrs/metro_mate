import 'package:flutter/material.dart';
class Setting extends StatelessWidget {
   Setting();

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [


        Center(
          child: Container(
            width: 280,
            height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  )
                ],
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 20),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined),
                      Text(
                        "Security & Privacy",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, 'ChangePassword');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Color(0xff5A72A0),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                             Text("Update Your Acount Pasword",style: TextStyle(fontSize: 10,color: Colors.grey),)
                            ],
                          ),
                        ),
                    
                        Icon(Icons.arrow_forward_ios_rounded,size: 20,),
                        SizedBox(width: 15,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )


      ],
    );
  }
}
