import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
class Tickets extends StatelessWidget {
  const Tickets({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit= context.read<SelectRoute>();

    return  BlocConsumer<SelectRoute,RouteState>(
        listener: (context,state){
          if (state is InfoErorrState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.Error),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is InfoSucessState) {
            cubit.Show();

              cubit.ClearSelection();

          }


        },
        builder: (context,state) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                Container(
                  width: 400,
                  height: 450,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 30,),
                        Text(" Ticket Price  ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 15.0),
                          child: DropdownSearch<String>(
                              asyncItems: (String?filter)async{
                                return await cubit.getStations();
                              },




                              popupProps: PopupProps.menu(

                                itemBuilder: (context, item, isSelected) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:  Colors.white,
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight:  FontWeight.bold ,
                                      ),
                                    ),
                                  );
                                },

                                menuProps: MenuProps(


                                  borderRadius: BorderRadius.circular(15),
                                  elevation: 8,
                                  shadowColor: Colors.black54,
                                ),
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: "Search station...",
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),

                                showSearchBox: true,
                                showSelectedItems: true,
                              ),

                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Select Station",
                                  hintText: "Choose Metro Station",
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffF8F9FB),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black26, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),

                                ),

                              ),




                              onChanged:(v){
                                cubit.setStation1(v!);
                                print(cubit.Station1); },

                              selectedItem: cubit.Station1),
                        ),
                        SizedBox(height: 20,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_upward),
                            Icon(Icons.arrow_downward),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 15.0),
                          child: DropdownSearch<String>(
                              asyncItems: (String?filter)async{
                                return await cubit.getStations();
                              },




                              popupProps: PopupProps.menu(

                                itemBuilder: (context, item, isSelected) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:  Colors.white,
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight:  FontWeight.bold ,
                                      ),
                                    ),
                                  );
                                },

                                menuProps: MenuProps(


                                  borderRadius: BorderRadius.circular(15),
                                  elevation: 8,
                                  shadowColor: Colors.black54,
                                ),
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: "Search station...",
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),

                                showSearchBox: true,
                                showSelectedItems: true,
                              ),

                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Select Station",
                                  hintText: "Choose Metro Station",
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffF8F9FB),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black26, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),

                                ),

                              ),

                              onChanged:(v){
                                cubit.setStation2(v!);
                                print(cubit.Station2); },

                              selectedItem: cubit.Station2),
                        ),

                        SizedBox(height: 20,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_upward),
                            Icon(Icons.arrow_downward),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 15.0),
                          child: DropdownSearch<String>(
                              asyncItems: (String?filter)async{
                                return await cubit.NumberofPersons;
                              },




                              popupProps: PopupProps.menu(

                                itemBuilder: (context, item, isSelected) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:  Colors.white,
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight:  FontWeight.bold ,
                                      ),
                                    ),
                                  );
                                },

                                menuProps: MenuProps(


                                  borderRadius: BorderRadius.circular(15),
                                  elevation: 8,
                                  shadowColor: Colors.black54,
                                ),
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: "Choose Number of Persons ...",
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),

                                showSearchBox: true,
                                showSelectedItems: true,
                              ),

                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Select persons",
                                  hintText: "Choose Metro Station",
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffF8F9FB),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black26, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),

                                ),

                              ),

                              onChanged:(v){
                                cubit.SetPerson(v!);
                                print(cubit.person); },

                              selectedItem: cubit.person),
                        ),

                        SizedBox(height: 30,),
                        Center(
                          child: MaterialButton(onPressed: (){
                            if (cubit.ValidateTicketPrice() != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(cubit.ValidateTicketPrice()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }




                            cubit.getInfoStation();
                            cubit.TotalPrice();


                          },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                            minWidth: 230,
                            color: Color(0xff5A72A0),
                            hoverColor: Colors.blue.shade900,
                            child:state is InfoLodingState
                                ? CircularProgressIndicator(color: Colors.white)
                                : Row(mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.search,color: Colors.white,),
                                Text("\t Calculate Price",style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                cubit.Selected==true ? Container(
                  width: 200,
                  height: 250,
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
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Trip Information",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              child:
                              Icon(Icons.access_time,
                                color: Color(0xff5A72A0),),
                              backgroundColor: Colors.grey.shade100,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                Text("Duration",style: TextStyle(color: Colors.grey),),
                                Text("${cubit.time} Minutes")
                              ],
                            ),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              child:
                              Icon(Icons.location_on_outlined,
                                color: Color(0xff5A72A0),),
                              backgroundColor: Colors.grey.shade100,
                            ),
                            Column(
                              children: [
                                Text("Distance",style: TextStyle(color: Colors.grey),),
                                Text("${cubit.distance} KM")
                              ],
                            ),

                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              child:
                              Icon(Icons.arrow_forward,
                                color: Color(0xff5A72A0),),
                              backgroundColor: Colors.grey.shade100,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Transfer",style: TextStyle(color: Colors.grey),),
                                Text("${cubit.numStation}")
                              ],
                            ),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              child:
                              Icon(FontAwesomeIcons.moneyBill1,
                                color: Color(0xff5A72A0),),
                              backgroundColor: Colors.grey.shade100,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Price",style: TextStyle(color: Colors.grey),),

                                Text( " EGP${cubit.totalPrice }")
                              ],
                            ),

                          ],
                        )
                      ],
                    ),
                  ),

                ):SizedBox(height: 20,),
                SizedBox(height: 15,),

              ],
            ),
          );
        }
    );
  }
}

