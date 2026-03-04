import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/Bloc/SelectRoute_State.dart';
import 'package:second/Bloc/selectRoute_Cubit.dart';
import 'package:bloc/bloc.dart';

class PlanYorRoute extends StatelessWidget {
  const PlanYorRoute({
    super.key,
    required this.cubit,
  });

  final SelectRoute cubit;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: 500,
        minHeight: screenHeight * 0.38,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(1, 2),
          )
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.01),
            
            // Title
            const Text(
              " Plan Your Route  ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // First dropdown - From Station
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: DropdownSearch<String>(
                asyncItems: (String? filter) async {
                  return await cubit.getStations();
                },
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
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
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  showSearchBox: true,
                  showSelectedItems: true,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
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
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black26,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                onChanged: (v) {
                  cubit.setStation1(v!);
                  print(cubit.Station1);
                },
                selectedItem: cubit.Station1,
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Arrow icons
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward),
                Icon(Icons.arrow_downward),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),

            // Second dropdown - To Station
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: DropdownSearch<String>(
                asyncItems: (String? filter) async {
                  return await cubit.getStations();
                },
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
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
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  showSearchBox: true,
                  showSelectedItems: true,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
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
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black26,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                onChanged: (v) {
                  cubit.setStation2(v!);
                  print(cubit.Station2);
                },
                selectedItem: cubit.Station2,
              ),
            ),

            SizedBox(height: screenHeight * 0.025),

            // Search button
            Center(
              child: BlocBuilder<SelectRoute, RouteState>(
                bloc: cubit,
                builder: (context, state) {
                  return MaterialButton(
                    onPressed: () {
                      if (cubit.ValidateStation() != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(cubit.ValidateStation()),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      cubit.getInfoStation();
                      cubit.ShowStations();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minWidth: screenWidth * 0.55,
                    color: const Color(0xff5A72A0),
                    hoverColor: Colors.blue.shade900,
                    child: state is InfoLodingState
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              Text(
                                "\t Search Route",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}