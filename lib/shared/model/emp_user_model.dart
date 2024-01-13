class EmployeeModel {
  int? employeeId;
  String employeeName;
  int employeeAge;
  String employeePosition;
  double employeeSalary;
  String employeeDepartment;
  String employeeEmail;
  DateTime employeeHireDate;
  String employeePhoneNumber;
  int isEmployeeOnVacation;
  EmergencyContact employeeEmergencyContact;
  Address employeeAddress;

  EmployeeModel({
     this.employeeId,
    required this.employeeName,
    required this.employeeAge,
    required this.employeePosition,
    required this.employeeSalary,
    required this.employeeDepartment,
    required this.employeeEmail,
    required this.employeeHireDate,
    required this.employeePhoneNumber,
    required this.isEmployeeOnVacation,
    required this.employeeEmergencyContact,
    required this.employeeAddress,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      employeeAge: json['employeeAge'],
      employeePosition: json['employeePosition'],
      employeeSalary: json['employeeSalary'].toDouble(),
      employeeDepartment: json['employeeDepartment'],
      employeeEmail: json['employeeEmail'],
      employeeHireDate: DateTime.parse(json['employeeHireDate']),
      employeePhoneNumber: json['employeePhoneNumber'],
      isEmployeeOnVacation: json['isEmployeeOnVacation'],
      employeeEmergencyContact:
          EmergencyContact.fromJson(json['employeeEmergencyContact']),
      employeeAddress: Address.fromJson(json['employeeAddress']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeeAge': employeeAge,
      'employeePosition': employeePosition,
      'employeeSalary': employeeSalary,
      'employeeDepartment': employeeDepartment,
      'employeeEmail': employeeEmail,
      'employeeHireDate': employeeHireDate.toIso8601String(),
      'employeePhoneNumber': employeePhoneNumber,
      'isEmployeeOnVacation': isEmployeeOnVacation,
      'employeeEmergencyContact': employeeEmergencyContact.toJson(),
      'employeeAddress': employeeAddress.toJson(),
    };
  }
}

class EmergencyContact {
  String contactName;
  String contactPhoneNumber;
  String relationship;

  EmergencyContact({
    required this.contactName,
    required this.contactPhoneNumber,
    required this.relationship,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      contactName: json['contactName'],
      contactPhoneNumber: json['contactPhoneNumber'],
      relationship: json['relationship'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactName': contactName,
      'contactPhoneNumber': contactPhoneNumber,
      'relationship': relationship,
    };
  }
}

class Address {
  String street;
  String city;
  String zipCode;

  Address({
    required this.street,
    required this.city,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'zipCode': zipCode,
    };
  }
}
