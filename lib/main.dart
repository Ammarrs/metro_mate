import 'package:flutter/material.dart';

void main() {
  runApp(MetroMate());
}

class MetroMate extends StatelessWidget {
  const MetroMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(270),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.5,
            automaticallyImplyLeading: false,
            centerTitle: true,
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: 80),
              decoration: BoxDecoration(
                gradient: LinearGradient(stops: [0,1,0.56], begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFF5A73A1),Color(0xFF45C4E0),Color(0xB800A5FF)])
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            "assets/images/train_black.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text("Metro Mate", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white,
                    ),),
                    Padding(padding: EdgeInsets.only(bottom: 2)),
                    // SizedBox(height: 4,),
                    Text("Welcome back!", style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),)
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF45c4e0), const Color(0xFF5a74a2)],
                  ),
                ),
              ),
              Text("data"),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
