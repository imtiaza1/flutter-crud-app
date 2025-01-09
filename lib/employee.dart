import 'package:crud/service/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController locationController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Employee",
            style: TextStyle(
                color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Form",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          )
        ],
      )),
      body: Container(
        margin: EdgeInsets.only(left: 20,top: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(color: Colors.black,fontSize: 20),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Age",
              style: TextStyle(color: Colors.black,fontSize: 20),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Location",
              style: TextStyle(color: Colors.black,fontSize: 20),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async{
                  String Id=randomAlphaNumeric(10);
                  Map<String,dynamic> employeeInfoMap={
                    "Name":nameController.text.toString(),
                    "Age":ageController.text.toString(),
                    "Location":locationController.text.toString(),
                    "id":Id,
                  };
                  await DataBaseMethod().addEmployeeDetails(employeeInfoMap, Id);
                  Fluttertoast.showToast(
                    msg: "data saved in the data base",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Text("Save Data"))
          ],
        ),
      ),
    );
  }
}
