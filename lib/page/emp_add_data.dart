import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_project_db/provider/emp_provider.dart';

class EmpAddDataPage extends StatefulWidget {
  const EmpAddDataPage({super.key});

  @override
  State<EmpAddDataPage> createState() => _EmpAddDataPageState();
}

class _EmpAddDataPageState extends State<EmpAddDataPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmpUserProvider>(builder: (context, provider, child) {
      return WillPopScope(
          onWillPop: () async {
            provider.clearAllControllers();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
                title: InkWell(
                    onTap: () {
                      // provider.initData();
                    },
                    child: const Text("Add Emp Data")),
                centerTitle: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    provider.buildTitle("Name"),
                    provider.buildFieldData(provider.nameController, 'Name',
                        false, TextInputType.text),
                    provider.buildTitle("Email"),
                    provider.buildFieldData(provider.emailController, 'Email',
                        false, TextInputType.emailAddress),
                    provider.buildTitle("Phone Number"),
                    provider.buildFieldData(provider.phoneNumberController,
                        'Phone Number', false, TextInputType.phone),
                    provider.buildTitle("Position"),
                    provider.buildFieldData(provider.positionController,
                        'Position', false, TextInputType.text),
                    provider.buildTitle("Age"),
                    provider.buildFieldData(provider.ageController, 'Age',
                        false, TextInputType.number),
                    provider.buildTitle("Salary"),
                    provider.buildFieldData(provider.salaryController, 'Salary',
                        false, TextInputType.number),
                    provider.buildTitle("Department"),
                    provider.buildFieldData(provider.departmentController,
                        'Department', false, TextInputType.text),
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
                        false,
                        TextInputType.name),
                    provider.buildTitle("Emergency Contact Phone"),
                    provider.buildFieldData(
                        provider.emergencyContactPhoneController,
                        'Emergency Contact Phone',
                        false,
                        TextInputType.phone),
                    provider.buildTitle("Relationship"),
                    provider.buildFieldData(provider.relationshipController,
                        'Relationship', false, TextInputType.text),
                    provider.buildTitle("Street"),
                    provider.buildFieldData(provider.streetController, 'Street',
                        false, TextInputType.text),
                    provider.buildTitle("City"),
                    provider.buildFieldData(provider.cityController, 'City',
                        false, TextInputType.name),
                    provider.buildTitle("Zip Code"),
                    provider.buildFieldData(provider.zipCodeController,
                        'Zip Code', false, TextInputType.phone),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              provider.insertData(context);
                              setState(() {});
                            },
                            child: const Text("Submit User Data")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
