// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_project_db/provider/emp_provider.dart';
import 'package:sqflite_project_db/provider/user_provider.dart';
import 'package:sqflite_project_db/shared/model/emp_user_model.dart';
import 'package:sqflite_project_db/shared/model/user_model.dart';

class EmpDetailsData extends StatefulWidget {
  final EmployeeModel? employeeModel;

  const EmpDetailsData({super.key, required this.employeeModel});

  @override
  State<EmpDetailsData> createState() => _EmpDetailsDataState();
}

class _EmpDetailsDataState extends State<EmpDetailsData> {
  bool isReadOnly = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Provider.of<EmpUserProvider>(context, listen: false)
          .initControllerData(widget.employeeModel!);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmpUserProvider>(
        builder: (BuildContext context, provider, child) {
          return WillPopScope(
            onWillPop: () async {
              provider.clearAllControllers();
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.employeeModel!.employeeName),
                centerTitle: true,
                actions: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          isReadOnly = !isReadOnly;
                        });
                      },
                      child: const Icon(Icons.edit)),
                  const SizedBox(width: 30)
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      provider.buildTitle("User Name"),
                      provider.buildFieldData(provider.nameController, "Enter Name",
                          isReadOnly, TextInputType.name),
                      provider.buildTitle("User Email"),
                      provider.buildFieldData(provider.emailController,
                          "Enter Email", isReadOnly, TextInputType.emailAddress),
                      provider.buildTitle("User Mobile"),
                      provider.buildFieldData(provider.phoneNumberController,
                          "Enter Mobile", isReadOnly, TextInputType.phone),
                      provider.buildTitle("User Age"),
                      provider.buildFieldData(provider.ageController, "Enter Age",
                          isReadOnly, TextInputType.number),
                      provider.buildTitle("Salary"),
                      provider.buildFieldData(provider.salaryController, 'Salary',
                          isReadOnly, TextInputType.number),
                      provider.buildTitle("Department"),
                      provider.buildFieldData(provider.departmentController,
                          'Department', isReadOnly, TextInputType.text),
                      provider.buildTitle("Hire Date"),
                      provider.buildFieldData(provider.hireDateController,
                          'Hire Date', true, TextInputType.number,
                          onTap: () => provider.selectDate(context)),
                      provider.buildTitle("Employee Vacation"),
                      provider.buildFieldData(
                          provider.isEmployeeOnVacationController,
                          'Select',
                          true,
                          TextInputType.number,
                          index: 1),
                      provider.buildTitle("Emergency Contact Name"),
                      provider.buildFieldData(
                          provider.emergencyContactNameController,
                          'Emergency Contact Name',
                          isReadOnly,
                          TextInputType.name),
                      provider.buildTitle("Emergency Contact Phone"),
                      provider.buildFieldData(
                          provider.emergencyContactPhoneController,
                          'Emergency Contact Phone',
                          isReadOnly,
                          TextInputType.phone),
                      provider.buildTitle("Relationship"),
                      provider.buildFieldData(provider.relationshipController,
                          'Relationship', isReadOnly, TextInputType.text),
                      provider.buildTitle("Street"),
                      provider.buildFieldData(provider.streetController, 'Street',
                          isReadOnly, TextInputType.text),
                      provider.buildTitle("City"),
                      provider.buildFieldData(provider.cityController, 'City',
                          isReadOnly, TextInputType.phone),
                      provider.buildTitle("Zip Code"),
                      provider.buildFieldData(provider.zipCodeController,
                          'Zip Code', isReadOnly, TextInputType.phone),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isReadOnly
                              ? const SizedBox(width: 0)
                              : ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return buildAlertDialog(context, provider,
                                          'Confirm Update', "Update");
                                    });
                              },
                              child: const Text("Update Data")),
                          isReadOnly
                              ? const SizedBox(width: 0)
                              : const SizedBox(width: 30),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return buildAlertDialog(context, provider,
                                          'Confirm Delete', "Delete");
                                    });
                              },
                              child: const Text("Delete Data"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget buildAlertDialog(
      BuildContext context, EmpUserProvider provider, title, status) {
    return AlertDialog(
      title: Text(title),
      content: Text('Are you sure you want to $status this user data?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (status == "Update") {
                provider.updateUserData(widget.employeeModel!.employeeId!, context);
                Navigator.of(context).pop();
                isReadOnly = true;
                setState(() {});
              } else {
                provider.deleteUserData(widget.employeeModel!.employeeId!, context);
                Navigator.of(context).pop();
                Navigator.pop(context);
              }
            },
            child: Text(status)),
      ],
    );
  }
}
