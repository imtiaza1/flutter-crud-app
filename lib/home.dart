import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/employee.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController locationController=TextEditingController();
  // _HomeState({required this.id});
  // Edit Employee Details Method
  Future<void> editEmployeeDetail(BuildContext context, String id) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          width: double.maxFinite, // Ensures the dialog doesn't shrink too much
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures content is as small as needed
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align the cancel icon to the right
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the dialog on tap
                    },
                    child: Icon(Icons.cancel, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 20), // Add spacing
              Text(
                "Edit Employee Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // Add spacing
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance.collection("employee").doc(id).update({
                      "Name": nameController.text,
                      "Age": int.tryParse(ageController.text) ?? ageController.text, // Convert age to integer if possible
                      "Location": locationController.text,
                    });
                    Navigator.pop(context); // Close the dialog after successful update
                    // You can add a success message here if needed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Employee details updated successfully")),
                    );
                  } catch (e) {
                    // Handle any errors during the update
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error updating employee details: $e")),
                    );
                  }
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Employee()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Crud",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("employee").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "An error occurred. Please try again later.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data?.docs;

            // Check if data is empty
            if (data == null || data.isEmpty) {
              return const Center(
                child: Text(
                  "No Employee Data Available",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  child: Column(
                    children: [
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name : ${data[index]["Name"]}",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      nameController.text=data[index]["Name"];
                                      ageController.text=data[index]["Age"].toString();
                                      locationController.text=data[index]["Location"];
                                      // Pass the actual document ID to the edit function
                                      editEmployeeDetail(context, data[index]["id"]);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        String documentId = data[index].id;
                                        // Deleting the document
                                        await FirebaseFirestore.instance.collection("employee").doc(documentId).delete();

                                        // Showing a confirmation message to the user
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Employee deleted successfully."),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } catch (error) {
                                        // Handling any errors and showing a message
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Failed to delete employee: $error"),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Age : ${data[index]["Age"]}",
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Location : ${data[index]["Location"]}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "Unexpected error occurred.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
