import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_project_db/service/database.dart';
import 'package:sqflite_project_db/service/emp_database.dart';
import 'package:sqflite_project_db/shared/model/emp_user_model.dart';
import 'package:sqflite_project_db/shared/model/user_model.dart';

class EmpUserProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController hireDateController = TextEditingController();
  TextEditingController isEmployeeOnVacationController =
      TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emergencyContactNameController =
      TextEditingController();
  TextEditingController emergencyContactPhoneController =
      TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  List<EmployeeModel> userList = [];
  EmpDatabaseHelper empDatabaseHelper = EmpDatabaseHelper();
  DateTime? selectedDate;
  String selectedValue = "Select";

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      context, title) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(title), duration: const Duration(seconds: 1)));
  }

  Future<void> selectDate(BuildContext context) async {
    selectedDate ?? (selectedDate = DateTime.now());
    notifyListeners();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      hireDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      notifyListeners();
    }
  }

  initControllerData(EmployeeModel employeeModel) {
    nameController.text = employeeModel.employeeName;
    emailController.text = employeeModel.employeeEmail;
    ageController.text = employeeModel.employeeAge.toString();
    positionController.text = employeeModel.employeePosition;
    salaryController.text =
        double.parse(employeeModel.employeeSalary.toString())
            .toStringAsFixed(0);
    departmentController.text = employeeModel.employeeDepartment;
    hireDateController.text =
        DateFormat('dd-MM-yyyy').format(employeeModel.employeeHireDate);
    isEmployeeOnVacationController.text =
        employeeModel.isEmployeeOnVacation == 0 ? "No" : "Yes";
    phoneNumberController.text = employeeModel.employeePhoneNumber.toString();
    emergencyContactNameController.text =
        employeeModel.employeeEmergencyContact.contactName;
    emergencyContactPhoneController.text =
        employeeModel.employeeEmergencyContact.contactPhoneNumber;
    relationshipController.text =
        employeeModel.employeeEmergencyContact.relationship;
    streetController.text = employeeModel.employeeAddress.street;
    cityController.text = employeeModel.employeeAddress.city;
    zipCodeController.text = employeeModel.employeeAddress.zipCode;
    selectedValue = employeeModel.isEmployeeOnVacation == 0 ? "No" : "Yes";
    selectedDate = employeeModel.employeeHireDate;
  }

  Widget buildDropdownButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: const TextStyle(color: Colors.white),
        value: selectedValue,
        dropdownColor: const Color(0xff0B1019),
        onChanged: (String? value) {
          selectedValue = value!;
          isEmployeeOnVacationController.text = value;
          notifyListeners();
        },
        items: <String>["Select", 'Yes', 'No'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  showSnackBarDialog(context) {
    if (nameController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user name");
      return true;
    } else if (emailController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user email");
      return true;
    } else if (!isValidEmail(emailController.text.trim())) {
      showSnackBar(context, "Please enter a valid email");
      return true;
    } else if (phoneNumberController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user mobile number");
      return true;
    } else if (phoneNumberController.text.trim().length < 10) {
      showSnackBar(context, "User mobile number should be 10 digits");
      return true;
    } else if (ageController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user age");
      return true;
    } else if (positionController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user position");
      return true;
    } else if (salaryController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user salary");
      return true;
    } else if (departmentController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user department");
      return true;
    } else if (hireDateController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter hire date");
      return true;
    } else if (isEmployeeOnVacationController.text.trim().isEmpty ||
        isEmployeeOnVacationController.text.trim() == "Select") {
      showSnackBar(context, "Please select employee on vacation");
      return true;
    } else if (emergencyContactNameController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter emergency contact name");
      return true;
    } else if (emergencyContactPhoneController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter emergency contact phone number");
      return true;
    } else if (relationshipController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user relationship");
      return true;
    } else if (streetController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user street");
      return true;
    } else if (cityController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user city");
      return true;
    } else if (zipCodeController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user zip code");
      return true;
    } else {
      return false;
    }
  }

  insertData(context) async {
    if (showSnackBarDialog(context)) {
      return;
    }
    await empDatabaseHelper.initDatabase();
    Address address = Address(
      street: streetController.text,
      city: cityController.text,
      zipCode: zipCodeController.text,
    );
    EmergencyContact emergencyContact = EmergencyContact(
      contactName: emergencyContactNameController.text,
      contactPhoneNumber: emergencyContactPhoneController.text,
      relationship: relationshipController.text,
    );
    EmployeeModel employee = EmployeeModel(
        employeeName: nameController.text,
        employeeAge: int.parse(ageController.text),
        employeePosition: positionController.text,
        employeeSalary: double.parse(salaryController.text),
        employeeDepartment: departmentController.text,
        employeeEmail: emailController.text,
        employeeHireDate: selectedDate ?? DateTime.now(),
        employeePhoneNumber: phoneNumberController.text,
        isEmployeeOnVacation: selectedValue == "No" ? 0 : 1,
        employeeEmergencyContact: emergencyContact,
        employeeAddress: address);
    await empDatabaseHelper.initDatabase();
    empDatabaseHelper.insertEmployee(employee);
    clearAllControllers();
    notifyListeners();
    showSnackBar(context, "User data added successfully");
    getUserData();
  }

  initData() async {
    await empDatabaseHelper.initDatabase();
    notifyListeners();
  }

  getUserData() async {
    userList = await empDatabaseHelper.getAllEmployees();
    notifyListeners();
  }

  updateUserData(id, context) async {
    if (showSnackBarDialog(context)) {
      return;
    }
    Address address = Address(
      street: streetController.text,
      city: cityController.text,
      zipCode: zipCodeController.text,
    );
    EmergencyContact emergencyContact = EmergencyContact(
      contactName: emergencyContactNameController.text,
      contactPhoneNumber: emergencyContactPhoneController.text,
      relationship: relationshipController.text,
    );
    EmployeeModel employee = EmployeeModel(
      employeeId: id,
      employeeName: nameController.text,
      employeeAge: int.parse(ageController.text),
      employeePosition: positionController.text,
      employeeSalary: double.parse(salaryController.text),
      employeeDepartment: departmentController.text,
      employeeEmail: emailController.text,
      employeeHireDate: selectedDate ?? DateTime.now(),
      employeePhoneNumber: phoneNumberController.text,
      isEmployeeOnVacation: selectedValue == "No" ? 0 : 1,
      employeeEmergencyContact: emergencyContact,
      employeeAddress: address,
    );
    await empDatabaseHelper.updateData(employee);
    // showSnackBar(context, "User data updated successfully");
  }

  deleteUserData(int id, context) async {
    await empDatabaseHelper.deleteData(id);
    showSnackBar(context, "User data deleted successfully");
  }

  closeDb() {
    empDatabaseHelper.closeDb();
  }

  void clearAllControllers() {
    nameController.clear();
    emailController.clear();
    ageController.clear();
    positionController.clear();
    salaryController.clear();
    departmentController.clear();
    hireDateController.clear();
    isEmployeeOnVacationController.clear();
    phoneNumberController.clear();
    emergencyContactNameController.clear();
    emergencyContactPhoneController.clear();
    relationshipController.clear();
    streetController.clear();
    cityController.clear();
    zipCodeController.clear();
    selectedDate = null;
    selectedValue = "Select";
    notifyListeners();
  }

  Widget buildTitle(title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget buildFieldData(controller, hintText, isReadOnly, keyBoardType,
      {VoidCallback? onTap, int? index}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: TextFormField(
            keyboardType: keyBoardType,
            readOnly: isReadOnly,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14),
              suffixIcon: onTap != null
                  ? IconButton(
                      onPressed: onTap,
                      icon: Icon(Icons.calendar_today),
                    )
                  : index != null
                      ? buildDropdownButton()
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}
